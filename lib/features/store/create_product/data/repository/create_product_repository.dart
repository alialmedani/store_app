import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/create_product_response_model.dart';
import '../usecase/create_product_with_variants_usecase.dart';

const String baseUrl = 'http://10.200.0.112:7151';
const String createProductWithVariantsUrl =
    '$baseUrl/api/Products/create-with-variants';

class CreateProductRepository extends CoreRepository {
  Future<Result<CreateProductResponseModel>> createProductWithVariantsRequest({
    required CreateProductWithVariantsParams params,
  }) async {
    final result = await RemoteDataSource.request<CreateProductResponseModel>(
      withAuthentication: false,
      url: createProductWithVariantsUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => CreateProductResponseModel.fromJson(json),
    );

    return call(result: result);
  }
}