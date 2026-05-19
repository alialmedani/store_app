class SizeGroupModel {
  final int? id;
  final int? categoryId;
  final String? categoryName;
  final String? name;
  final String? description;
  final bool? isActive;
  final List<SizeOptionModel> sizeOptions;

  SizeGroupModel({
    this.id,
    this.categoryId,
    this.categoryName,
    this.name,
    this.description,
    this.isActive,
    this.sizeOptions = const [],
  });

  factory SizeGroupModel.fromJson(Map<String, dynamic> json) {
    return SizeGroupModel(
      id: json['id'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
      sizeOptions: (json['sizeOptions'] as List<dynamic>? ?? [])
          .map((e) => SizeOptionModel.fromJson(e))
          .toList(),
    );
  }
}

class SizeOptionModel {
  final int? id;
  final int? sizeGroupId;
  final String? name;
  final int? sortOrder;
  final bool? isActive;

  SizeOptionModel({
    this.id,
    this.sizeGroupId,
    this.name,
    this.sortOrder,
    this.isActive,
  });

  factory SizeOptionModel.fromJson(Map<String, dynamic> json) {
    return SizeOptionModel(
      id: json['id'],
      sizeGroupId: json['sizeGroupId'],
      name: json['name'],
      sortOrder: json['sortOrder'],
      isActive: json['isActive'],
    );
  }
}