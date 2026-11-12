import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class GetProductListParams extends BaseParams {
  final GetListRequest? request;
  final String? categoryId;

  /// Free-text search (backend `Filter`: matches product name / description /
  /// category name). Omitted from the query when null or empty.
  final String? filter;

  GetProductListParams({this.request, this.categoryId, this.filter});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
      if (categoryId != null) 'CategoryId': categoryId,
      if (filter != null && filter!.isNotEmpty) 'Filter': filter,
    };
  }
}

class GetProductListUsecase
    extends UseCase<List<ProductModel>, GetProductListParams> {
  final ProductRepository repository;

  GetProductListUsecase(this.repository);

  @override
  Future<Result<List<ProductModel>>> call({
    required GetProductListParams params,
  }) {
    return repository.getProductListRequest(params: params);
  }
}
