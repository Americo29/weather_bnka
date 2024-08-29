import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:weather_bnka/features/auth/domain/entities/user.dart';
import 'package:weather_bnka/features/auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SignupEvent>(_onSignup);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final userRegistered = await loginUseCase.isRegisteredUser();

      if (userRegistered == null) {
       
        emit(const AuthFailure("Usuario no encontrado, regístrese primero."));
      } else {
        
        final UserEntity user =
            UserEntity(username: event.username, password: event.password);

        if (event.username == userRegistered.username) {
         
          if (event.password == userRegistered.password) {
            emit(AuthSuccess(user)); // Credentials are valid, login successful
          } else {
            // Password is incorrect
            emit(const AuthFailure("Credenciales incorrectas."));
          }
        } else {
          // Username doesn't match the registered one
          emit(const AuthFailure("Usuario no reconocido, regístrese primero."));
        }
      }

      // Wait for 3 seconds before resetting the state to initial
      await Future.delayed(const Duration(seconds: 3));
      emit(AuthInitial());
    } catch (error) {
      emit(const AuthFailure("Credenciales incorrectas."));
      await Future.delayed(const Duration(seconds: 3));
      emit(AuthInitial());
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final UserEntity user =
          UserEntity(username: event.username, password: event.password);

      await loginUseCase.loginUser(user);
      emit(AuthSuccess(user));
    } catch (error) {
      emit(const AuthFailure("Credenciales incorrectas."));
      await Future.delayed(const Duration(seconds: 3));
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    
    emit(AuthLogout());
  }
}
