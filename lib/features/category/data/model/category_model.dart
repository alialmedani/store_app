import 'package:store/core/constant/enum/enum.dart';


class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final SizeType? sizeType;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.sizeType,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// From JSON - Parse API response
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sizeType: json['sizeType'] != null 
          ? SizeType.fromInt(json['sizeType'])
          : null,
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// To JSON - Send to API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sizeType != null) 'sizeType': sizeType!.toInt(),
      if (isActive != null) 'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Copy with method for creating modified copies
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    SizeType? sizeType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sizeType: sizeType ?? this.sizeType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
