// import '../../../core/classes/cashe_helper.dart';
// import '../../../features/matrix/data/model/matrix.dart';

// double getMatrixPrice(MatrixModel matrixModel) {
//   if (matrixModel.products != null && matrixModel.products!.isNotEmpty) {
//     var productPrices = matrixModel.products![0].productPriceList;
//     var currencyCode = CacheHelper.setting?.currencyCode;

//     var priceId = CacheHelper.setting?.priceLists?.first.id;

//     if (productPrices != null && productPrices.isNotEmpty) {
//       for (var price in productPrices) {
//         if (priceId == price.priceList) {
//           if (price.unitId == matrixModel.products![0].sUoMEntry) {
//             if (currencyCode == price.curr) {
//               return price.price?.toDouble() ?? 0.0;
//             } else if (currencyCode == price.curr1) {
//               return double.tryParse((price.addPrice1 ?? "0").toString()) ??
//                   0.0;
//             } else if (currencyCode == price.curr2) {
//               return double.tryParse((price.addPrice2 ?? "0").toString()) ??
//                   0.0;
//             }
//           } else if (price.unitId == matrixModel.products![0].unitId) {
//             if (currencyCode == price.curr) {
//               return matrixModel.products![0].numInSale! *
//                   (price.price?.toDouble() ?? 0.0);
//             } else if (currencyCode == price.curr1) {
//               return matrixModel.products![0].numInSale! *
//                   (double.tryParse((price.addPrice1 ?? "0").toString()) ?? 0.0);
//             } else if (currencyCode == price.curr2) {
//               return matrixModel.products![0].numInSale! *
//                   (double.tryParse((price.addPrice2 ?? "0").toString()) ?? 0.0);
//             }
//           } 
//         }
//       }
//     }
//   }
//   return 0.0;
// }
