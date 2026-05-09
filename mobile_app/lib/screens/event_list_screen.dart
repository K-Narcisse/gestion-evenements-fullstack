import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Événements")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => provider.loadEvents(search: v),
              decoration: InputDecoration(
                hintText: "Rechercher...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); provider.loadEvents(); }) 
                  : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : provider.events.isEmpty 
                ? _buildEmptyState() 
                : ListView.builder(
                    itemCount: provider.events.length,
                    itemBuilder: (ctx, i) => EventCard(event: provider.events[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 50, color: Colors.grey),
          Text("Aucun résultat pour \"${_searchController.text}\""),
        ],
      ),
    );
  }
}