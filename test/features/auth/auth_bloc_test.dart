import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bnka/features/auth/domain/entities/user.dart';
import 'package:weather_bnka/features/auth/domain/usecases/login_usecase.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  const registered = UserEntity(username: 'americo', password: 'secret');

  late _MockLoginUseCase loginUseCase;

  setUpAll(() => registerFallbackValue(const UserEntity()));

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    when(() => loginUseCase.loginUser(any())).thenAnswer((_) async {});
  });

  group('AuthBloc', () {
    test('starts in AuthInitial', () {
      expect(AuthBloc(loginUseCase).state, isA<AuthInitial>());
    });

    group('LoginEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthSuccess when the credentials match the stored user',
        setUp: () => when(loginUseCase.isRegisteredUser)
            .thenAnswer((_) async => registered),
        build: () => AuthBloc(loginUseCase),
        act: (bloc) => bloc.add(const LoginEvent('americo', 'secret')),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<AuthSuccess>().having((s) => s.user.username, 'username', 'americo'),
          // The bloc resets itself so a stale error never survives on screen.
          isA<AuthInitial>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthFailure when nobody is registered yet',
        setUp: () =>
            when(loginUseCase.isRegisteredUser).thenAnswer((_) async => null),
        build: () => AuthBloc(loginUseCase),
        act: (bloc) => bloc.add(const LoginEvent('americo', 'secret')),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<AuthFailure>().having(
            (s) => s.error,
            'error',
            'Usuario no encontrado, regístrese primero.',
          ),
          isA<AuthInitial>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthFailure when the password does not match',
        setUp: () => when(loginUseCase.isRegisteredUser)
            .thenAnswer((_) async => registered),
        build: () => AuthBloc(loginUseCase),
        act: (bloc) => bloc.add(const LoginEvent('americo', 'wrong')),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<AuthFailure>()
              .having((s) => s.error, 'error', 'Credenciales incorrectas.'),
          isA<AuthInitial>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthFailure when the username does not match the stored one',
        setUp: () => when(loginUseCase.isRegisteredUser)
            .thenAnswer((_) async => registered),
        build: () => AuthBloc(loginUseCase),
        act: (bloc) => bloc.add(const LoginEvent('someone-else', 'secret')),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<AuthFailure>().having(
            (s) => s.error,
            'error',
            'Usuario no reconocido, regístrese primero.',
          ),
          isA<AuthInitial>(),
        ],
      );
    });

    group('SignupEvent', () {
      blocTest<AuthBloc, AuthState>(
        'persists the user and emits AuthLoading then AuthSuccess',
        build: () => AuthBloc(loginUseCase),
        act: (bloc) => bloc.add(const SignupEvent('americo', 'secret')),
        wait: const Duration(seconds: 3),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>().having((s) => s.user.username, 'username', 'americo'),
        ],
        verify: (_) => verify(() => loginUseCase.loginUser(registered)).called(1),
      );
    });

    blocTest<AuthBloc, AuthState>(
      'LogoutEvent emits AuthLogout',
      build: () => AuthBloc(loginUseCase),
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [isA<AuthLogout>()],
    );
  });
}
