import '../../../../core/constant/enum/enum.dart';
import '../../../category/data/model/category_model.dart';

class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final int? totalStockQuantity;
  final bool? isActive;
  final DateTime? creationTime;
  final String? creatorId;
  final DateTime? lastModificationTime;
  final String? lastModifierId;
  final bool? isDeleted;
  final String? deleterId;
  final DateTime? deletionTime;

  // Nested objects
  final AvailabilityStatusModel? availabilityStatus;
  final CategoryModel? category;
  final TargetAudienceModel? targetAudience;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.totalStockQuantity,
    this.isActive,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.availabilityStatus,
    this.category,
    this.targetAudience,
  });

  /// From JSON - Parse API response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      totalStockQuantity: json['totalStockQuantity'],
      isActive: json['isActive'],
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
      availabilityStatus: json['availabilityStatus'] != null
          ? AvailabilityStatusModel.fromJson(json['availabilityStatus'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      targetAudience: json['targetAudience'] != null
          ? TargetAudienceModel.fromJson(json['targetAudience'])
          : null,
    );
  }

  /// To JSON - Send to API (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

/// Availability Status nested model
class AvailabilityStatusModel {
  final int? id;
  final String? name;

  AvailabilityStatusModel({this.id, this.name});

  factory AvailabilityStatusModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityStatusModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, if (name != null) 'name': name};
  }
}

/// Target Audience nested model
class TargetAudienceModel {
  final int? id;
  final String? name;
  final TargetAudience? targetAudience;

  TargetAudienceModel({this.id, this.name, this.targetAudience});

  factory TargetAudienceModel.fromJson(Map<String, dynamic> json) {
    int? parsedId;
    String? parsedName;
    TargetAudience? parsedTargetAudience;

    if (json['id'] != null) {
      parsedId = json['id'];
      parsedTargetAudience = TargetAudience.fromInt(parsedId);
    }

    if (json['name'] != null) {
      parsedName = json['name'];
    }

    return TargetAudienceModel(
      id: parsedId,
      name: parsedName,
      targetAudience: parsedTargetAudience,
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, if (name != null) 'name': name};
  }
}
