import '../../../../../core/params/base_params.dart';

class SendOtpParams extends BaseParams {
  String phone;

  SendOtpParams({required this.phone});

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}

// class SendOtpUsecase extends UseCase<SendOtpModel, SendOtpParams> {
//   final AuthRepository repository;

//   SendOtpUsecase(this.repository);

//   @override
//   Future<Result<SendOtpModel>> call({required SendOtpParams params}) async {
//     return await repository.sendOtp(params);
//   }
// }
