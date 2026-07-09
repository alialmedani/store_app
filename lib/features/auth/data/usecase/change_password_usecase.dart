import '../../../../../core/params/base_params.dart';

class ChangePasswordParams extends BaseParams {
  String currentPassword;
  String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }
}

// class ChangePasswordUsecase extends UseCase<dynamic, ChangePasswordParams> {
//   final AuthRepository repository;

//   ChangePasswordUsecase(this.repository);

//   @override
//   Future<Result<dynamic>> call({required ChangePasswordParams params}) {
//     return repository.changePasswordRequest(params: params);
//   }
// }
