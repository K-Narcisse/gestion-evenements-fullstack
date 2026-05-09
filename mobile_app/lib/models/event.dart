import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String location;
  final int capacity;
  final int registeredCount;
  final int remainingPlaces;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.location,
    required this.capacity,
    required this.registeredCount,
    required this.remainingPlaces,
  });

  // Calcul pour l'affichage
  bool get isFull => remainingPlaces <= 0;

  // Formattage de la date pour l'UI
  String get formattedDate => DateFormat('dd MMMM yyyy, HH:mm').format(date);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      capacity: json['capacity'],
      registeredCount: json['registeredCount'] ?? 0,
      remainingPlaces: json['remainingPlaces'] ?? 0,
    );
  }
}