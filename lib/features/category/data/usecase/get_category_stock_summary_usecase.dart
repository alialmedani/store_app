import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_stock_summary_model.dart';
import '../repository/category_repository.dart';

class GetCategoryStockSummaryParams extends BaseParams {
  GetListRequest? request;

  GetCategoryStockSummaryParams({this.request});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
    };
  }
}

class GetCategoryStockSummaryUsecase
    extends
        UseCase<
          List<CategoryStockSummaryModel>,
          GetCategoryStockSummaryParams
        > {
  final CategoryRepository repository;

  GetCategoryStockSummaryUsecase(this.repository);

  @override
  Future<Result<List<CategoryStockSummaryModel>>> call({
    required GetCategoryStockSummaryParams params,
  }) {
    return repository.getCategoryStockSummaryRequest(params: params);
  }
}
