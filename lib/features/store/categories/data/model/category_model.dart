class CategoryModel {
  final int? id;
  final String? name;
  final String? description;
  final bool? isActive;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}