import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/category_repository.dart';

class RestoreCategoryParams extends BaseParams {
  final String id;

  RestoreCategoryParams({required this.id});
}

class RestoreCategoryUsecase extends UseCase<bool, RestoreCategoryParams> {
  final CategoryRepository repository;

  RestoreCategoryUsecase(this.repository);

  @override
  Future<Result<bool>> call({required RestoreCategoryParams params}) {
    return repository.restoreCategoryRequest(params: params);
  }
}
