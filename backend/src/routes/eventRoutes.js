const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
//Get/api/events - Liste avec filtres? search= et ?date=
router.get('/',eventController.getAllEvents);
//Post/api/events - Creation d'un evenement
router.post('/',eventController.createEvent);
//Get/api/events/:id - Details d'un evenement
router.get('/:id',eventController.getEventById);
// Put/api/events/:id - Mise a jour d'un evenement
router.put('/:id',eventController.updateEvent);
//Delete/api/events/:id - Suppression d'un evenement
router.delete('/:id',eventController.deleteEvent);
//routes d'inscription a un evenement
router.post('/:id/register',eventController.registerToEvent);
router.get('/:id/registrations',eventController.getEventRegistrations);
module.exports = router;
