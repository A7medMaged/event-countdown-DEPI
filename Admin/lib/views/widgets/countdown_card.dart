import 'dart:async';
import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/data_models/event_model.dart';

class CountdownCard extends StatefulWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CountdownCard({super.key, required this.event, required this.onDelete, required this.onEdit});

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    // Initialize timeLeft first
    final now = DateTime.now();
    if (widget.event.eventDate.isBefore(now)) {
      _timeLeft = Duration.zero;
    } else {
      _timeLeft = widget.event.eventDate.difference(now);
    }

    // Set up timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimeLeft());
    // Set up notifications
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    final now = DateTime.now();

    if (widget.event.eventDate.isBefore(now)) {
      setState(() => _timeLeft = Duration.zero);
    } else {
      setState(() => _timeLeft = widget.event.eventDate.difference(now));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate countdown components
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    final isPast = _timeLeft == Duration.zero;

    return Card(
      color: const Color.fromARGB(255, 15, 15, 15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.event.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.penToSquare),
                      onPressed: () async {
                        widget.onEdit();
                      },
                    ),
                    IconButton(icon: const Icon(FontAwesomeIcons.trash, color: Colors.red), onPressed: widget.onDelete),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Opacity(opacity: 0.5, child: Text(widget.event.description, style: TextStyle(color: white))),
            const SizedBox(height: 16),
            Text(
              'Event Date: ${_formatDate(widget.event.eventDate)}',
              style: const TextStyle(fontWeight: FontWeight.w500, color: secondColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Event Time: ${_formatTime(widget.event.eventDate)}',
              style: const TextStyle(fontWeight: FontWeight.w500, color: secondColor),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: secondColor, borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isPast ? 'Event has passed' : 'Time Remaining',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  if (!isPast)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCountdownUnit(days, 'DAYS'),
                        _buildCountdownUnit(hours, 'HOURS'),
                        _buildCountdownUnit(minutes, 'MINS'),
                        _buildCountdownUnit(seconds, 'SECS'),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownUnit(int value, String label) {
    return Column(
      children: [
        Text(value.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
