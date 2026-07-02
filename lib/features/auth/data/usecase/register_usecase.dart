import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/register_model.dart';
import '../repository/auth_repository.dart';

class RegisterParams extends BaseParams {
  String userName;
  String emailAddress;
  String password;
  String appName;

  RegisterParams({
    required this.userName,
    required this.emailAddress,
    required this.password,
    required this.appName,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName.trim(),
      "emailAddress": emailAddress.trim(),
      "password": password.trim(),
      "appName": appName,
    };
  }
}

class RegisterUsecase extends UseCase<RegisterModel, RegisterParams> {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  @override
  Future<Result<RegisterModel>> call({required RegisterParams params}) {
    return repository.registerRequest(params: params);
  }
}
