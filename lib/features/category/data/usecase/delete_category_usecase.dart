import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/category_repository.dart';

class DeleteCategoryParams extends BaseParams {
  final String id;

  DeleteCategoryParams({required this.id});
}

class DeleteCategoryUsecase extends UseCase<bool, DeleteCategoryParams> {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteCategoryParams params}) {
    return repository.deleteCategoryRequest(params: params);
  }
}
