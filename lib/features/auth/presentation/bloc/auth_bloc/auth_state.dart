part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLogout extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

/// Why an attempt failed. The bloc stays free of user-facing copy; the widget
/// layer turns this into a localized message.
enum AuthFailureReason { userNotFound, wrongCredentials, unknownUser }

class AuthFailure extends AuthState {
  final AuthFailureReason reason;

  const AuthFailure(this.reason);

  @override
  List<Object> get props => [reason];
}
