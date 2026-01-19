const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth.middleware');
const { db } = require('../server');

router.use(authMiddleware);

// GET /api/v1/cards
router.get('/', async (req, res) => {
  try {
    const userId = req.user.userId;

    const cardsSnapshot = await db.collection('cards')
      .where('userId', '==', userId)
      .get();

    const cards = cardsSnapshot.docs.map(doc => {
      const cardData = doc.data();
      return {
        id: doc.id,
        ...cardData,
        // Mask card number
        cardNumber: `**** **** **** ${cardData.cardNumber.slice(-4)}`
      };
    });

    res.json({
      success: true,
      data: cards
    });

  } catch (error) {
    console.error('Get cards error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch cards',
      error: error.message
    });
  }
});

// POST /api/v1/cards/:id/block
router.post('/:id/block', async (req, res) => {
  try {
    const userId = req.user.userId;
    const cardId = req.params.id;

    const cardDoc = await db.collection('cards').doc(cardId).get();

    if (!cardDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Card not found'
      });
    }

    const card = cardDoc.data();

    if (card.userId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    await db.collection('cards').doc(cardId).update({
      status: 'blocked'
    });

    res.json({
      success: true,
      message: 'Card blocked successfully'
    });

  } catch (error) {
    console.error('Block card error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to block card',
      error: error.message
    });
  }
});

module.exports = router;