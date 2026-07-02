const String baseUrl = 'http://10.0.2.2:5000';
const loginUrl = '$baseUrl/connect/token';
const registerUrl = '$baseUrl/api/account/register';
const appConfigUrl = '$baseUrl/api/abp/application-configuration';
const setDeviceIdUrl = '$baseUrl/api/app/user-device/set-device-id';

// ========== Category URLs ==========
const createCategoryUrl = '$baseUrl/api/app/category';
const String getCategoryListUrl = '$baseUrl/api/app/category';

// ========== Product URLs ==========
const createProductUrl = '$baseUrl/api/app/product';
const getProductListUrl = '$baseUrl/api/app/product';

String getProductDetailsUrl(String id) => '$baseUrl/api/app/product/$id';

String updateProductUrl(String id) => '$baseUrl/api/app/product/$id';

String deleteProductUrl(String id) => '$baseUrl/api/app/product/$id';
