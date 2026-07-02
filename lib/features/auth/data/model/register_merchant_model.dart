class RegisterMerchantModel {
  String? message;
  bool? success;

  RegisterMerchantModel({this.message, this.success});

  RegisterMerchantModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'] ?? true;
  }
}
