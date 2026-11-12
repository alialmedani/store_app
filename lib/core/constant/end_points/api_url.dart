//emulator
// const String baseUrl = 'http://10.0.2.2:5000';
/*     
dotnet run --project src/StoreManagement.Web --launch-profile StoreManagement.Web
*/


// mobile  
/*  
dotnet run --project src/StoreManagement.Web --urls "http://0.0.0.0:5000"
*/
const String baseUrl = 'http://10.200.0.91:5000';


const loginUrl = '$baseUrl/connect/token';
const registerUrl = '$baseUrl/api/account/register';
const appConfigUrl = '$baseUrl/api/abp/application-configuration';
const setDeviceIdUrl = '$baseUrl/api/app/user-device/set-device-id';

// ========== File Upload URLs ==========
const uploadFileUrl = '$baseUrl/api/app/file/upload';

String getFileByNameUrl(String fileName) =>
    '$baseUrl/api/app/file/by-file-name/$fileName';

/// Get file URL by entity (NEW METHOD - recommended)
/// Example: getFileByEntityUrl(entityId: productId, entityType: 2)
String getFileByEntityUrl({
  required String entityId,
  required int entityType,
  String? filePlacement,
}) {
  // ✅ Using route parameter for entityId, query params for entityType & filePlacement
  String url =
      '$baseUrl/api/app/file/by-entity/$entityId?entityType=$entityType';
  if (filePlacement != null && filePlacement.isNotEmpty) {
    url += '&filePlacement=$filePlacement';
  }
  return url;
}

//  ========== Category URLs ==========
const createCategoryUrl = '$baseUrl/api/app/category';
const getCategoryListUrl = '$baseUrl/api/app/category';
const getCategoryStockSummaryUrl = '$baseUrl/api/app/category/stock-summary';

String getCategoryDetailsUrl(String id) => '$baseUrl/api/app/category/$id';
String updateCategoryUrl(String id) => '$baseUrl/api/app/category/$id';
String deleteCategoryUrl(String id) => '$baseUrl/api/app/category/$id';

// ========== Product URLs ==========
const createProductUrl = '$baseUrl/api/app/product';
const getProductListUrl = '$baseUrl/api/app/product';

String getProductDetailsUrl(String id) => '$baseUrl/api/app/product/$id';
String updateProductUrl(String id) => '$baseUrl/api/app/product/$id';
String deleteProductUrl(String id) => '$baseUrl/api/app/product/$id';

// ========== Product Variant URLs ==========
const createProductVariantUrl = '$baseUrl/api/app/product-variant';
const bulkCreateProductVariantUrl =
    '$baseUrl/api/app/product-variant/bulk-create';
const generateProductVariantUrl = '$baseUrl/api/app/product-variant/generate';
const getProductVariantListUrl = '$baseUrl/api/app/product-variant';

String getProductVariantDetailsUrl(String id) =>
    '$baseUrl/api/app/product-variant/$id';
String updateProductVariantUrl(String id) =>
    '$baseUrl/api/app/product-variant/$id';
String deleteProductVariantUrl(String id) =>
    '$baseUrl/api/app/product-variant/$id';

// ========== Order URLs ==========
const createOrderUrl = '$baseUrl/api/app/order';
const getOrderListUrl = '$baseUrl/api/app/order';

String getOrderDetailsUrl(String id) => '$baseUrl/api/app/order/$id';
String updateOrderUrl(String id) => '$baseUrl/api/app/order/$id';
String updateOrderItemUrl(String id, String itemId) =>
    '$baseUrl/api/app/order/$id/item/$itemId';

// ========== Inventory URLs ==========
const getInventoryListUrl = '$baseUrl/api/app/inventory';
const adjustStockUrl = '$baseUrl/api/app/inventory/adjust-stock';

String getInventoryDetailsUrl(String id) => '$baseUrl/api/app/inventory/$id';
String getInventoryVariantHistorySummaryUrl(String productVariantId) =>
    '$baseUrl/api/app/inventory/variant-history-summary/$productVariantId';

// ========== Dashboard URLs ==========
const getDashboardSummaryUrl = '$baseUrl/api/app/product/dashboard-summary';

// ========== Order Action URLs ==========
String confirmOrderUrl(String id) => '$baseUrl/api/app/order/$id/confirm';
String cancelOrderUrl(String id) => '$baseUrl/api/app/order/$id/cancel';
String recordOrderPaymentUrl(String id) =>
    '$baseUrl/api/app/order/$id/record-payment';
String addOrderItemUrl(String id) => '$baseUrl/api/app/order/$id/item';
String removeOrderItemUrl(String id, String itemId) =>
    '$baseUrl/api/app/order/$id/item/$itemId';
String deleteOrderUrl(String id) => '$baseUrl/api/app/order/$id';

// ========== Reports URLs ==========
// Route prefix is singular `/api/app/report` (ABP conventional routing of
// `ReportAppService`). Confirm against Swagger if a route 404s.
const getSalesSummaryUrl = '$baseUrl/api/app/report/sales-summary';
const getInventoryStatusReportUrl = '$baseUrl/api/app/report/inventory-status';
const getTopSellersUrl = '$baseUrl/api/app/report/top-sellers';
const getStockMovementsReportUrl = '$baseUrl/api/app/report/stock-movements';
const getCategoryPerformanceUrl =
    '$baseUrl/api/app/report/category-performance';
const getProfitMarginUrl = '$baseUrl/api/app/report/profit-margin';

// ========== Deleted (Trash) / Restore URLs ==========
const getDeletedCategoryListUrl = '$baseUrl/api/app/category/deleted-list';
String restoreCategoryUrl(String id) => '$baseUrl/api/app/category/$id/restore';

const getDeletedProductListUrl = '$baseUrl/api/app/product/deleted-list';
String restoreProductUrl(String id) => '$baseUrl/api/app/product/$id/restore';

const getDeletedProductVariantListUrl =
    '$baseUrl/api/app/product-variant/deleted-list';
String restoreProductVariantUrl(String id) =>
    '$baseUrl/api/app/product-variant/$id/restore';
