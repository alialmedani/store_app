class ProductDetailsModel {
  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final String? imageUrl;

  final LookupModel? category;
  final LookupModel? brand;

  final int? totalVariantStock;
  final int? activeVariantCount;
  final String? availabilityStatus;

  final List<ProductColorModel>? colors;

  ProductDetailsModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.imageUrl,
    this.category,
    this.brand,
    this.totalVariantStock,
    this.activeVariantCount,
    this.availabilityStatus,
    this.colors,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      totalVariantStock: json['totalVariantStock'],
      activeVariantCount: json['activeVariantCount'],
      availabilityStatus: json['availabilityStatus'],

      category: json['category'] != null
          ? LookupModel.fromJson(json['category'])
          : null,

      brand: json['brand'] != null
          ? LookupModel.fromJson(json['brand'])
          : null,

      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => ProductColorModel.fromJson(e))
          .toList(),
    );
  }
}

class LookupModel {
  final int? id;
  final String? name;
  final String? description;

  LookupModel({
    this.id,
    this.name,
    this.description,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    return LookupModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class ProductColorModel {
  final String? color;
  final String? imageUrl;
  final int? totalStock;
  final List<ProductSizeModel>? sizes;

  ProductColorModel({
    this.color,
    this.imageUrl,
    this.totalStock,
    this.sizes,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) {
    return ProductColorModel(
      color: json['color'],
      imageUrl: json['imageUrl'],
      totalStock: json['totalStock'],
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => ProductSizeModel.fromJson(e))
          .toList(),
    );
  }
}

class ProductSizeModel {
  final int? productVariantId;
  final String? size;
  final int? quantity;
  final String? sku;
  final String? imageUrl;
  final bool? isActive;

  ProductSizeModel({
    this.productVariantId,
    this.size,
    this.quantity,
    this.sku,
    this.imageUrl,
    this.isActive,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      productVariantId: json['productVariantId'],
      size: json['size'],
      quantity: json['quantity'],
      sku: json['sku'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
    );
  }
}