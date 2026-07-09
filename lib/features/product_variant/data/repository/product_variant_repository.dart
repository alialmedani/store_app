import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/product_variant_model.dart';
import '../usecase/bulk_create_product_variant_usecase.dart';
import '../usecase/create_product_variant_usecase.dart';
import '../usecase/generate_product_variant_usecase.dart';
import '../usecase/get_product_variant_details_usecase.dart';
import '../usecase/get_product_variant_list_usecase.dart';
import '../usecase/update_product_variant_usecase.dart';

class ProductVariantRepository extends CoreRepository {
  Future<Result<ProductVariantModel>> createProductVariantRequest({
    required CreateProductVariantParams params,
  }) async {
    final result = await RemoteDataSource.request<ProductVariantModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createProductVariantUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return ProductVariantModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<ProductVariantModel>>> getProductVariantListRequest({
    required GetProductVariantListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<ProductVariantModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getProductVariantListUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List;
        return items.map((item) => ProductVariantModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<ProductVariantModel>> getProductVariantDetailsRequest({
    required GetProductVariantDetailsParams params,
  }) async {
    final result = await RemoteDataSource.request<ProductVariantModel>(
      withAuthentication: true,
      url: getProductVariantDetailsUrl(params.productVariantId),
      method: HttpMethod.GET,
      converter: (json) {
        return ProductVariantModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<ProductVariantModel>>> bulkCreateProductVariantRequest({
    required BulkCreateProductVariantParams params,
  }) async {
    final result = await RemoteDataSource.request<List<ProductVariantModel>>(
      withAuthentication: true,
      data: params.toJson(),
      url: bulkCreateProductVariantUrl,
      method: HttpMethod.POST,
      converter2: (json) {
        if (json is List) {
          return json
              .map((item) => ProductVariantModel.fromJson(item))
              .toList();
        }
        return [];
      },
    );

    return call(result: result);
  }

  Future<Result<List<ProductVariantModel>>> generateProductVariantRequest({
    required GenerateProductVariantParams params,
  }) async {
    final result = await RemoteDataSource.request<List<ProductVariantModel>>(
      withAuthentication: true,
      data: params.toJson(),
      url: generateProductVariantUrl,
      method: HttpMethod.POST,
      converter2: (json) {
        if (json is List) {
          return json
              .map((item) => ProductVariantModel.fromJson(item))
              .toList();
        }
        return [];
      },
    );

    return call(result: result);
  }

  Future<Result<ProductVariantModel>> updateProductVariantRequest({
    required UpdateProductVariantParams params,
  }) async {
    final result = await RemoteDataSource.request<ProductVariantModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: updateProductVariantUrl(params.productVariantId),
      method: HttpMethod.PUT,
      converter: (json) {
        return ProductVariantModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
