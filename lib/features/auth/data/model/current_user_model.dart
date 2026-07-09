class CurrentUserModel {
  final bool? isAuthenticated;
  final String? id;
  final String? tenantId;
  final String? userName;
  final String? name;
  final String? surName;
  final String? email;
  final bool? emailVerified;
  final String? phoneNumber;
  final bool? phoneNumberVerified;
  final List<String>? roles;
  final String? sessionId;

  CurrentUserModel({
    this.isAuthenticated,
    this.id,
    this.tenantId,
    this.userName,
    this.name,
    this.surName,
    this.email,
    this.emailVerified,
    this.phoneNumber,
    this.phoneNumberVerified,
    this.roles,
    this.sessionId,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      isAuthenticated: json['isAuthenticated'] as bool?,
      id: json['id'] as String?,
      tenantId: json['tenantId'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      surName: json['surName'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneNumber: json['phoneNumber'] as String?,
      phoneNumberVerified: json['phoneNumberVerified'] as bool?,
      roles: json['roles'] != null
          ? List<String>.from(json['roles'] as List)
          : null,
      sessionId: json['sessionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAuthenticated': isAuthenticated,
      'id': id,
      'tenantId': tenantId,
      'userName': userName,
      'name': name,
      'surName': surName,
      'email': email,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'phoneNumberVerified': phoneNumberVerified,
      'roles': roles,
      'sessionId': sessionId,
    };
  }

  bool get isMerchant => roles?.contains('Merchant') ?? false;
  bool get isDriver => roles?.contains('Driver') ?? false;
  bool get isDelivery => roles?.contains('Delivery') ?? false;
  bool get isEmployee =>
      roles!.contains('Employee') ||
      roles!.contains('admin') ||
      roles!.contains('Office');
}
