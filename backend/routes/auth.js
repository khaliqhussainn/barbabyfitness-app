const express = require('express');
const { body } = require('express-validator');
const router = express.Router();

const { register, login, forgotPassword, resetPassword, me } = require('../controllers/authController');
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

module.exports = router;
