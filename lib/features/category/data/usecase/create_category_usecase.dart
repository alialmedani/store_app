import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';
import 'create_category_params.dart';

class CreateCategoryUsecase
    extends UseCase<CategoryModel, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({required CreateCategoryParams params}) {
    return repository.createCategoryRequest(params: params);
  }
}
