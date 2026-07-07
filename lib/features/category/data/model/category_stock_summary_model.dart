import '../../../../features/product/data/model/product_model.dart';

class CategoryStockSummaryModel {
  final String? categoryId;
  final String? categoryName;
  final bool? isActive;
  final int? productCount;
  final int? activeProducts;
  final int? inactiveProducts;
  final int? variantCount;
  final int? activeVariants;
  final int? inactiveVariants;
  final int? totalStockQuantity;
  final int? lowStockThreshold;
  final AvailabilityStatusModel? availabilityStatus;
  final int? outOfStockProducts;
  final int? lowStockProducts;
  final int? inStockProducts;
  final int? outOfStockVariants;
  final int? lowStockVariants;
  final int? inStockVariants;

  CategoryStockSummaryModel({
    this.categoryId,
    this.categoryName,
    this.isActive,
    this.productCount,
    this.activeProducts,
    this.inactiveProducts,
    this.variantCount,
    this.activeVariants,
    this.inactiveVariants,
    this.totalStockQuantity,
    this.lowStockThreshold,
    this.availabilityStatus,
    this.outOfStockProducts,
    this.lowStockProducts,
    this.inStockProducts,
    this.outOfStockVariants,
    this.lowStockVariants,
    this.inStockVariants,
  });

  /// From JSON - Parse API response
  factory CategoryStockSummaryModel.fromJson(Map<String, dynamic> json) {
    return CategoryStockSummaryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      isActive: json['isActive'],
      productCount: json['productCount'],
      activeProducts: json['activeProducts'],
      inactiveProducts: json['inactiveProducts'],
      variantCount: json['variantCount'],
      activeVariants: json['activeVariants'],
      inactiveVariants: json['inactiveVariants'],
      totalStockQuantity: json['totalStockQuantity'],
      lowStockThreshold: json['lowStockThreshold'],
      availabilityStatus: json['availabilityStatus'] != null
          ? AvailabilityStatusModel.fromJson(json['availabilityStatus'])
          : null,
      outOfStockProducts: json['outOfStockProducts'],
      lowStockProducts: json['lowStockProducts'],
      inStockProducts: json['inStockProducts'],
      outOfStockVariants: json['outOfStockVariants'],
      lowStockVariants: json['lowStockVariants'],
      inStockVariants: json['inStockVariants'],
    );
  }
}
