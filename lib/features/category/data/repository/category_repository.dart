import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/category_model.dart';
import '../model/category_stock_summary_model.dart';
import '../usecase/create_category_usecase.dart';
import '../usecase/get_category_details_usecase.dart';
import '../usecase/get_category_list_usecase.dart';
import '../usecase/get_category_stock_summary_usecase.dart';
import '../usecase/update_category_usecase.dart';

class CategoryRepository extends CoreRepository {
  Future<Result<CategoryModel>> createCategoryRequest({
    required CreateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createCategoryUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return CategoryModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<CategoryModel>>> getCategoryListRequest({
    required GetCategoryListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<CategoryModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getCategoryListUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List;
        return items.map((item) => CategoryModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<CategoryModel>> getCategoryDetailsRequest({
    required GetCategoryDetailsParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: getCategoryDetailsUrl(params.categoryId),
      method: HttpMethod.GET,
      converter: (json) {
        return CategoryModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<CategoryStockSummaryModel>>>
  getCategoryStockSummaryRequest({
    required GetCategoryStockSummaryParams params,
  }) async {
    final result =
        await RemoteDataSource.request<List<CategoryStockSummaryModel>>(
          withAuthentication: true,
          queryParameters: params.toJson(),
          url: getCategoryStockSummaryUrl,
          method: HttpMethod.GET,
          converter: (json) {
            final items = json['items'] as List;
            return items
                .map((item) => CategoryStockSummaryModel.fromJson(item))
                .toList();
          },
        );

    return paginatedCall(result: result);
  }

  Future<Result<CategoryModel>> updateCategoryRequest({
    required UpdateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: updateCategoryUrl(params.id!),
      method: HttpMethod.PUT,
      converter: (json) {
        return CategoryModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
