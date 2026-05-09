import 'package:dio/dio.dart';
import '../models/event.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.11.103:3000/api', // Adapte selon ton émulateur
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // Récupérer les événements (Section 4.1 - Ecran 1)
  Future<List<Event>> getEvents({String? search}) async {
    try {
      final response = await _dio.get('/events', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      });
      return (response.data as List).map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Inscription (Section 4.1 - Ecran 2)
  Future<void> register(String eventId, String first, String last, String email) async {
    try {
      await _dio.post('/events/$eventId/register', data: {
        'firstName': first,
        'lastName': last,
        'email': email,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException && e.response != null) {
      // On récupère le message d'erreur envoyé par notre Backend (Section 3.3)
      return e.response?.data['message'] ?? "Une erreur est survenue";
    }
    return "Connexion au serveur impossible";
  }
}