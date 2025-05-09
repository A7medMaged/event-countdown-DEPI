import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.5,
            child: Text(
              'No events yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Opacity(
            opacity: 0.5,
            child: Text(
              'Tap the + button to add your countdown',
              style: TextStyle(color: white),
            ),
          ),
        ],
      ),
    );
  }
}
