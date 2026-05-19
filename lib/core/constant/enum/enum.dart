enum EntityType {
  drink,
  user,
  other;

  static EntityType? fromInt(int? value) {
    switch (value) {
      case 1:
        return EntityType.drink;
      case 2:
        return EntityType.user;
      case 3:
        return EntityType.other;

      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case EntityType.drink:
        return 1;
      case EntityType.user:
        return 2;
      case EntityType.other:
        return 3;
    }
  }
}

enum OrderStatus {
  draft,
  submitted,
  inPreparation,
  ready,
  delivered,
  canceled;

  static OrderStatus? fromInt(int? value) {
    switch (value) {
      case 0:
        return OrderStatus.draft;
      case 1:
        return OrderStatus.submitted;
      case 2:
        return OrderStatus.inPreparation;
      case 3:
        return OrderStatus.ready;
      case 4:
        return OrderStatus.delivered;
      case 5:
        return OrderStatus.canceled;

      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case OrderStatus.draft:
        return 0;
      case OrderStatus.submitted:
        return 1;
      case OrderStatus.inPreparation:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.canceled:
        return 5;
    }
  }
}

enum SugarLevel {
  none,
  light,
  medium,
  high;

  static SugarLevel? fromInt(int? value) {
    switch (value) {
      case 0:
        return SugarLevel.none;
      case 1:
        return SugarLevel.light;
      case 2:
        return SugarLevel.medium;
      case 3:
        return SugarLevel.high;

      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case SugarLevel.none:
        return 0;
      case SugarLevel.light:
        return 1;
      case SugarLevel.medium:
        return 2;
      case SugarLevel.high:
        return 3;
    }
  }
}

enum RoleType {
  user,
  officeBoy;

  static RoleType? fromString(String? value) {
    if (value == null) return null;
    final v = value.trim().toLowerCase().replaceAll(' ', '');
    switch (v) {
      case 'user':
        return RoleType.user;
      case 'officeboy':
        return RoleType.officeBoy;
      default:
        return null;
    }
  }

  String toApiString() {
    switch (this) {
      case RoleType.user:
        return 'User';
      case RoleType.officeBoy:
        return 'OfficeBoy';
    }
  }

  String displayString() {
    switch (this) {
      case RoleType.user:
        return 'User';
      case RoleType.officeBoy:
        return 'Office Boy';
    }
  }

  static List<RoleType> listFromApi(List<String>? apiRoles) {
    if (apiRoles == null) return [];
    return apiRoles.map(fromString).whereType<RoleType>().toList();
  }

  static List<String> listToApi(List<RoleType> roles) {
    return roles.map((e) => e.toApiString()).toList();
  }
}
