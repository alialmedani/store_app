/// Inventory Status report response (`GET /api/app/report/inventory-status`).
/// Full snapshot (not paged). Always excludes soft-deleted variants.
class InventoryStatusModel {
  final List<InventoryStatusItem> items;
  final double totalStockValue;
  final int totalUnits;
  final int variantCount;
  final int outOfStockCount;
  final int lowStockCount;

  InventoryStatusModel({
    this.items = const [],
    this.totalStockValue = 0,
    this.totalUnits = 0,
    this.variantCount = 0,
    this.outOfStockCount = 0,
    this.lowStockCount = 0,
  });

  factory InventoryStatusModel.fromJson(Map<String, dynamic> json) {
    return InventoryStatusModel(
      items: (json['items'] as List? ?? const [])
          .map((e) =>
              InventoryStatusItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalStockValue: (json['totalStockValue'] as num?)?.toDouble() ?? 0,
      totalUnits: (json['totalUnits'] as num?)?.toInt() ?? 0,
      variantCount: (json['variantCount'] as num?)?.toInt() ?? 0,
      outOfStockCount: (json['outOfStockCount'] as num?)?.toInt() ?? 0,
      lowStockCount: (json['lowStockCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class InventoryStatusItem {
  final String? productVariantId;
  final String? productId;
  final String? productName;
  final String? categoryId;
  final String? categoryName;
  final String? color;
  final String? size;
  final int stockQuantity;
  final double price;
  final double stockValue;

  /// Nullable. Only meaningful when non-null; never treat a missing cost as 0.
  final double? costPrice;
  final bool isOutOfStock;
  final bool isLowStock;

  InventoryStatusItem({
    this.productVariantId,
    this.productId,
    this.productName,
    this.categoryId,
    this.categoryName,
    this.color,
    this.size,
    this.stockQuantity = 0,
    this.price = 0,
    this.stockValue = 0,
    this.costPrice,
    this.isOutOfStock = false,
    this.isLowStock = false,
  });

  factory InventoryStatusItem.fromJson(Map<String, dynamic> json) {
    return InventoryStatusItem(
      productVariantId: json['productVariantId'],
      productId: json['productId'],
      productName: json['productName'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      color: json['color'],
      size: json['size'],
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      stockValue: (json['stockValue'] as num?)?.toDouble() ?? 0,
      costPrice: (json['costPrice'] as num?)?.toDouble(),
      isOutOfStock: json['isOutOfStock'] == true,
      isLowStock: json['isLowStock'] == true,
    );
  }
}
