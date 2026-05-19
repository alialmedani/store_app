// import 'package:jedar_center/features/product/data/model/product.dart';
// import '../../../core/classes/cashe_helper.dart';

// double getProductPrice(ProductModel productModel) {
//   var productPrice = productModel.productPriceList;
//   var currencyCode = CacheHelper.setting?.currencyCode;

//   if (currencyCode == productPrice?.first.curr) {
//     return productPrice?.first.price?.toDouble() ?? 0.0;
//   } else if (currencyCode == productPrice?.first.curr1) {
//     return double.tryParse((productPrice?.first.addPrice1 ?? "0").toString()) ??
//         0.0;
//   } else if (currencyCode == productPrice?.first.curr2) {
//     return double.tryParse((productPrice?.first.addPrice2 ?? "0").toString()) ??
//         0.0;
//   }

//   return 0.0;
// }
