const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { db } = require('../server');

router.use(authMiddleware);

// GET /api/v1/bills
router.get('/', async (req, res) => {
  try {
    const userId = req.user.userId;

    const billsSnapshot = await db.collection('bills')
      .where('userId', '==', userId)
      .orderBy('dueDate', 'asc')
      .get();

    const bills = billsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      dueDate: doc.data().dueDate?.toDate(),
      paymentDate: doc.data().paymentDate?.toDate()
    }));

    res.json({
      success: true,
      data: bills
    });

  } catch (error) {
    console.error('Get bills error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch bills',
      error: error.message
    });
  }
});

// POST /api/v1/bills/pay
router.post('/pay', async (req, res) => {
  try {
    const userId = req.user.userId;
    const { billId, accountId } = req.body;

    // Get bill
    const billDoc = await db.collection('bills').doc(billId).get();
    if (!billDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Bill not found'
      });
    }

    const bill = billDoc.data();

    // Check ownership
    if (bill.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    // Get account
    const accountDoc = await db.collection('accounts').doc(accountId).get();
    if (!accountDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Account not found'
      });
    }

    const account = accountDoc.data();

    // Check balance
    if (account.availableBalance < bill.amount) {
      return res.status(400).json({
        success: false,
        message: 'Insufficient balance'
      });
    }

    // Process payment in transaction
    await db.runTransaction(async (transaction) => {
      // Deduct from account
      transaction.update(accountDoc.ref, {
        balance: account.balance - bill.amount,
        availableBalance: account.availableBalance - bill.amount
      });

      // Update bill status
      transaction.update(billDoc.ref, {
        status: 'paid',
        paymentDate: new Date()
      });

      // Create transaction record
      transaction.set(db.collection('transactions').doc(), {
        userId,
        accountId,
        transactionReference: `BILL${Date.now()}`,
        type: 'bill_payment',
        amount: bill.amount,
        currency: account.currency,
        fee: 0,
        balanceBefore: account.balance,
        balanceAfter: account.balance - bill.amount,
        description: `Bill payment: ${bill.billerName}`,
        status: 'completed',
        transactionDate: new Date()
      });
    });

    res.json({
      success: true,
      message: 'Bill payment successful'
    });

  } catch (error) {
    console.error('Pay bill error:', error);
    res.status(500).json({
      success: false,
      message: 'Bill payment failed',
      error: error.message
    });
  }
});

module.exports = router;