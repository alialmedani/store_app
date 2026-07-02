import '../../../../../../core/params/base_params.dart';
import '../../../../../../core/results/result.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../model/current_user_model.dart';
import '../repository/auth_repository.dart';

class GetAppConfigParams extends BaseParams {
  GetAppConfigParams();

  Map<String, dynamic> toJson() {
    return {};
  }
}

class GetAppConfigUsecase
    extends UseCase<CurrentUserModel, GetAppConfigParams> {
  final AuthRepository repository;

  GetAppConfigUsecase(this.repository);

  @override
  Future<Result<CurrentUserModel>> call({required GetAppConfigParams params}) {
    return repository.getAppConfigRequest(params: params);
  }
}
