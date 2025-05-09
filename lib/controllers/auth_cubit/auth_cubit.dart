import 'package:event_app/models/services/auth_service.dart';
import 'package:event_app/controllers/auth_cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      await _authService.login(email, password);
      if (isClosed) return;
      emit(AuthSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      await _authService.register(email, password, name);
      if (isClosed) return;
      emit(AuthSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      await _authService.logout();
      if (isClosed) return;
      emit(Unauthenticated());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }
}
