import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoryListParams extends BaseParams {
  final GetListRequest? request;

  GetCategoryListParams({
    this.request,
  });

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
    };
  }
}

class GetCategoryListUsecase
    extends UseCase<List<CategoryModel>, GetCategoryListParams> {
  final CategoryRepository repository;

  GetCategoryListUsecase(this.repository);

  @override
  Future<Result<List<CategoryModel>>> call({
    required GetCategoryListParams params,
  }) {
    return repository.getCategoryListRequest(params: params);
  }
}
