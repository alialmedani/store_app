import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/brand_model.dart';
import '../usecase/brand_usecase.dart';

const String baseUrl = 'http://10.200.0.112:7151';
const String brandsUrl = '$baseUrl/api/Brands';

class BrandRepository extends CoreRepository {
  Future<Result<List<BrandModel>>> getBrandsRequest() async {
    final result = await RemoteDataSource.request<List<BrandModel>>(
      withAuthentication: false,
      url: brandsUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((e) => BrandModel.fromJson(e)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<BrandModel>> getBrandByIdRequest({
    required GetBrandByIdParams params,
  }) async {
    final result = await RemoteDataSource.request<BrandModel>(
      withAuthentication: false,
      url: '$brandsUrl/${params.id}',
      method: HttpMethod.GET,
      converter: (json) => BrandModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<BrandModel>> createBrandRequest({
    required CreateBrandParams params,
  }) async {
    final result = await RemoteDataSource.request<BrandModel>(
      withAuthentication: false,
      url: brandsUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => BrandModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<BrandModel>> updateBrandRequest({
    required UpdateBrandParams params,
  }) async {
    final result = await RemoteDataSource.request<BrandModel>(
      withAuthentication: false,
      url: '$brandsUrl/${params.id}',
      method: HttpMethod.PUT,
      data: params.toJson(),
      converter: (json) => BrandModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<dynamic>> deleteBrandRequest({
    required BrandActionParams params,
  }) async {
    final result = await RemoteDataSource.request<dynamic>(
      withAuthentication: false,
      url: '$brandsUrl/${params.id}',
      method: HttpMethod.DELETE,
      converter: (json) => json,
    );

    return call(result: result);
  }

  Future<Result<BrandModel>> activateBrandRequest({
    required BrandActionParams params,
  }) async {
    final result = await RemoteDataSource.request<BrandModel>(
      withAuthentication: false,
      url: '$brandsUrl/${params.id}/activate',
      method: HttpMethod.PUT,
      converter: (json) => BrandModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<BrandModel>> deactivateBrandRequest({
    required BrandActionParams params,
  }) async {
    final result = await RemoteDataSource.request<BrandModel>(
      withAuthentication: false,
      url: '$brandsUrl/${params.id}/deactivate',
      method: HttpMethod.PUT,
      converter: (json) => BrandModel.fromJson(json),
    );

    return call(result: result);
  }
}