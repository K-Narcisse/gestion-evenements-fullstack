import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents({String? search}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _apiService.getEvents(search: search);
    } catch (e) {
      // Gérer l'erreur ici
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}