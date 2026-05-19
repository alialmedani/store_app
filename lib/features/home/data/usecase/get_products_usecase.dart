import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/home_repository.dart';

class GetProductsParams extends BaseParams {
  final GetListRequest? request;

  GetProductsParams({this.request});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'pageNumber': ((request!.skip ?? 0) ~/ (request!.take ?? 10)) + 1,
        'pageSize': request!.take ?? 10,
      },
    };
  }
}

class GetProductsUsecase extends UseCase<List<ProductModel>, GetProductsParams> {
  final HomeRepository repository;

  GetProductsUsecase(this.repository);

  @override
  Future<Result<List<ProductModel>>> call({
    required GetProductsParams params,
  }) {
    return repository.getProductsRequest(params: params);
  }
}