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

  /// ABP granted-permission policies, parsed from the application-configuration
  /// response at `auth.grantedPolicies` (map of policy name -> granted bool).
  /// Null means "unknown / not loaded" (the backend still enforces via 403).
  final Map<String, bool>? grantedPolicies;

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
    this.grantedPolicies,
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

  /// Builds the current user from the FULL `application-configuration` payload,
  /// capturing both `currentUser` and `auth.grantedPolicies`.
  factory CurrentUserModel.fromAppConfig(Map<String, dynamic> json) {
    final user = CurrentUserModel.fromJson(
      (json['currentUser'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
    Map<String, bool>? policies;
    final auth = json['auth'];
    if (auth is Map && auth['grantedPolicies'] is Map) {
      policies = (auth['grantedPolicies'] as Map).map(
        (key, value) => MapEntry(key.toString(), value == true),
      );
    }
    return user.copyWith(grantedPolicies: policies);
  }

  CurrentUserModel copyWith({Map<String, bool>? grantedPolicies}) {
    return CurrentUserModel(
      isAuthenticated: isAuthenticated,
      id: id,
      tenantId: tenantId,
      userName: userName,
      name: name,
      surName: surName,
      email: email,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      phoneNumberVerified: phoneNumberVerified,
      roles: roles,
      sessionId: sessionId,
      grantedPolicies: grantedPolicies ?? this.grantedPolicies,
    );
  }

  /// Whether the given ABP policy is granted. When permissions are unknown
  /// (not loaded), returns true and lets the backend enforce via 403.
  bool can(String policy) {
    if (grantedPolicies == null) return true;
    return grantedPolicies![policy] ?? false;
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
