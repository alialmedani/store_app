import '../../../../../core/params/base_params.dart';

class RegisterDriverParams extends BaseParams {
  String username;
  String email;
  String password;
  String firstName;
  String lastName;
  String firstNameAr;
  String lastNameAr;
  String phone;
  String nationalId;
  String licenseNumber;
  String licenseExpiryDate;
  String vehicleType;
  String vehiclePlate;
  int type;

  RegisterDriverParams({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.phone,
    required this.nationalId,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "firstNameAr": firstNameAr.trim(),
      "lastNameAr": lastNameAr.trim(),
      "phone": phone.trim(),
      "nationalId": nationalId.trim(),
      "licenseNumber": licenseNumber.trim(),
      "licenseExpiryDate": licenseExpiryDate,
      "vehicleType": vehicleType.trim(),
      "vehiclePlate": vehiclePlate.trim(),
      "type": type,
    };
  }
}

// class RegisterDriverUsecase
//     extends UseCase<RegisterDriverModel, RegisterDriverParams> {
//   late final AuthRepository repository;
//   RegisterDriverUsecase(this.repository);

//   @override
//   Future<Result<RegisterDriverModel>> call({
//     required RegisterDriverParams params,
//   }) {
//     return repository.registerDriverRequest(params: params);
//   }
// }
