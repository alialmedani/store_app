import 'package:store/core/constant/enum/enum.dart';

class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final SizeType? sizeType;
  final String? sizeTypeName;
  final int? sizeTypeId;
  final bool? isActive;
  final DateTime? creationTime;
  final String? creatorId;
  final DateTime? lastModificationTime;
  final String? lastModifierId;
  final bool? isDeleted;
  final String? deleterId;
  final DateTime? deletionTime;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.sizeType,
    this.sizeTypeName,
    this.sizeTypeId,
    this.isActive,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
  });

  /// From JSON - Parse API response
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Handle nested sizeType object from API response
    SizeType? parsedSizeType;
    String? parsedSizeTypeName;
    int? parsedSizeTypeId;

    if (json['sizeType'] != null) {
      if (json['sizeType'] is Map) {
        // Response format: {"id": 0, "name": "string"}
        parsedSizeTypeId = json['sizeType']['id'];
        parsedSizeTypeName = json['sizeType']['name'];
        parsedSizeType = SizeType.fromInt(parsedSizeTypeId);
      } else if (json['sizeType'] is int) {
        // Direct integer format
        parsedSizeTypeId = json['sizeType'];
        parsedSizeType = SizeType.fromInt(parsedSizeTypeId);
      }
    }

    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sizeType: parsedSizeType,
      sizeTypeName: parsedSizeTypeName,
      sizeTypeId: parsedSizeTypeId,
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
    );
  }

  /// To JSON - Send to API (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sizeType != null) 'sizeType': sizeType!.toInt(),
      if (isActive != null) 'isActive': isActive,
    };
  }

  /// Copy with method for creating modified copies
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    SizeType? sizeType,
    String? sizeTypeName,
    int? sizeTypeId,
    bool? isActive,
    DateTime? creationTime,
    String? creatorId,
    DateTime? lastModificationTime,
    String? lastModifierId,
    bool? isDeleted,
    String? deleterId,
    DateTime? deletionTime,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sizeType: sizeType ?? this.sizeType,
      sizeTypeName: sizeTypeName ?? this.sizeTypeName,
      sizeTypeId: sizeTypeId ?? this.sizeTypeId,
      isActive: isActive ?? this.isActive,
      creationTime: creationTime ?? this.creationTime,
      creatorId: creatorId ?? this.creatorId,
      lastModificationTime: lastModificationTime ?? this.lastModificationTime,
      lastModifierId: lastModifierId ?? this.lastModifierId,
      isDeleted: isDeleted ?? this.isDeleted,
      deleterId: deleterId ?? this.deleterId,
      deletionTime: deletionTime ?? this.deletionTime,
    );
  }
}
