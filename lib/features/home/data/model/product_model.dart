class ProductModel {
  final int? id;
  final String? name;
  final int? quantity;
  final double? price;
  final bool? isActive;
  final String? description;
  final String? imageUrl;
  final int? categoryId;
  final String? categoryName;
  final int? brandId;
  final String? brandName;
  final int? totalVariantStock;
  final int? activeVariantCount;
  final String? availabilityStatus;

  ProductModel({
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.isActive,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.totalVariantStock,
    this.activeVariantCount,
    this.availabilityStatus,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num?)?.toDouble(),
      isActive: json['isActive'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      totalVariantStock: json['totalVariantStock'],
      activeVariantCount: json['activeVariantCount'],
      availabilityStatus: json['availabilityStatus'],
    );
  }
}