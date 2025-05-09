import 'package:events_dashboard/models/services/auth_service.dart';
import 'package:events_dashboard/controllers/user_cubit/user_state.dart';
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
    required String phone,
  }) async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      await _authService.registerAdmin(email, password, name, phone);
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
