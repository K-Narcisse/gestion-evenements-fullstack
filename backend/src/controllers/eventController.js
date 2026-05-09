const data = require('../data/mockData');
const Event = require('../models/Event'); 
const Registration = require('../models/Registration'); 

/**
 * Fonction utilitaire pour enrichir l'événement avec les compteurs
 */
const getEventWithDetails = (event) => {
    const registrations = data.registrations.filter(r => r.eventId === event.id);
    return {
        ...event,
        registeredCount: registrations.length,
        remainingPlaces: event.capacity - registrations.length
    };
};

// --- GET /api/events ---
exports.getAllEvents = async (req, res) => {
    try {
        const { search, date } = req.query;
        let results = data.events.map(event => getEventWithDetails(event));

        if (search) {
            results = results.filter(e => e.title.toLowerCase().includes(search.toLowerCase()));
        }

        if (date) {
            results = results.filter(e => e.date.startsWith(date));
        }

        res.status(200).json(results);
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

// --- GET /api/events/:id ---
exports.getEventById = async (req, res) => {
    try {
        const event = data.events.find(e => e.id === req.params.id);
        if (!event) return res.status(404).json({ error: "Événement non trouvé" });
        
        res.status(200).json(getEventWithDetails(event));
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

// --- POST /api/events ---
exports.createEvent = async (req, res) => {
    try {
        const errors = Event.validate(req.body);
        if (errors.length > 0) {
            return res.status(400).json({ error: "VALIDATION_FAILED", messages: errors });
        }

        const newEvent = new Event(req.body);
        data.events.push(newEvent);
        
        res.status(201).json(newEvent);
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

// --- LA FONCTION QUI MANQUAIT (PUT) ---
exports.updateEvent = async (req, res) => {
    try {
        const { id } = req.params;
        const index = data.events.findIndex(e => e.id === id);

        if (index === -1) {
            return res.status(404).json({ error: "Événement non trouvé" });
        }

        // Mise à jour des données
        data.events[index] = { ...data.events[index], ...req.body, id }; // On garde le même ID
        
        res.status(200).json(data.events[index]);
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

// --- DELETE /api/events/:id ---
exports.deleteEvent = async (req, res) => {
    try {
        const id = req.params.id;
        data.events = data.events.filter(e => e.id !== id);
        data.registrations = data.registrations.filter(r => r.eventId !== id);
        res.status(200).json({ message: "Événement et inscriptions supprimés" });
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

/**
 * LOGIQUE D'INSCRIPTION
 */
exports.registerToEvent = async (req, res) => {
    try {
        const { id } = req.params;

        const validationErrors = Registration.validate(req.body);
        if (validationErrors.length > 0) {
            return res.status(400).json({ error: "INVALID_FIELDS", messages: validationErrors });
        }

        const event = data.events.find(e => e.id === id);
        if (!event) return res.status(404).json({ error: "Événement non trouvé" });

        const currentRegs = data.registrations.filter(r => r.eventId === id);
        if (currentRegs.length >= event.capacity) {
            return res.status(422).json({
                error: "CAPACITY_REACHED",
                message: "Cet evenement est complet."
            });
        }

        const emailExists = currentRegs.some(r => r.email === req.body.email);
        if (emailExists) {
            return res.status(409).json({
                error: "DUPLICATE_EMAIL",
                message: "Cette adresse email est deja enregistree pour cet evenement."
            });
        }

        const newRegistration = new Registration({ ...req.body, eventId: id });
        data.registrations.push(newRegistration);

        res.status(201).json(newRegistration);
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};

// --- AUTRE FONCTION SOUVENT UTILISÉE DANS LES ROUTES ---
exports.getEventRegistrations = async (req, res) => {
    try {
        const { id } = req.params;
        const results = data.registrations.filter(r => r.eventId === id);
        res.status(200).json(results);
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};