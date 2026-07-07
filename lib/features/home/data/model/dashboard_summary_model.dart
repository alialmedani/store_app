class DashboardSummaryModel {
  final int? totalProducts;
  final int? activeProducts;
  final int? inactiveProducts;
  final int? totalVariants;
  final int? activeVariants;
  final int? inactiveVariants;
  final double? totalInventoryValue;
  final int? lowStockThreshold;
  final int? lowStockProducts;
  final int? outOfStockProducts;
  final int? instockProducts;
  final int? instockVariants;

  DashboardSummaryModel({
    this.totalProducts,
    this.activeProducts,
    this.inactiveProducts,
    this.totalVariants,
    this.activeVariants,
    this.inactiveVariants,
    this.totalInventoryValue,
    this.lowStockThreshold,
    this.lowStockProducts,
    this.outOfStockProducts,
    this.instockProducts,
    this.instockVariants,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalProducts: json['totalProducts'],
      activeProducts: json['activeProducts'],
      inactiveProducts: json['inactiveProducts'],
      totalVariants: json['totalVariants'],
      activeVariants: json['activeVariants'],
      inactiveVariants: json['inactiveVariants'],
      totalInventoryValue: json['totalInventoryValue']?.toDouble(),
      lowStockThreshold: json['lowStockThreshold'],
      lowStockProducts: json['lowStockProducts'],
      outOfStockProducts: json['outOfStockProducts'],
      instockProducts: json['instockProducts'],
      instockVariants: json['instockVariants'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProducts': totalProducts,
      'activeProducts': activeProducts,
      'inactiveProducts': inactiveProducts,
      'totalVariants': totalVariants,
      'activeVariants': activeVariants,
      'inactiveVariants': inactiveVariants,
      'totalInventoryValue': totalInventoryValue,
      'lowStockThreshold': lowStockThreshold,
      'lowStockProducts': lowStockProducts,
      'outOfStockProducts': outOfStockProducts,
      'instockProducts': instockProducts,
      'instockVariants': instockVariants,
    };
  }
}
