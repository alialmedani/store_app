class LoginModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;

  LoginModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
  }
}
