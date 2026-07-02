class RegisterDriverModel {
  String? message;
  bool? success;

  RegisterDriverModel({this.message, this.success});

  RegisterDriverModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'] ?? true;
  }
}
