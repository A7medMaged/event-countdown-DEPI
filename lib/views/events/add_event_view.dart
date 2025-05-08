import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/event_cubit/event_cubit.dart';
import '../../models/data_models/event_model.dart';

class AddEventView extends StatefulWidget {
  final Event? eventToEdit;

  const AddEventView({super.key, this.eventToEdit});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    if (widget.eventToEdit != null) {
      _titleController.text = widget.eventToEdit!.title;
      _descriptionController.text = widget.eventToEdit!.description;
      _selectedDate = widget.eventToEdit!.eventDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.eventToEdit!.eventDate);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final Map<String, Duration> _reminderOptions = {
    '5 minutes before': Duration(minutes: 5),
    '15 minutes before': Duration(minutes: 15),
    '30 minutes before': Duration(minutes: 30),
    '1 hour before': Duration(hours: 1),
    '12 hours before': Duration(hours: 12),
    '1 day before': Duration(days: 1),
  };

  Duration? _selectedReminder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.eventToEdit == null ? 'New countdown' : 'Edit Event',
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Event Title',
                  hintStyle: TextStyle(color: white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Event Description',
                  hintStyle: TextStyle(color: white),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Duration>(
                iconEnabledColor: secondColor,
                iconSize: 24,
                icon: const Icon(Icons.arrow_drop_down),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a reminder duration';
                  }
                  return null;
                },
                isExpanded: true,
                hint: const Text(
                  'Select Reminder Duration',
                  style: TextStyle(color: white),
                ),
                value: _selectedReminder,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                items: _reminderOptions.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedReminder = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Event Date & Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: priamryColor,
                      ),
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: secondColor),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: priamryColor,
                      ),
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: secondColor),
                          Text(
                            _selectedTime.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: priamryColor,
                ),
                child: Text(
                  widget.eventToEdit == null ? 'Add Event' : 'Update Event',
                  style: const TextStyle(fontSize: 16, color: secondColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: secondColor,
            cardColor: black,
            colorScheme: ColorScheme.dark(primary: secondColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: secondColor,
            cardColor: black,
            colorScheme: ColorScheme.dark(primary: secondColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final eventDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final event = Event(
        id: widget.eventToEdit?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: eventDateTime,
        reminderDuration: _selectedReminder,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      final cubit = context.read<EventCubit>();

      if (widget.eventToEdit == null) {
        cubit.addEvent(event);
      } else {
        cubit.updateEvent(event);
      }

      GoRouter.of(context).pop();
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
