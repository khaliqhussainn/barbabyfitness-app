const express = require('express');
const { body } = require('express-validator');
const router = express.Router();

const { register, login, forgotPassword, resetPassword, me, updateProfile, deleteAccount } = require('../controllers/authController');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');

// POST /api/auth/register
router.post(
  '/register',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  ],
  validate,
  register
);

// POST /api/auth/login
router.post(
  '/login',
  [
    body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  validate,
  login
);

// POST /api/auth/forgot-password
router.post(
  '/forgot-password',
  [body('email').isEmail().normalizeEmail().withMessage('Valid email required')],
  validate,
  forgotPassword
);

// POST /api/auth/reset-password
router.post(
  '/reset-password',
  [
    body('token').notEmpty().withMessage('Token is required'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  ],
  validate,
  resetPassword
);

// GET /api/auth/me  (protected)
router.get('/me', authenticate, me);

// PUT /api/auth/profile  (protected)
router.put('/profile', authenticate, [
  body('name').optional().trim().notEmpty().withMessage('Name cannot be empty'),
  body('email').optional().isEmail().normalizeEmail().withMessage('Valid email required'),
  body('age').optional({ nullable: true }).isInt({ min: 1, max: 120 }).withMessage('Age must be 1-120'),
  body('new_password').optional().isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
], validate, updateProfile);

// DELETE /api/auth/account  (protected)
router.delete('/account', authenticate, deleteAccount);

module.exports = router;
