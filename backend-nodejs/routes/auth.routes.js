const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const { db } = require('../config/firebase');

const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN
  });
};

const generateRefreshToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_REFRESH_EXPIRES_IN
  });
};

// POST /api/v1/auth/login
router.post('/login', [
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required'),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { email, password } = req.body;
    console.log('Login attempt for:', email);

    const userSnapshot = await db.collection('users').where('email', '==', email.toLowerCase()).get();
    if (userSnapshot.empty) {
      console.log('User not found:', email);
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    const userDoc = userSnapshot.docs[0];
    const user = userDoc.data();
    const userId = userDoc.id;
    console.log('User found:', userId);

    if (user.status !== 'active') {
      return res.status(403).json({
        success: false,
        message: 'Account is not active'
      });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      console.log('Invalid password for:', email);
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    console.log('Password valid, updating last login');

    await db.collection('users').doc(userId).update({
      lastLogin: new Date()
    });

    const accessToken = generateToken(userId);
    const refreshToken = generateRefreshToken(userId);

    const accountsSnapshot = await db.collection('accounts').where('userId', '==', userId).get();
    const accounts = accountsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    console.log('Login successful for:', email);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        userId,
        user: {
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber
        },
        accounts,
        accessToken,
        refreshToken,
        expiresIn: process.env.JWT_EXPIRES_IN
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Login failed',
      error: error.message
    });
  }
});

// POST /api/v1/auth/register
router.post('/register', [
  body('fullName').notEmpty().withMessage('Full name is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  body('phoneNumber').notEmpty().withMessage('Phone number is required'),
  body('accountNumber').notEmpty().withMessage('Account number is required'),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { fullName, email, password, phoneNumber, nationalId, dateOfBirth, accountNumber, address, city, postalCode } = req.body;
    
    const existingUser = await db.collection('users').where('email', '==', email.toLowerCase()).get();
    if (!existingUser.empty) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered'
      });
    }

    const accountSnapshot = await db.collection('accounts').where('accountNumber', '==', accountNumber).get();
    if (accountSnapshot.empty) {
      return res.status(400).json({
        success: false,
        message: 'Invalid account number'
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const userRef = db.collection('users').doc();
    const userId = userRef.id;

    await userRef.set({
      fullName,
      email: email.toLowerCase(),
      password: hashedPassword,
      phoneNumber,
      nationalId: nationalId || '',
      dateOfBirth: dateOfBirth || null,
      address: address || '',
      city: city || '',
      postalCode: postalCode || '',
      profileImage: '',
      biometricEnabled: false,
      twoFactorEnabled: false,
      status: 'active',
      createdAt: new Date(),
      lastLogin: null
    });

    const accountDoc = accountSnapshot.docs[0];
    await db.collection('accounts').doc(accountDoc.id).update({
      userId: userId
    });

    const accessToken = generateToken(userId);
    const refreshToken = generateRefreshToken(userId);

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      data: {
        userId,
        accessToken,
        refreshToken,
        expiresIn: process.env.JWT_EXPIRES_IN
      }
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Registration failed',
      error: error.message
    });
  }
});

module.exports = router;
