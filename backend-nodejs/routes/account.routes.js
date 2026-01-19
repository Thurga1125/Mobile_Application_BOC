const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { db } = require('../server');

// All routes require authentication
router.use(authMiddleware);

// GET /api/v1/accounts
router.get('/', async (req, res) => {
  try {
    const userId = req.user.userId;

    const accountsSnapshot = await db.collection('accounts')
      .where('userId', '==', userId)
      .get();

    const accounts = accountsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json({
      success: true,
      data: accounts
    });

  } catch (error) {
    console.error('Get accounts error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch accounts',
      error: error.message
    });
  }
});

// GET /api/v1/accounts/:id
router.get('/:id', async (req, res) => {
  try {
    const userId = req.user.userId;
    const accountId = req.params.id;

    const accountDoc = await db.collection('accounts').doc(accountId).get();

    if (!accountDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Account not found'
      });
    }

    const account = accountDoc.data();

    // Check if account belongs to user
    if (account.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.json({
      success: true,
      data: {
        id: accountDoc.id,
        ...account
      }
    });

  } catch (error) {
    console.error('Get account error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch account',
      error: error.message
    });
  }
});

// GET /api/v1/accounts/:id/balance
router.get('/:id/balance', async (req, res) => {
  try {
    const userId = req.user.userId;
    const accountId = req.params.id;

    const accountDoc = await db.collection('accounts').doc(accountId).get();

    if (!accountDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Account not found'
      });
    }

    const account = accountDoc.data();

    if (account.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.json({
      success: true,
      data: {
        accountNumber: account.accountNumber,
        balance: account.balance,
        availableBalance: account.availableBalance,
        currency: account.currency
      }
    });

  } catch (error) {
    console.error('Get balance error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch balance',
      error: error.message
    });
  }
});

module.exports = router;