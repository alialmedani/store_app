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