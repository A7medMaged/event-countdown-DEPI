import 'package:event_app/models/data_models/get_event_model.dart';

abstract class GetEventState {
  const GetEventState();
}

class GetEventInitial extends GetEventState {}

class GetEventLoading extends GetEventState {}

class GetEventLoaded extends GetEventState {
  final List<GetEventModel> events;

  const GetEventLoaded(this.events);
}

class GetEventError extends GetEventState {
  final String message;

  const GetEventError(this.message);
}
