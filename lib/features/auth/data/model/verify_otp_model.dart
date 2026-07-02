class VerifyOtpModel {
  final bool success;
  final bool isNewUser;
  final String userId;
  final String username;
  final String otpToken;

  VerifyOtpModel({
    required this.success,
    required this.isNewUser,
    required this.userId,
    required this.username,
    required this.otpToken,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json['success'] ?? false,
      isNewUser: json['isNewUser'] ?? false,
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      otpToken: json['otpToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'isNewUser': isNewUser,
      'userId': userId,
      'username': username,
      'otpToken': otpToken,
    };
  }
}
