import '../../../../core/constant/end_points/api_url.dart';
import '../../../../core/data_source/remote_data_source.dart';
import '../../../../core/http/http_method.dart';
import '../../../../core/repository/core_repository.dart';
import '../../../../core/results/result.dart';
import '../model/category_model.dart';
import '../usecase/create_category_params.dart';
import '../usecase/get_category_params.dart';

class CategoryRepository extends CoreRepository {
  /// CREATE - POST request
  Future<Result<CategoryModel>> createCategoryRequest({
    required CreateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: createCategoryUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  /// READ LIST - GET request with pagination
  Future<Result<List<CategoryModel>>> getCategoryListRequest({
    required GetCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<List<CategoryModel>>(
      withAuthentication: true,
      url: getCategoryListUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) {
        final List<dynamic> data = json['items'] ?? json['data'] ?? json;
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  /// READ SINGLE - GET by ID
  Future<Result<CategoryModel>> getCategoryByIdRequest({
    required String id,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: '$getCategoryListUrl/$id',
      method: HttpMethod.GET,
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  /// UPDATE - PUT request
  Future<Result<CategoryModel>> updateCategoryRequest({
    required CreateCategoryParams params,
    required String id,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: '$createCategoryUrl/$id',
      method: HttpMethod.PUT,
      data: params.toJson(),
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  /// DELETE - DELETE request
  Future<Result<CategoryModel>> deleteCategoryRequest({
    required String id,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: '$createCategoryUrl/$id',
      method: HttpMethod.DELETE,
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }
}
