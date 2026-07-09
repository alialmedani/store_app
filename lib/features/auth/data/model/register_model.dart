class RegisterModel {
  String? message;
  bool? success;
  String? userId;

  RegisterModel({this.message, this.success, this.userId});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'] ?? true;
    userId = json['userId'];
  }
}
