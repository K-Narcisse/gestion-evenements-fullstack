import 'package:flutter/material.dart';
import '../models/event.dart';
import '../screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Variable pour simplifier la lecture
    final bool isFull = event.remainingPlaces <= 0;

    return Card(
      elevation: isFull ? 0 : 2, // Moins d'ombre si complet
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // COULEUR DE FOND : Grisée si complet (Indicateur Visuel)
      color: isFull ? Colors.grey.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isFull ? Colors.grey.shade300 : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
        ),
        child: Stack( // Utilisation d'un Stack pour superposer le badge
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITRE : En gris si complet
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // INFOS (Date/Lieu) : Opacité réduite si complet
                  Opacity(
                    opacity: isFull ? 0.5 : 1.0,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 5),
                        Text(event.formattedDate),
                        const SizedBox(width: 15),
                        const Icon(Icons.location_on, size: 14),
                        const SizedBox(width: 5),
                        Expanded(child: Text(event.location)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // INDICATEUR DE PLACES
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isFull ? Colors.red.shade100 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isFull ? "ÉVÉNEMENT COMPLET" : "${event.remainingPlaces} places restantes",
                      style: TextStyle(
                        color: isFull ? Colors.red.shade700 : Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BADGE VISUEL (Optionnel mais très Senior)
            if (isFull)
              Positioned(
                top: 10,
                right: 10,
                child: Transform.rotate(
                  angle: 0.2, // Légère rotation pour le style
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      color: Colors.white,
                    ),
                    child: const Text(
                      "COMPLET",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}