# Application de Gestion d'Événements

Test technique pour le poste de Développeur Full Stack.

## 📌 Présentation du projet
Cette application permet de consulter une liste d'événements et de gérer les inscriptions avec un contrôle strict de la capacité et de l'unicité des participants (un seul email par événement).

**Stack technique :**
- **Backend :** Node.js (Express)
- **Frontend :** Flutter (Dart)
- **Stockage :** In-memory (Section 3.4) pour une exécution fluide et rapide lors du test.

## 📁 Structure du projet
- `/backend` : API REST Node.js organisée en couches (Routes, Controllers, Models, Data).
- `/mobile_app` : Application Flutter organisée selon une architecture de type "Provider" (Models, Services, Providers, Screens, Widgets).

## 🚀 Installation et Lancement

### Backend
1. `cd backend`
2. `npm install`
3. `node src/index.js` (L'API tourne par défaut sur http://localhost:3000)

### Frontend (Flutter)
1. `cd mobile_app`
2. `flutter pub get`
3. `flutter run`

**Note sur la connectivité :**
- Sur **Android Emulator**, l'URL de base est configurée sur `http://10.0.2.2:3000`.
- Pour un test sur **appareil physique** (comme réalisé durant mon développement), l'URL a été configurée sur l'adresse IP locale du serveur : `http://192.168.1.68:3000`.

## 🛠 Choix techniques et Interprétations
- **Sécurité et Logique :** Validation des champs obligatoires via les modèles côté backend. Une vérification de la capacité est faite avant chaque inscription pour renvoyer une erreur 422 si l'événement est complet, et une erreur 409 si l'email est déjà utilisé.
- **Gestion de capacité :** L'état "Complet" est géré dynamiquement. Côté Frontend, le formulaire d'inscription est désactivé et remplacé par un message d'information si la capacité est atteinte.
- **UX :** Un indicateur de chargement (CircularProgressIndicator) est affiché durant les appels API. Les retours utilisateurs (succès ou erreurs 409/422) sont affichés via des SnackBars lisibles.

## 📝 Historique des commits
J'ai suivi une convention de nommage de commits claire pour refléter l'avancement :
1. `feat: initial project structure`
2. `feat(backend): implement event and registration models`
3. `feat(backend): add capacity and email validation logic`
4. `feat(frontend): implement event list and registration form`