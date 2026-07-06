import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/product_model.dart';
import '../usecase/create_product_usecase.dart';
import '../usecase/get_product_details_usecase.dart';
import '../usecase/get_product_list_usecase.dart';

class ProductRepository extends CoreRepository {
  Future<Result<ProductModel>> createProductRequest({
    required CreateProductParams params,
  }) async {
    final result = await RemoteDataSource.request<ProductModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createProductUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return ProductModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<ProductModel>>> getProductListRequest({
    required GetProductListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<ProductModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getProductListUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List;
        return items.map((item) => ProductModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<ProductModel>> getProductDetailsRequest({
    required GetProductDetailsParams params,
  }) async {
    final result = await RemoteDataSource.request<ProductModel>(
      withAuthentication: true,
      url: getProductDetailsUrl(params.productId),
      method: HttpMethod.GET,
      converter: (json) {
        return ProductModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
