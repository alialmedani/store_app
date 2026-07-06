import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoryDetailsParams extends BaseParams {
  final String categoryId;

  GetCategoryDetailsParams({required this.categoryId});
}

class GetCategoryDetailsUsecase
    extends UseCase<CategoryModel, GetCategoryDetailsParams> {
  final CategoryRepository repository;

  GetCategoryDetailsUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required GetCategoryDetailsParams params,
  }) {
    return repository.getCategoryDetailsRequest(params: params);
  }
}
