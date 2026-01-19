const { db } = require('../config/firebase');
const bcrypt = require('bcryptjs');

async function seedData() {
  try {
    console.log('🌱 Starting database seeding...');

    // Create sample account
    const accountRef = await db.collection('accounts').add({
      accountNumber: '0012345678901234',
      accountType: 'savings',
      currency: 'LKR',
      balance: 100000,
      availableBalance: 100000,
      status: 'active',
      openedDate: new Date(),
      isPrimary: true,
      userId: ''
    });

    console.log(' Sample account created');

    // Create sample user
    const hashedPassword = await bcrypt.hash('Password123!', 10);
    
    const userRef = await db.collection('users').add({
      fullName: 'John Silva',
      email: 'john@example.com',
      password: hashedPassword,
      phoneNumber: '+94771234567',
      nationalId: '123456789V',
      dateOfBirth: new Date('1990-01-01'),
      address: '123 Main Street',
      city: 'Colombo',
      postalCode: '00100',
      profileImage: '',
      biometricEnabled: false,
      twoFactorEnabled: false,
      status: 'active',
      createdAt: new Date(),
      lastLogin: null
    });

    await accountRef.update({ userId: userRef.id });

    console.log(' Sample user created');
    console.log(' Email: john@example.com');
    console.log(' Password: Password123!');
    console.log(' Account: 0012345678901234');

    // Create sample transaction
    await db.collection('transactions').add({
      userId: userRef.id,
      accountId: accountRef.id,
      transactionReference: 'TXN' + Date.now(),
      type: 'deposit',
      amount: 100000,
      currency: 'LKR',
      fee: 0,
      balanceBefore: 0,
      balanceAfter: 100000,
      description: 'Initial deposit',
      status: 'completed',
      transactionDate: new Date()
    });

    console.log(' Sample transactions created');

    // Create sample card
    await db.collection('cards').add({
      userId: userRef.id,
      cardNumber: '4532123456789012',
      cardHolderName: 'JOHN SILVA',
      cardType: 'debit',
      brand: 'visa',
      expiryMonth: 12,
      expiryYear: 2028,
      status: 'active',
      creditLimit: 0,
      availableCredit: 0
    });

    console.log(' Sample card created');
    console.log(' Database seeding completed successfully!');
    process.exit(0);

  } catch (error) {
    console.error(' Seeding error:', error);
    process.exit(1);
  }
}

seedData();