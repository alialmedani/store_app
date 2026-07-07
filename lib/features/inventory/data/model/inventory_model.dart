class InventoryModel {
  final String? id;
  final DateTime? creationTime;
  final String? creatorId;
  final DateTime? lastModificationTime;
  final String? lastModifierId;
  final bool? isDeleted;
  final String? deleterId;
  final DateTime? deletionTime;
  final String? categoryId;
  final String? categoryName;
  final String? productId;
  final String? productName;
  final String? productVariantId;
  final String? color;
  final String? size;
  final int? currentStockQuantity;
  final MovementTypeLookup? movementType;
  final int? quantityChange;
  final int? oldQuantity;
  final int? newQuantity;
  final SourceTypeLookup? sourceType;
  final String? referenceId;
  final String? note;

  InventoryModel({
    this.id,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.categoryId,
    this.categoryName,
    this.productId,
    this.productName,
    this.productVariantId,
    this.color,
    this.size,
    this.currentStockQuantity,
    this.movementType,
    this.quantityChange,
    this.oldQuantity,
    this.newQuantity,
    this.sourceType,
    this.referenceId,
    this.note,
  });

  /// From JSON - Parse API response
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    // Handle nested movementType object
    MovementTypeLookup? parsedMovementType;
    if (json['movementType'] != null && json['movementType'] is Map) {
      parsedMovementType = MovementTypeLookup.fromJson(json['movementType']);
    }

    // Handle nested sourceType object
    SourceTypeLookup? parsedSourceType;
    if (json['sourceType'] != null && json['sourceType'] is Map) {
      parsedSourceType = SourceTypeLookup.fromJson(json['sourceType']);
    }

    return InventoryModel(
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
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      productId: json['productId'],
      productName: json['productName'],
      productVariantId: json['productVariantId'],
      color: json['color'],
      size: json['size'],
      currentStockQuantity: json['currentStockQuantity'],
      movementType: parsedMovementType,
      quantityChange: json['quantityChange'],
      oldQuantity: json['oldQuantity'],
      newQuantity: json['newQuantity'],
      sourceType: parsedSourceType,
      referenceId: json['referenceId'],
      note: json['note'],
    );
  }

  /// To JSON - Send to API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (categoryId != null) 'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      if (productId != null) 'productId': productId,
      if (productName != null) 'productName': productName,
      if (productVariantId != null) 'productVariantId': productVariantId,
      if (color != null) 'color': color,
      if (size != null) 'size': size,
      if (currentStockQuantity != null)
        'currentStockQuantity': currentStockQuantity,
      if (movementType != null) 'movementType': movementType!.toJson(),
      if (quantityChange != null) 'quantityChange': quantityChange,
      if (oldQuantity != null) 'oldQuantity': oldQuantity,
      if (newQuantity != null) 'newQuantity': newQuantity,
      if (sourceType != null) 'sourceType': sourceType!.toJson(),
      if (referenceId != null) 'referenceId': referenceId,
      if (note != null) 'note': note,
    };
  }
}

/// Lookup model for movement type
class MovementTypeLookup {
  final int? id;
  final String? name;

  MovementTypeLookup({
    this.id,
    this.name,
  });

  factory MovementTypeLookup.fromJson(Map<String, dynamic> json) {
    return MovementTypeLookup(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    };
  }
}

/// Lookup model for source type
class SourceTypeLookup {
  final int? id;
  final String? name;

  SourceTypeLookup({
    this.id,
    this.name,
  });

  factory SourceTypeLookup.fromJson(Map<String, dynamic> json) {
    return SourceTypeLookup(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    };
  }
}
