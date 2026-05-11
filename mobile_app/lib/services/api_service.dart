import 'package:dio/dio.dart';
import '../models/event.dart';

class ApiService {
  // Configuration de Dio avec ton adresse IP actuelle
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.11.113:3000/api', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  /// Récupérer la liste des événements (Exigence Section 4.1 - Écran 1)
  /// Supporte le paramètre optionnel ?search= pour le filtrage
  Future<List<Event>> getEvents({String? search}) async {
    try {
      final response = await _dio.get('/events', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      });
      
      // Conversion du JSON reçu en liste d'objets Event
      return (response.data as List).map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Inscription d'un participant (Exigence Section 4.1 - Écran 2)
  /// Accepte l'ID de l'événement et un Map contenant les infos du formulaire
  Future<void> register(String eventId, Map<String, dynamic> data) async {
    try {
      // Envoi de la requête POST au backend
      await _dio.post('/events/$eventId/register', data: data);
    } on DioException catch (e) {
      // Renvoie l'erreur spécifique (409 ou 422) au UI
      throw _handleError(e);
    }
  }

  /// Gestion centralisée des messages d'erreurs (Exigence Section 3.2 & 3.3)
  /// Permet d'afficher des messages lisibles à l'utilisateur (pas de console.log)
  String _handleError(dynamic e) {
    if (e is DioException && e.response != null) {
      // Si le backend a renvoyé un message d'erreur (ex: "Cet événement est complet")
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        return e.response?.data['message'];
      }
      
      // Gestion par codes HTTP si le message n'est pas présent
      switch (e.response?.statusCode) {
        case 409:
          return "Vous êtes déjà inscrit à cet événement.";
        case 422:
          return "Désolé, cet événement est complet.";
        case 400:
          return "Les données saisies sont invalides.";
        default:
          return "Erreur serveur (${e.response?.statusCode})";
      }
    }
    return "Connexion au serveur impossible. Vérifiez votre réseau.";
  }
}