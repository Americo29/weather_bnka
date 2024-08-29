import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? username;
  final String? password;

  const UserEntity({
    this.username,
    this.password,
  });

  @override
  List<Object?> get props {
    return [username, password];
  }

  UserEntity.fromJson(
    Map<String, dynamic> json,
  )   : username = json['name'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() => {
        'name': username,
        'password': password,
      };
}
