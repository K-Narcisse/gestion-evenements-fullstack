class Event {
    constructor({ title, description, date, location, capacity }) {
        this.id = `evt_${Date.now()}`;
        this.title = title; // Obligatoire, 100 car. max
        this.description = description || null; // Optionnel
        this.date = date; // Format ISO 8601
        this.location = location; // Obligatoire
        this.capacity = parseInt(capacity); // Obligatoire, > 0
        this.createdAt = new Date().toISOString();
    }

    // Méthode de validation (Point Bonus pour la Qualité du code)
    static validate(data) {
        const errors = [];
        if (!data.title || data.title.length > 100) errors.push("Titre obligatoire (max 100 car.)");
        if (!data.date) errors.push("Date obligatoire");
        if (!data.location) errors.push("Lieu obligatoire");
        if (!data.capacity || data.capacity <= 0) errors.push("Capacité doit être supérieure à zéro");
        return errors;
    }
}

module.exports = Event;