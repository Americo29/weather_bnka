import 'package:weather_bnka/features/auth/domain/entities/user.dart';
import 'package:weather_bnka/features/auth/domain/repository/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase(this.userRepository);

  Future<void> loginUser(UserEntity user) async {
    await userRepository.registerUser(user);
  }

  Future<UserEntity?> isRegisteredUser() async {
   return await userRepository.isRegisteredUser();
  }

  Future<void> logoutUser() async {
    await userRepository.logoutUser();
  }
}
