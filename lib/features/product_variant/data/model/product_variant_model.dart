import '../../../product/data/model/product_model.dart';

class ProductVariantModel {
  final String? id;
  final DateTime? creationTime;
  final String? creatorId;
  final DateTime? lastModificationTime;
  final String? lastModifierId;
  final bool? isDeleted;
  final String? deleterId;
  final DateTime? deletionTime;
  final String? productId;
  final String? productName;
  final String? color;
  final String? size;
  final int? stockQuantity;
  final AvailabilityStatusModel? availabilityStatus;
  final bool? isActive;

  ProductVariantModel({
    this.id,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.productId,
    this.productName,
    this.color,
    this.size,
    this.stockQuantity,
    this.availabilityStatus,
    this.isActive,
  });

  /// From JSON - Parse API response
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      creationTime: json['creationTime'] != null
          ? DateTime.parse(json['creationTime'])
          : null,
      creatorId: json['creatorId'],
      lastModificationTime: json['lastModificationTime'] != null
          ? DateTime.parse(json['lastModificationTime'])
          : null,
      lastModifierId: json['lastModifierId'],
      isDeleted: json['isDeleted'],
      deleterId: json['deleterId'],
      deletionTime: json['deletionTime'] != null
          ? DateTime.parse(json['deletionTime'])
          : null,
      productId: json['productId'],
      productName: json['productName'],
      color: json['color'],
      size: json['size'],
      stockQuantity: json['stockQuantity'],
      availabilityStatus: json['availabilityStatus'] != null
          ? AvailabilityStatusModel.fromJson(json['availabilityStatus'])
          : null,
      isActive: json['isActive'],
    );
  }

  /// To JSON - Send to API (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (productId != null) 'productId': productId,
      if (color != null) 'color': color,
      if (size != null) 'size': size,
      if (stockQuantity != null) 'stockQuantity': stockQuantity,
      if (isActive != null) 'isActive': isActive,
    };
  }
}
