import '../../../inner_headers.dart';

class UserEntity extends UserInfoProtocol {
  @override
  final String userId;

  @override
  final String? nickname;

  @override
  final String? avatarURL;

  @override
  final int? gender;

  @override
  final String? identify;

  UserEntity(
    this.userId, {
    this.nickname,
    this.avatarURL,
    this.gender = 1,
    this.identify,
  });

  factory UserEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserEntity(
      json['userId']!,
      nickname: json['nickname'],
      avatarURL: json['avatarURL'],
      gender: json['gender'],
      identify: json['identify'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.putIfNotNull('userId', userId);
    map.putIfNotNull('nickname', nickname);
    map.putIfNotNull('avatarURL', avatarURL);
    map.putIfNotNull('gender', gender);
    map.putIfNotNull('identify', identify);

    return map;
  }
}
