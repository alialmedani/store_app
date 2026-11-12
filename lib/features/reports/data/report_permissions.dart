/// Exact ABP permission policy strings for the report endpoints
/// (from `StoreManagementPermissions.Reports` in the backend). Used to
/// permission-gate the report tabs/screens on the client.
class ReportPermissions {
  ReportPermissions._();

  static const String salesSummary = 'StoreManagement.Reports.SalesSummary';
  static const String inventoryStatus =
      'StoreManagement.Reports.InventoryStatus';
  static const String topSellers = 'StoreManagement.Reports.TopSellers';
  static const String stockMovements =
      'StoreManagement.Reports.StockMovements';
  static const String categoryPerformance =
      'StoreManagement.Reports.CategoryPerformance';
  static const String profitMargin = 'StoreManagement.Reports.ProfitMargin';
}
