import 'package:store/core/constant/end_points/api_url.dart';
import 'package:store/core/data_source/remote_data_source.dart';
import 'package:store/core/http/http_method.dart';
import 'package:store/core/repository/core_repository.dart';
import 'package:store/core/results/result.dart';

import '../model/category_performance_model.dart';
import '../model/inventory_status_model.dart';
import '../model/profit_margin_model.dart';
import '../model/sales_summary_model.dart';
import '../model/stock_movement_report_model.dart';
import '../model/top_sellers_model.dart';
import '../usecase/get_category_performance_usecase.dart';
import '../usecase/get_inventory_status_usecase.dart';
import '../usecase/get_profit_margin_usecase.dart';
import '../usecase/get_sales_summary_usecase.dart';
import '../usecase/get_stock_movements_report_usecase.dart';
import '../usecase/get_top_sellers_usecase.dart';

class ReportsRepository extends CoreRepository {
  Future<Result<SalesSummaryModel>> getSalesSummaryRequest({
    required GetSalesSummaryParams params,
  }) async {
    final result = await RemoteDataSource.request<SalesSummaryModel>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getSalesSummaryUrl,
      method: HttpMethod.GET,
      converter: (json) => SalesSummaryModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<InventoryStatusModel>> getInventoryStatusRequest({
    required GetInventoryStatusParams params,
  }) async {
    final result = await RemoteDataSource.request<InventoryStatusModel>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getInventoryStatusReportUrl,
      method: HttpMethod.GET,
      converter: (json) => InventoryStatusModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<TopSellersModel>> getTopSellersRequest({
    required GetTopSellersParams params,
  }) async {
    final result = await RemoteDataSource.request<TopSellersModel>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getTopSellersUrl,
      method: HttpMethod.GET,
      converter: (json) => TopSellersModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<CategoryPerformanceModel>> getCategoryPerformanceRequest({
    required GetCategoryPerformanceParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryPerformanceModel>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getCategoryPerformanceUrl,
      method: HttpMethod.GET,
      converter: (json) => CategoryPerformanceModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<ProfitMarginModel>> getProfitMarginRequest({
    required GetProfitMarginParams params,
  }) async {
    final result = await RemoteDataSource.request<ProfitMarginModel>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getProfitMarginUrl,
      method: HttpMethod.GET,
      converter: (json) => ProfitMarginModel.fromJson(json),
    );
    return call(result: result);
  }

  Future<Result<List<StockMovementReportModel>>> getStockMovementsRequest({
    required GetStockMovementsReportParams params,
  }) async {
    final result =
        await RemoteDataSource.request<List<StockMovementReportModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getStockMovementsReportUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List? ?? const [];
        return items
            .map((item) => StockMovementReportModel.fromJson(item))
            .toList();
      },
    );
    return paginatedCall(result: result);
  }
}
