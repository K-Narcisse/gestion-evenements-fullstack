/**
 * Stockage en mémoire (Section 3.4)
 * Utilisation de let pour permettre la modification des tableaux
 */

let events = [
    {
        id: "evt_1",
        title: "Conférence Tech 2025",
        description: "Une journée dédiée aux nouvelles technologies et à l'IA.",
        date: "2025-11-15T18:00:00Z",
        location: "OUAGADOUGOU, Burkina Faso",
        capacity: 50,
        createdAt: "2024-01-01T10:00:00Z"
    },
    {
        id: "evt_2",
        title: "Atelier Flutter Avancé",
        description: "Apprenez à maîtriser Riverpod et les animations complexes.",
        date: "2025-12-10T09:00:00Z",
        location: "BOBO Dioulasso, Burkina Faso",
        capacity: 2, // Petite capacité pour tester facilement l'erreur 422
        createdAt: "2024-02-15T14:30:00Z"
    },
    {
        id: "evt_3",
        title: "Meetup JavaScript",
        description: null, // Description optionnelle
        date: "2025-09-20T19:00:00Z",
        location: "KOUDOUGOU, Burkina Faso",
        capacity: 100,
        createdAt: "2024-03-10T08:00:00Z"
    }
];

let registrations = [
    {
        id: "reg_001",
        eventId: "evt_2",
        firstName: "Narcisse",
        lastName: "KOURAOGO",
        email: "narcisse.kouraogo@example.com",
        registeredAt: "2024-03-12T09:00:00Z"
    }
];

module.exports = {
    events,
    registrations
};