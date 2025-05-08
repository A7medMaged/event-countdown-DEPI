import '../../models/data_models/event_model.dart';

abstract class EventState {
  const EventState();
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;
  
  const EventLoaded(this.events);
}

class EventError extends EventState {
  final String message;
  
  const EventError(this.message);
}