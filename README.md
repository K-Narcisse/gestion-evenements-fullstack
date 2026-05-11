est Technique : Application de Gestion d'Événements
Bonjour ! Voici mon rendu pour le test de Développeur Full Stack. L'objectif était de créer une solution simple et robuste pour gérer des inscriptions à des événements, en mettant l'accent sur la cohérence des données et l'expérience utilisateur.
Le projet en bref
L'application permet de parcourir une liste d'événements et de s'y inscrire.
J'ai mis en place un contrôle strict côté serveur pour éviter les doublons (un email = une inscription par événement) et pour respecter la jauge de capacité.
Ma stack technique :
	Backend : Node.js avec Express.
	Frontend: Flutter (Dart).
	Stockage : J'ai utilisé un stockage In-memory (comme suggéré dans la section 3.4), ce qui permet de tester l'app immédiatement sans avoir à configurer une base de données externe.
Structure du code
J'ai opté pour une séparation claire des responsabilités pour faciliter la maintenance :
	/backend: Architecture en couches classiques (Routes, Controllers, Models, Data).
	/mobile_app : Organisation basée sur le pattern Provider pour une gestion d'état propre et réactive.
Installation et Lancement
1. Le Backend
cd backend
npm install
node src/index.js
L'API est accessible par défaut sur http://localhost:3000.
2. L'application Flutter
cd mobile_app
flutter pub get
flutter run
Note sur la connectivité :
Pour les tests sur un émulateur Android, l'URL pointe vers 10.0.2.2.
Cependant, comme je préfère tester sur un appareil physique pour valider l'expérience réelle, j'ai configuré l'IP locale (192.168.1.68) dans le code. Pensez à la modifier dans les constantes du service si votre configuration réseau diffère.
Mes choix et partis pris
	Validation & Sécurité : La logique métier est centralisée sur le backend. Avant chaque inscription, le serveur vérifie la capacité restante (Erreur 422 si complet) et l'unicité de l'email (erreur 409).
	UX / UI :
J'ai ajouté un retour visuel systématique via des SnackBars pour que l'utilisateur sache si son inscription a réussi ou pourquoi elle a échoué.
Si un événement est complet, le formulaire se désactive automatiquement pour éviter toute frustration inutile.
Un loader est présent pour gérer les temps de latence réseau lors des appels API.
Suivi du développement
J'ai essayé de garder un historique de commits clair et atomique pour illustrer ma progression :
	feat: initial project structure
	feat(backend): implement event and registration, models
	feat(backend): add capacity and email validation logic
	feat(frontend): implement event list and registration form