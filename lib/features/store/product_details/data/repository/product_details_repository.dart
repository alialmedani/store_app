import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';

import '../model/product_details_model.dart';
import '../usecase/get_product_details_usecase.dart';

const String baseUrl = 'http://10.200.0.112:7151';

class ProductDetailsRepository extends CoreRepository {
  Future<Result<ProductDetailsModel>> getProductDetailsRequest({
    required GetProductDetailsParams params,
  }) async {
    final result =
        await RemoteDataSource.request<ProductDetailsModel>(
      withAuthentication: false,
      url: '$baseUrl/api/Products/${params.id}/details',
      method: HttpMethod.GET,
      converter: (json) => ProductDetailsModel.fromJson(json),
    );

    return call(result: result);
  }
}