import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  // On passe l'objet événement sélectionné depuis l'écran de liste
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // Clé globale pour valider le formulaire (Section 4.1)
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour récupérer les saisies utilisateur (Prénom, Nom, Email)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  // État pour gérer l'affichage du spinner pendant l'appel API (Section 4.2)
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    // Bonne pratique : on libère les contrôleurs quand l'écran est fermé
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Logique d'envoi de l'inscription
  Future<void> _submitRegistration() async {
    // 1. Validation côté client (Section 4.1)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 2. Appel au service API
      await _apiService.register(
        widget.event.id,
        {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
        },
      );

      // 3. Retour utilisateur en cas de SUCCÈS (Section 4.1)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inscription validée avec succès !"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context); // Redirection vers la liste après succès
      }
    } catch (error) {
      // 4. Retour utilisateur en cas d'ERREUR LISIBLE (Section 4.1)
      // Affiche les erreurs 409 (email déjà pris) ou 422 (complet) renvoyées par le backend
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
    
    // CONDITION CLÉ : Vérifie si l'événement est complet (Section 4.1)
    final bool isFull = event.remainingPlaces <= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'évènement"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1 : TOUTES LES INFOS DE L'ÉVÈNEMENT (Exigence 4.1) ---
            Text(
              event.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.calendar_today, event.formattedDate),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, event.location),
            const SizedBox(height: 16),
            Text(
              event.description ?? "Aucune description fournie.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            
            const Divider(height: 48),

            // --- SECTION 2 : COMPTEUR DE PLACES X sur Y (Exigence 4.1) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isFull ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isFull ? Colors.red.shade200 : Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    "${event.remainingPlaces} places restantes",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.red.shade700 : Colors.blue.shade900,
                    ),
                  ),
                  Text("sur une capacité totale de ${event.capacity} places"),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- SECTION 3 : GESTION DE L'ÉTAT COMPLET (Exigence 4.1) ---
            // Si complet : affiche un message d'erreur et désactive l'inscription
            // Sinon : affiche le formulaire d'inscription normal
            isFull ? _buildFullEventMessage() : _buildRegistrationForm(),
          ],
        ),
      ),
    );
  }

  /// Widget affiché à la place du formulaire si l'événement est complet
  Widget _buildFullEventMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 12),
          Text(
            "ÉVÈNEMENT COMPLET",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            "Désolé, il n'y a plus de places disponibles pour cet évènement.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Widget du formulaire d'inscription (Prénom, Nom, Email)
  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Formulaire d'inscription", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildTextField(_firstNameController, "Prénom", Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(_lastNameController, "Nom", Icons.person),
          const SizedBox(height: 16),
          _buildTextField(_emailController, "Email", Icons.email_outlined, isEmail: true),
          const SizedBox(height: 32),
          
          // BOUTON DE VALIDATION avec Loader (Section 4.2)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("Confirmer l'inscription", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Petit Helper pour construire les champs de texte rapidement
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Ce champ est requis";
        if (isEmail && !v.contains('@')) return "Email invalide";
        return null;
      },
    );
  }

  // Petit Helper pour les lignes d'info (Icône + Texte)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}