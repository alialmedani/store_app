import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/login_model.dart';
import '../repository/auth_repository.dart';

class RefreshTokenParams extends BaseParams {
  String refreshToken;
  String grantType;
  String clientId;

  RefreshTokenParams({
    required this.grantType,
    required this.clientId,
    required this.refreshToken,
  });
  Map<String, String> toJson() {
    return {
      "grant_type": grantType,
      "client_id": clientId,
      "refresh_token": refreshToken,
    };
  }
}

class RefreshTokenUsecase extends UseCase<LoginModel, RefreshTokenParams> {
  late final AuthRepository repository;
  RefreshTokenUsecase(this.repository);

  @override
  Future<Result<LoginModel>> call({required RefreshTokenParams params}) {
    return repository.refreshTokenRequest(params: params);
  }
}
