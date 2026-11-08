import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/category_repository.dart';
import '../model/category_model.dart';
import 'get_category_list_usecase.dart';

class GetDeletedCategoryListUsecase
    extends UseCase<List<CategoryModel>, GetCategoryListParams> {
  final CategoryRepository repository;

  GetDeletedCategoryListUsecase(this.repository);

  @override
  Future<Result<List<CategoryModel>>> call({required GetCategoryListParams params}) {
    return repository.getDeletedCategoryListRequest(params: params);
  }
}
