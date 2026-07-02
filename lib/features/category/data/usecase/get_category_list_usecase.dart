import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';
import 'get_category_params.dart';

class GetCategoryListUsecase
    extends UseCase<List<CategoryModel>, GetCategoryParams> {
  final CategoryRepository repository;

  GetCategoryListUsecase(this.repository);

  @override
  Future<Result<List<CategoryModel>>> call({
    required GetCategoryParams params,
  }) {
    return repository.getCategoryListRequest(params: params);
  }
}
