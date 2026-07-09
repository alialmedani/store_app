import '../../../../../core/params/base_params.dart';

class RegisterMerchantParams extends BaseParams {
  String username;
  String email;
  String password;
  String businessName;
  String businessNameAr;
  String phone;
  String commercialRegistrationNumber;
  String taxNumber;
  double codFeePercentage;
  double creditLimit;
  String? facebook;
  String? instagram;
  String? snapchat;
  String? tiktok;
  String? cityId;
  String? provinceId;
  String? description;
  bool hasPhysicalShop;
  double? latitude;
  double? longitude;

  RegisterMerchantParams({
    required this.username,
    required this.email,
    required this.password,
    required this.businessName,
    required this.businessNameAr,
    required this.phone,
    required this.commercialRegistrationNumber,
    required this.taxNumber,
    required this.codFeePercentage,
    required this.creditLimit,
    required this.cityId,
    required this.provinceId,
    required this.description,
    this.facebook,
    this.instagram,
    this.snapchat,
    this.tiktok,
    this.hasPhysicalShop = false,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "businessName": businessName.trim(),
      "businessNameAr": businessNameAr.trim(),
      "phone": phone.trim(),
      "commercialRegistrationNumber": commercialRegistrationNumber.trim(),
      "taxNumber": taxNumber.trim(),
      "codFeePercentage": codFeePercentage,
      "CityId": cityId,
      "Description": description,
      "ProvinceId": provinceId,
      "creditLimit": creditLimit,
      if (facebook != null && facebook!.isNotEmpty)
        "facebook": facebook!.trim(),
      if (instagram != null && instagram!.isNotEmpty)
        "instagram": instagram!.trim(),
      if (snapchat != null && snapchat!.isNotEmpty)
        "snapchat": snapchat!.trim(),
      if (tiktok != null && tiktok!.isNotEmpty) "tiktok": tiktok!.trim(),
      "hasPhysicalShop": hasPhysicalShop,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
    };
  }
}

// class RegisterMerchantUsecase
//     extends UseCase<RegisterMerchantModel, RegisterMerchantParams> {
//   late final AuthRepository repository;
//   RegisterMerchantUsecase(this.repository);

//   @override
//   Future<Result<RegisterMerchantModel>> call({
//     required RegisterMerchantParams params,
//   }) {
//     return repository.registerMerchantRequest(params: params);
//   }
// }
