import '../../../../../core/params/base_params.dart';

class ResetPasswordParams extends BaseParams {
  String userId;
  String newPassword;

  ResetPasswordParams({required this.userId, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'newPassword': newPassword};
  }
}

// class ResetPasswordUsecase extends UseCase<String, ResetPasswordParams> {
//   final AuthRepository repository;

//   ResetPasswordUsecase(this.repository);

//   @override
//   Future<Result<String>> call({required ResetPasswordParams params}) async {
//     return await repository.resetPassword(params);
//   }
// }
