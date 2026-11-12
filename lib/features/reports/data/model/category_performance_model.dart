/// Category Performance report response
/// (`GET /api/app/report/category-performance`). Items are pre-sorted by
/// revenue descending by the backend.
class CategoryPerformanceModel {
  final List<CategoryPerformanceItem> items;
  final double totalRevenue;
  final int totalUnitsSold;

  CategoryPerformanceModel({
    this.items = const [],
    this.totalRevenue = 0,
    this.totalUnitsSold = 0,
  });

  factory CategoryPerformanceModel.fromJson(Map<String, dynamic> json) {
    return CategoryPerformanceModel(
      items: (json['items'] as List? ?? const [])
          .map((e) =>
              CategoryPerformanceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      totalUnitsSold: (json['totalUnitsSold'] as num?)?.toInt() ?? 0,
    );
  }
}

class CategoryPerformanceItem {
  final String? categoryId;
  final String? categoryName;
  final double revenue;
  final int unitsSold;
  final int orderCount;
  final bool isCategoryDeleted;

  CategoryPerformanceItem({
    this.categoryId,
    this.categoryName,
    this.revenue = 0,
    this.unitsSold = 0,
    this.orderCount = 0,
    this.isCategoryDeleted = false,
  });

  factory CategoryPerformanceItem.fromJson(Map<String, dynamic> json) {
    return CategoryPerformanceItem(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      unitsSold: (json['unitsSold'] as num?)?.toInt() ?? 0,
      orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
      isCategoryDeleted: json['isCategoryDeleted'] == true,
    );
  }
}
