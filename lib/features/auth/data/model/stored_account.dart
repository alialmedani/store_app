import 'current_user_model.dart';

class StoredAccount {
  final CurrentUserModel user;
  final String token;
  final String? refreshToken;
  final DateTime? lastActive;

  StoredAccount({
    required this.user,
    required this.token,
    this.refreshToken,
    this.lastActive,
  });

  factory StoredAccount.fromJson(Map<String, dynamic> json) {
    return StoredAccount(
      user: CurrentUserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'refreshToken': refreshToken,
      'lastActive': lastActive?.toIso8601String(),
    };
  }
}
