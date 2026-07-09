import '../../../../../core/params/base_params.dart';

class ForceChangePasswordParams extends BaseParams {
  String userId;
  String currentPassword;
  String newPassword;

  ForceChangePasswordParams({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

// class ForceChangePasswordUsecase
//     extends UseCase<dynamic, ForceChangePasswordParams> {
//   final AuthRepository repository;

//   ForceChangePasswordUsecase(this.repository);

//   @override
//   Future<Result<dynamic>> call({required ForceChangePasswordParams params}) {
//     return repository.forceChangePasswordRequest(params: params);
//   }
// }
