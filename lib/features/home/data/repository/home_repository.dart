import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/product_model.dart';
import '../usecase/get_products_usecase.dart';

const String getProductsUrl = 'http://10.200.0.112:7151/api/Products';

class HomeRepository extends CoreRepository {
  Future<Result<List<ProductModel>>> getProductsRequest({
    required GetProductsParams params,
  }) async {
    final result = await RemoteDataSource.request<List<ProductModel>>(
      withAuthentication: false,
      url: getProductsUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }
}