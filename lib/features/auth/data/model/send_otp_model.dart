class SendOtpModel {
  final bool success;
  final int channel;
  final int expiresInSeconds;
  final int resendCooldownSeconds;
  final bool isExistingUser;

  SendOtpModel({
    required this.success,
    required this.channel,
    required this.expiresInSeconds,
    required this.resendCooldownSeconds,
    required this.isExistingUser,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      success: json['success'] ?? false,
      channel: json['channel'] ?? 0,
      expiresInSeconds: json['expiresInSeconds'] ?? 0,
      resendCooldownSeconds: json['resendCooldownSeconds'] ?? 0,
      isExistingUser: json['isExistingUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'channel': channel,
      'expiresInSeconds': expiresInSeconds,
      'resendCooldownSeconds': resendCooldownSeconds,
      'isExistingUser': isExistingUser,
    };
  }
}
