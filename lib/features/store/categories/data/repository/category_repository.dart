import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/category_model.dart';
import '../usecase/category_usecase.dart';

const String baseUrl = 'http://10.200.0.112:7151';
const String categoriesUrl = '$baseUrl/api/Categories';

class CategoryRepository extends CoreRepository {
  Future<Result<List<CategoryModel>>> getCategoriesRequest() async {
    final result = await RemoteDataSource.request<List<CategoryModel>>(
      withAuthentication: false,
      url: categoriesUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<CategoryModel>> getCategoryByIdRequest({
    required GetCategoryByIdParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: false,
      url: '$categoriesUrl/${params.id}',
      method: HttpMethod.GET,
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<CategoryModel>> createCategoryRequest({
    required CreateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: false,
      url: categoriesUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<CategoryModel>> updateCategoryRequest({
    required UpdateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: false,
      url: '$categoriesUrl/${params.id}',
      method: HttpMethod.PUT,
      data: params.toJson(),
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<dynamic>> deleteCategoryRequest({
    required CategoryActionParams params,
  }) async {
    final result = await RemoteDataSource.request<dynamic>(
      withAuthentication: false,
      url: '$categoriesUrl/${params.id}',
      method: HttpMethod.DELETE,
      converter: (json) => json,
    );

    return call(result: result);
  }

  Future<Result<CategoryModel>> activateCategoryRequest({
    required CategoryActionParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: false,
      url: '$categoriesUrl/${params.id}/activate',
      method: HttpMethod.PUT,
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }

  Future<Result<CategoryModel>> deactivateCategoryRequest({
    required CategoryActionParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: false,
      url: '$categoriesUrl/${params.id}/deactivate',
      method: HttpMethod.PUT,
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }
}