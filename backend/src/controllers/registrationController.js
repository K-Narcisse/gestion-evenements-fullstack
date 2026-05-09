const data = require('../data/mockData');

// C'est cette fonction "cancelRegistration" que la route appelle
exports.cancelRegistration = async (req, res) => {
    try {
        const { id } = req.params;
        const index = data.registrations.findIndex(r => r.id === id);

        if (index === -1) {
            return res.status(404).json({ error: "Inscription non trouvée" });
        }

        data.registrations.splice(index, 1);
        res.status(200).json({ message: "L'inscription a été annulée avec succès." });
    } catch (error) {
        res.status(500).json({ error: "Erreur serveur" });
    }
};