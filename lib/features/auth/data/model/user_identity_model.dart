class UserIdentityModel {
  String? tenantId;
  String? userName;
  String? name;
  String? surname;
  String? email;
  bool? emailConfirmed;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  bool? isActive;
  bool? lockoutEnabled;
  int? accessFailedCount;
  String? lockoutEnd;
  String? concurrencyStamp;
  int? entityVersion;
  String? lastPasswordChangeTime;
  bool? isDeleted;
  String? deleterId;
  String? deletionTime;
  String? lastModificationTime;
  String? lastModifierId;
  String? creationTime;
  String? creatorId;
  String? id;
  Map<String, dynamic>? extraProperties;

  UserIdentityModel({
    this.tenantId,
    this.userName,
    this.name,
    this.surname,
    this.email,
    this.emailConfirmed,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.isActive,
    this.lockoutEnabled,
    this.accessFailedCount,
    this.lockoutEnd,
    this.concurrencyStamp,
    this.entityVersion,
    this.lastPasswordChangeTime,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.lastModificationTime,
    this.lastModifierId,
    this.creationTime,
    this.creatorId,
    this.id,
    this.extraProperties,
  });

  factory UserIdentityModel.fromJson(Map<String, dynamic> json) {
    return UserIdentityModel(
      tenantId: json['tenantId'],
      userName: json['userName'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      isActive: json['isActive'],
      lockoutEnabled: json['lockoutEnabled'],
      accessFailedCount: json['accessFailedCount'],
      lockoutEnd: json['lockoutEnd'],
      concurrencyStamp: json['concurrencyStamp'],
      entityVersion: json['entityVersion'],
      lastPasswordChangeTime: json['lastPasswordChangeTime'],
      isDeleted: json['isDeleted'],
      deleterId: json['deleterId'],
      deletionTime: json['deletionTime'],
      lastModificationTime: json['lastModificationTime'],
      lastModifierId: json['lastModifierId'],
      creationTime: json['creationTime'],
      creatorId: json['creatorId'],
      id: json['id'],
      extraProperties: json['extraProperties'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'userName': userName,
      'name': name,
      'surname': surname,
      'email': email,
      'emailConfirmed': emailConfirmed,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'isActive': isActive,
      'lockoutEnabled': lockoutEnabled,
      'accessFailedCount': accessFailedCount,
      'lockoutEnd': lockoutEnd,
      'concurrencyStamp': concurrencyStamp,
      'entityVersion': entityVersion,
      'lastPasswordChangeTime': lastPasswordChangeTime,
      'isDeleted': isDeleted,
      'deleterId': deleterId,
      'deletionTime': deletionTime,
      'lastModificationTime': lastModificationTime,
      'lastModifierId': lastModifierId,
      'creationTime': creationTime,
      'creatorId': creatorId,
      'id': id,
      'extraProperties': extraProperties,
    };
  }
}
