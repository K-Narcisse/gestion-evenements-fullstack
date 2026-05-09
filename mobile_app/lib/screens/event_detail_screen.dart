import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs du formulaire (Exigence Section 4.1)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Fonction de soumission de l'inscription
  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Appel à l'API pour l'inscription
      await _apiService.register(
        widget.event.id,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
      );

      // RETOUR SUCCÈS (Exigence Section 4.1)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inscription réussie !"),
            backgroundColor: Colors.green,
          ),
        );
        // Retour à la liste après succès
        Navigator.pop(context);
      }
    } catch (error) {
      // RETOUR ERREUR LISIBLE (Exigence Section 4.1)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de l'événement"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOUTES LES INFORMATIONS DE L'ÉVÉNEMENT ---
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                const SizedBox(width: 10),
                Text(event.formattedDate, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.blue),
                const SizedBox(width: 10),
                Text(event.location, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              event.description ?? "Aucune description disponible pour cet événement.",
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            
            const Divider(height: 40),

            // --- COMPTEUR DE PLACES (Exigence : X places restantes sur Y) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: event.isFull ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${event.remainingPlaces} places restantes sur ${event.capacity}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: event.isFull ? Colors.red : Colors.blue.shade800,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- FORMULAIRE OU MESSAGE SI COMPLET ---
            // Exigence : "Désactive et remplace par un message si l'évènement est complet"
            event.isFull ? _buildFullEventMessage() : _buildRegistrationForm(),
          ],
        ),
      ),
    );
  }

  // Widget affiché quand l'événement est complet
  Widget _buildFullEventMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 10),
          Text(
            "ÉVÉNEMENT COMPLET",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 5),
          Text(
            "Les inscriptions sont désormais fermées pour cet événement.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget du formulaire d'inscription
  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Formulaire d'inscription",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          
          // Champ Prénom
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: "Prénom",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) => value!.isEmpty ? "Veuillez entrer votre prénom" : null,
          ),
          const SizedBox(height: 15),

          // Champ Nom
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: "Nom",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value!.isEmpty ? "Veuillez entrer votre nom" : null,
          ),
          const SizedBox(height: 15),

          // Champ Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) return "Veuillez entrer votre email";
              if (!value.contains('@')) return "Veuillez entrer un email valide";
              return null;
            },
          ),
          const SizedBox(height: 25),

          // Bouton de validation (avec indicateur de chargement)
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) // Exigence Section 4.2
                : const Text("S'inscrire maintenant", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}