/// Top/Bottom Sellers report response (`GET /api/app/report/top-sellers`).
class TopSellersModel {
  final List<TopSellerItem> items;

  TopSellersModel({this.items = const []});

  factory TopSellersModel.fromJson(Map<String, dynamic> json) {
    return TopSellersModel(
      items: (json['items'] as List? ?? const [])
          .map((e) => TopSellerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TopSellerItem {
  final String? productId;

  /// Null unless the report was grouped by variant.
  final String? productVariantId;
  final String? name;
  final String? color;
  final String? size;
  final int quantitySold;
  final double revenue;
  final bool isProductDeleted;
  final bool isVariantDeleted;

  TopSellerItem({
    this.productId,
    this.productVariantId,
    this.name,
    this.color,
    this.size,
    this.quantitySold = 0,
    this.revenue = 0,
    this.isProductDeleted = false,
    this.isVariantDeleted = false,
  });

  factory TopSellerItem.fromJson(Map<String, dynamic> json) {
    return TopSellerItem(
      productId: json['productId'],
      productVariantId: json['productVariantId'],
      name: json['name'],
      color: json['color'],
      size: json['size'],
      quantitySold: (json['quantitySold'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      isProductDeleted: json['isProductDeleted'] == true,
      isVariantDeleted: json['isVariantDeleted'] == true,
    );
  }
}
