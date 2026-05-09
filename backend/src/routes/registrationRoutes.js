const express = require('express');
const router = express.Router();
const registrationController = require('../controllers/registrationController');

// DELETE /api/registrations/:id - Annule une inscription
// On utilise cancelRegistration car c'est le nom dans le controller
router.delete('/:id', registrationController.cancelRegistration);

module.exports = router;