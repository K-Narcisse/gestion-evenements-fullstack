class Registration {
    constructor({ eventId, firstName, lastName, email }) {
        this.id = `reg_${Date.now()}`;
        this.eventId = eventId; // Référence vers l'événement
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email; // Format email valide
        this.registeredAt = new Date().toISOString();
    }

    static validate(data) {
        const errors = [];
        if (!data.firstName) errors.push("Prénom obligatoire");
        if (!data.lastName) errors.push("Nom obligatoire");
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!data.email || !emailRegex.test(data.email)) errors.push("Email invalide");
        return errors;
    }
}

module.exports = Registration;