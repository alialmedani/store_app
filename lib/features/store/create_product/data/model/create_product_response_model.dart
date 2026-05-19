class CreateProductResponseModel {
  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final String? imageUrl;
  final int? categoryId;
  final String? categoryName;
  final int? brandId;
  final String? brandName;
  final int? totalVariantStock;
  final int? activeVariantCount;
  final String? availabilityStatus;

  CreateProductResponseModel({
    this.id,
    this.name,
    this.price,
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

  factory CreateProductResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateProductResponseModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num?)?.toDouble(),
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