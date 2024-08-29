import 'package:weather_bnka/features/auth/data/data_sources/shared_pref_helper.dart';
import 'package:weather_bnka/features/auth/domain/entities/user.dart';
import 'package:weather_bnka/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPrefHelper sharedPrefHelper;

  UserRepositoryImpl(this.sharedPrefHelper);

  @override
  Future<void> registerUser(UserEntity user) async {
    await sharedPrefHelper.setUser(user);
  }

  @override
  Future<UserEntity?> isRegisteredUser() async {
    return await sharedPrefHelper.getUser();
  }

  @override
  Future<void> logoutUser() async {
    await sharedPrefHelper.clearUser();
  }
}
