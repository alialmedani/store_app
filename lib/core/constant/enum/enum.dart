enum SizeType {
  none,
  clothing,
  shoes,
  oneSize,
  kidsAge,
  custom;

  static SizeType? fromInt(int? value) {
    switch (value) {
      case 0:
        return SizeType.none;
      case 1:
        return SizeType.clothing;
      case 2:
        return SizeType.shoes;
      case 3:
        return SizeType.oneSize;
      case 4:
        return SizeType.kidsAge;
      case 5:
        return SizeType.custom;

      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case SizeType.none:
        return 0;
      case SizeType.clothing:
        return 1;
      case SizeType.shoes:
        return 2;
      case SizeType.oneSize:
        return 3;
      case SizeType.kidsAge:
        return 4;
      case SizeType.custom:
        return 5;
    }
  }
}

enum TargetAudience {
  all,
  men,
  women,
  kids;

  static TargetAudience? fromInt(int? value) {
    switch (value) {
      case 0:
        return TargetAudience.all;
      case 1:
        return TargetAudience.men;
      case 2:
        return TargetAudience.women;
      case 3:
        return TargetAudience.kids;

      default:
        return null;
    }
  }

  int toInt() {
    switch (this) {
      case TargetAudience.all:
        return 0;
      case TargetAudience.men:
        return 1;
      case TargetAudience.women:
        return 2;
      case TargetAudience.kids:
        return 3;
    }
  }

  String displayString() {
    switch (this) {
      case TargetAudience.all:
        return 'All';
      case TargetAudience.men:
        return 'Men';
      case TargetAudience.women:
        return 'Women';
      case TargetAudience.kids:
        return 'Kids';
    }
  }
}
