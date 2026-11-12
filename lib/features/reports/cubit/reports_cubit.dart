import 'package:bloc/bloc.dart';

import 'package:store/core/results/result.dart';
import '../data/model/category_performance_model.dart';
import '../data/model/inventory_status_model.dart';
import '../data/model/profit_margin_model.dart';
import '../data/model/sales_summary_model.dart';
import '../data/model/stock_movement_report_model.dart';
import '../data/model/top_sellers_model.dart';
import '../data/repository/reports_repository.dart';
import '../data/usecase/get_category_performance_usecase.dart';
import '../data/usecase/get_inventory_status_usecase.dart';
import '../data/usecase/get_profit_margin_usecase.dart';
import '../data/usecase/get_sales_summary_usecase.dart';
import '../data/usecase/get_stock_movements_report_usecase.dart';
import '../data/usecase/get_top_sellers_usecase.dart';

part 'reports_state.dart';

/// Holds the UI filter state for the 6 report screens and exposes the API
/// methods. Per CLAUDE.md: API methods return `Future<Result>` and NEVER
/// emit() loading/success/error (the GetModel/PaginationList boilerplate owns
/// that). emit() is only used for filter/UI state.
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  final ReportsRepository _repository = ReportsRepository();

  static DateTime _defaultFrom() =>
      DateTime.now().subtract(const Duration(days: 30));
  static DateTime _defaultTo() => DateTime.now();

  static String _fmt(DateTime d) => d.toIso8601String();

  // -------------------------------------------------------------------------
  // Sales Summary filters
  // -------------------------------------------------------------------------
  DateTime salesFrom = _defaultFrom();
  DateTime salesTo = _defaultTo();
  int salesGroupBy = 1; // 1=Day, 2=Week, 3=Month
  int? salesStatus;
  int? salesPaymentStatus;

  void setSalesRange(DateTime from, DateTime to) {
    salesFrom = from;
    salesTo = to;
    emit(ReportsFilterChanged());
  }

  void setSalesGroupBy(int groupBy) {
    salesGroupBy = groupBy;
    emit(ReportsFilterChanged());
  }

  void setSalesStatus(int? status) {
    salesStatus = status;
    emit(ReportsFilterChanged());
  }

  void setSalesPaymentStatus(int? paymentStatus) {
    salesPaymentStatus = paymentStatus;
    emit(ReportsFilterChanged());
  }

  Future<Result<SalesSummaryModel>> getSalesSummary() {
    return GetSalesSummaryUsecase(_repository).call(
      params: GetSalesSummaryParams(
        fromDate: _fmt(salesFrom),
        toDate: _fmt(salesTo),
        groupBy: salesGroupBy,
        status: salesStatus,
        paymentStatus: salesPaymentStatus,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Inventory Status filters
  // -------------------------------------------------------------------------
  String? inventoryCategoryId;
  bool inventoryLowStockOnly = false;
  int inventoryLowStockThreshold = 5;

  void setInventoryCategory(String? categoryId) {
    inventoryCategoryId = categoryId;
    emit(ReportsFilterChanged());
  }

  void setInventoryLowStockOnly(bool value) {
    inventoryLowStockOnly = value;
    emit(ReportsFilterChanged());
  }

  void setInventoryLowStockThreshold(int value) {
    inventoryLowStockThreshold = value < 0 ? 0 : value;
    emit(ReportsFilterChanged());
  }

  Future<Result<InventoryStatusModel>> getInventoryStatus() {
    return GetInventoryStatusUsecase(_repository).call(
      params: GetInventoryStatusParams(
        categoryId: inventoryCategoryId,
        lowStockOnly: inventoryLowStockOnly,
        lowStockThreshold: inventoryLowStockThreshold,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Top / Bottom Sellers filters
  // -------------------------------------------------------------------------
  DateTime topFrom = _defaultFrom();
  DateTime topTo = _defaultTo();
  bool topGroupByVariant = false;
  int topCount = 10;
  int topDirection = 1; // 1=Top, 2=Bottom
  int? topStatus;
  bool topIncludeDeleted = true;

  void setTopRange(DateTime from, DateTime to) {
    topFrom = from;
    topTo = to;
    emit(ReportsFilterChanged());
  }

  void setTopGroupByVariant(bool value) {
    topGroupByVariant = value;
    emit(ReportsFilterChanged());
  }

  void setTopDirection(int direction) {
    topDirection = direction;
    emit(ReportsFilterChanged());
  }

  void setTopCount(int count) {
    topCount = count.clamp(1, 200).toInt();
    emit(ReportsFilterChanged());
  }

  void setTopIncludeDeleted(bool value) {
    topIncludeDeleted = value;
    emit(ReportsFilterChanged());
  }

  Future<Result<TopSellersModel>> getTopSellers() {
    return GetTopSellersUsecase(_repository).call(
      params: GetTopSellersParams(
        fromDate: _fmt(topFrom),
        toDate: _fmt(topTo),
        groupByVariant: topGroupByVariant,
        top: topCount,
        direction: topDirection,
        status: topStatus,
        includeDeleted: topIncludeDeleted,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Category Performance filters
  // -------------------------------------------------------------------------
  DateTime categoryFrom = _defaultFrom();
  DateTime categoryTo = _defaultTo();
  int? categoryStatus;
  int? categoryPaymentStatus;
  bool categoryIncludeDeleted = true;

  void setCategoryRange(DateTime from, DateTime to) {
    categoryFrom = from;
    categoryTo = to;
    emit(ReportsFilterChanged());
  }

  void setCategoryIncludeDeleted(bool value) {
    categoryIncludeDeleted = value;
    emit(ReportsFilterChanged());
  }

  Future<Result<CategoryPerformanceModel>> getCategoryPerformance() {
    return GetCategoryPerformanceUsecase(_repository).call(
      params: GetCategoryPerformanceParams(
        fromDate: _fmt(categoryFrom),
        toDate: _fmt(categoryTo),
        status: categoryStatus,
        paymentStatus: categoryPaymentStatus,
        includeDeleted: categoryIncludeDeleted,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Profit / Margin filters
  // -------------------------------------------------------------------------
  DateTime profitFrom = _defaultFrom();
  DateTime profitTo = _defaultTo();
  String? profitCategoryId;
  String? profitProductId;
  bool profitGroupByVariant = false;
  int? profitStatus;
  bool profitIncludeDeleted = true;

  void setProfitRange(DateTime from, DateTime to) {
    profitFrom = from;
    profitTo = to;
    emit(ReportsFilterChanged());
  }

  void setProfitGroupByVariant(bool value) {
    profitGroupByVariant = value;
    emit(ReportsFilterChanged());
  }

  void setProfitIncludeDeleted(bool value) {
    profitIncludeDeleted = value;
    emit(ReportsFilterChanged());
  }

  Future<Result<ProfitMarginModel>> getProfitMargin() {
    return GetProfitMarginUsecase(_repository).call(
      params: GetProfitMarginParams(
        fromDate: _fmt(profitFrom),
        toDate: _fmt(profitTo),
        categoryId: profitCategoryId,
        productId: profitProductId,
        groupByVariant: profitGroupByVariant,
        status: profitStatus,
        includeDeleted: profitIncludeDeleted,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Stock Movements (paged) filters
  // -------------------------------------------------------------------------
  DateTime? movementsFrom;
  DateTime? movementsTo;
  String? movementsProductVariantId;
  int? movementsType;
  bool movementsIncludeDeleted = true;
  String movementsSorting = 'date desc';

  void setMovementsRange(DateTime? from, DateTime? to) {
    movementsFrom = from;
    movementsTo = to;
    emit(ReportsFilterChanged());
  }

  void setMovementsType(int? type) {
    movementsType = type;
    emit(ReportsFilterChanged());
  }

  void setMovementsIncludeDeleted(bool value) {
    movementsIncludeDeleted = value;
    emit(ReportsFilterChanged());
  }

  void setMovementsSorting(String sorting) {
    movementsSorting = sorting;
    emit(ReportsFilterChanged());
  }

  /// Paged fetch for the stock-movements list. `data` is the `GetListRequest`
  /// from the PaginationList boilerplate; the stored filters are merged in.
  Future<Result<List<StockMovementReportModel>>> fetchStockMovements(data) {
    return GetStockMovementsReportUsecase(_repository).call(
      params: GetStockMovementsReportParams(
        request: data,
        fromDate: movementsFrom != null ? _fmt(movementsFrom!) : null,
        toDate: movementsTo != null ? _fmt(movementsTo!) : null,
        productVariantId: movementsProductVariantId,
        movementType: movementsType,
        includeDeleted: movementsIncludeDeleted,
        sorting: movementsSorting,
      ),
    );
  }
}
