import '../../../../../core/params/base_params.dart';

class VerifyOtpParams extends BaseParams {
  String phone;
  String code;

  VerifyOtpParams({required this.phone, required this.code});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'code': code};
  }
}

// class VerifyOtpUsecase extends UseCase<VerifyOtpModel, VerifyOtpParams> {
//   final AuthRepository repository;

//   VerifyOtpUsecase(this.repository);

//   @override
//   Future<Result<VerifyOtpModel>> call({required VerifyOtpParams params}) async {
//     return await repository.verifyOtp(params);
//   }
// }
