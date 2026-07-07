import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class UpdateCategoryParams extends BaseParams {
  String? id;
  String name;
  String description;
  int sizeType;
  String? imageUrl;
  bool isActive;

  UpdateCategoryParams({
    this.id,
    required this.name,
    required this.description,
    required this.sizeType,
    this.imageUrl,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name.isNotEmpty) 'name': name,
      if (description.isNotEmpty) 'description': description,
      'sizeType': sizeType,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}

class UpdateCategoryUsecase extends UseCase<CategoryModel, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required UpdateCategoryParams params,
  }) {
    return repository.updateCategoryRequest(params: params);
  }
}
