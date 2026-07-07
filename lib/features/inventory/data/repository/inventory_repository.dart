import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/inventory_model.dart';
import '../usecase/adjust_stock_usecase.dart';
import '../usecase/get_inventory_details_usecase.dart';
import '../usecase/get_inventory_list_usecase.dart';

class InventoryRepository extends CoreRepository {
  Future<Result<List<InventoryModel>>> getInventoryListRequest({
    required GetInventoryListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<InventoryModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getInventoryListUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List;
        return items.map((item) => InventoryModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<InventoryModel>> getInventoryDetailsRequest({
    required GetInventoryDetailsParams params,
  }) async {
    final result = await RemoteDataSource.request<InventoryModel>(
      withAuthentication: true,
      url: getInventoryDetailsUrl(params.inventoryId),
      method: HttpMethod.GET,
      converter: (json) {
        return InventoryModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<InventoryModel>> adjustStockRequest({
    required AdjustStockParams params,
  }) async {
    final result = await RemoteDataSource.request<InventoryModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: adjustStockUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return InventoryModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
