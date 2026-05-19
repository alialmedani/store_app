import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/lookup_model.dart';
import '../repository/lookups_repository.dart';

class GetBrandsParams extends BaseParams {}

class GetBrandsUsecase extends UseCase<List<LookupModel>, GetBrandsParams> {
  final LookupsRepository repository;

  GetBrandsUsecase(this.repository);

  @override
  Future<Result<List<LookupModel>>> call({required GetBrandsParams params}) {
    return repository.getBrandsRequest();
  }
}