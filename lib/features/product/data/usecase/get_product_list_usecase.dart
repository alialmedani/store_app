import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class GetProductListParams extends BaseParams {
  final GetListRequest? request;

  GetProductListParams({this.request});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
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
