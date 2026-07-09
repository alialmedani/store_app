class TenantModel {
  String? name;
  String? concurrencyStamp;
  String? id;

  TenantModel({this.name, this.concurrencyStamp, this.id});

  TenantModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    concurrencyStamp = json['concurrencyStamp'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['concurrencyStamp'] = concurrencyStamp;
    data['id'] = id;
    return data;
  }
}
