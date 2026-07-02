import 'package:store/core/constant/enum/enum.dart';

import '../../../../core/params/base_params.dart';

class CreateCategoryParams extends BaseParams {
  String name;
  String description;
  SizeType sizeType;
  bool isActive;

  CreateCategoryParams({
    required this.name,
    required this.description,
    required this.sizeType,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'sizeType': sizeType.toInt(),
      'isActive': isActive,
    };
  }
}
