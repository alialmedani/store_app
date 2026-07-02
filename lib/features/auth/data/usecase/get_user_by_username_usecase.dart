import '../../../../../core/params/base_params.dart';

class GetUserByUsernameParams extends BaseParams {
  String userName;

  GetUserByUsernameParams({required this.userName});

  Map<String, dynamic> toJson() {
    return {'userName': userName};
  }
}

// class GetUserByUsernameUsecase
//     extends UseCase<UserIdentityModel, GetUserByUsernameParams> {
//   final AuthRepository repository;

//   GetUserByUsernameUsecase(this.repository);

//   @override
//   Future<Result<UserIdentityModel>> call({
//     required GetUserByUsernameParams params,
//   }) async {
//     return await repository.getUserByUsername(params);
//   }
// }
