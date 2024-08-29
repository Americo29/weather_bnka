
import 'package:weather_bnka/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> registerUser(UserEntity user);
  Future<UserEntity?> isRegisteredUser();
  Future<void> logoutUser();
}