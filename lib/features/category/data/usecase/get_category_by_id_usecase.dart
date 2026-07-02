import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';
import 'get_category_params.dart';

class GetCategoryByIdUsecase extends UseCase<CategoryModel, GetCategoryParams> {
  final CategoryRepository repository;

  GetCategoryByIdUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required GetCategoryParams params,
  }) {
    return repository.getCategoryByIdRequest(id: params.id!);
  }
}
