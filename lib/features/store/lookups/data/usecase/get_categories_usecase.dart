import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/lookup_model.dart';
import '../repository/lookups_repository.dart';

class GetCategoriesParams extends BaseParams {}

class GetCategoriesUsecase extends UseCase<List<LookupModel>, GetCategoriesParams> {
  final LookupsRepository repository;

  GetCategoriesUsecase(this.repository);

  @override
  Future<Result<List<LookupModel>>> call({required GetCategoriesParams params}) {
    return repository.getCategoriesRequest();
  }
}