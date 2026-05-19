const baseUrl = 'http://10.200.0.112:7151/';
const getProductsUrl = '${baseUrl}api/Products';
const createProductWithVariantsUrl =
    '${baseUrl}api/Products/create-with-variants';

String getProductDetailsUrl(int id) => '${baseUrl}api/Products/$id/details';

const getCategoriesUrl = '${baseUrl}api/Categories';
const getBrandsUrl = '${baseUrl}api/Brands';

const getProductVariantsUrl = '${baseUrl}api/ProductVariants';

String increaseVariantStockUrl(int id) =>
    '${baseUrl}api/ProductVariants/$id/increase-stock';

String decreaseVariantStockUrl(int id) =>
    '${baseUrl}api/ProductVariants/$id/decrease-stock';
