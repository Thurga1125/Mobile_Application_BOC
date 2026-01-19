const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { db, admin } = require('../server');

router.use(authMiddleware);

// GET /api/v1/transactions
router.get('/', async (req, res) => {
  try {
    const userId = req.user.userId;
    const { limit = 20, accountId } = req.query;

    let query = db.collection('transactions')
      .where('userId', '==', userId)
      .orderBy('transactionDate', 'desc')
      .limit(parseInt(limit));

    if (accountId) {
      query = query.where('accountId', '==', accountId);
    }

    const transactionsSnapshot = await query.get();

    const transactions = transactionsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      transactionDate: doc.data().transactionDate?.toDate()
    }));

    res.json({
      success: true,
      data: transactions
    });

  } catch (error) {
    console.error('Get transactions error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch transactions',
      error: error.message
    });
  }
});

// POST /api/v1/transactions/transfer
router.post('/transfer', async (req, res) => {
  try {
    const userId = req.user.userId;
    const { fromAccountId, toAccountNumber, amount, description } = req.body;

    // Validate input
    if (!fromAccountId || !toAccountNumber || !amount) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields'
      });
    }

    // Get from account
    const fromAccountDoc = await db.collection('accounts').doc(fromAccountId).get();
    if (!fromAccountDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Source account not found'
      });
    }

    const fromAccount = fromAccountDoc.data();

    // Check ownership
    if (fromAccount.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Check balance
    if (fromAccount.availableBalance < amount) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient balance'
      });
    }

    // Get to account
    const toAccountSnapshot = await db.collection('accounts')
      .where('accountNumber', '==', toAccountNumber)
      .get();

    if (toAccountSnapshot.empty) {
      return res.status(404).json({
        success: false,
        message: 'Destination account not found'
      });
    }

    const toAccountDoc = toAccountSnapshot.docs[0];
    const toAccount = toAccountDoc.data();

    // Create transaction reference
    const transactionRef = `TXN${Date.now()}`;

    // Use Firestore transaction for atomicity
    await db.runTransaction(async (transaction) => {
      // Deduct from source account
      transaction.update(fromAccountDoc.ref, {
        balance: admin.firestore.FieldValue.increment(-amount),
        availableBalance: admin.firestore.FieldValue.increment(-amount)
      });

      // Add to destination account
      transaction.update(toAccountDoc.ref, {
        balance: admin.firestore.FieldValue.increment(amount),
        availableBalance: admin.firestore.FieldValue.increment(amount)
      });

      // Create transaction record
      const transactionData = {
        userId,
        accountId: fromAccountId,
        transactionReference: transactionRef,
        type: 'transfer',
        amount,
        currency: fromAccount.currency,
        fee: 0,
        balanceBefore: fromAccount.balance,
        balanceAfter: fromAccount.balance - amount,
        description: description || 'Fund Transfer',
        fromAccountNumber: fromAccount.accountNumber,
        toAccountNumber,
        recipientName: toAccount.accountHolderName || 'Unknown',
        status: 'completed',
        transactionDate: new Date()
      };

      transaction.set(db.collection('transactions').doc(), transactionData);
    });

    res.json({
      success: true,
      message: 'Transfer successful',
      data: {
        transactionReference: transactionRef,
        amount,
        fromAccount: fromAccount.accountNumber,
        toAccount: toAccountNumber
      }
    });

  } catch (error) {
    console.error('Transfer error:', error);
    res.status(500).json({
      success: false,
      message: 'Transfer failed',
      error: error.message
    });
  }
});

module.exports = router;