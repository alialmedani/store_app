import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CreateCategoryParams extends BaseParams {
  String name;
  String description;
  int sizeType;
  bool isActive;

  CreateCategoryParams({
    required this.name,
    required this.description,
    required this.sizeType,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'sizeType': sizeType,
      'isActive': isActive,
    };
  }
}

class CreateCategoryUsecase
    extends UseCase<CategoryModel, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({required CreateCategoryParams params}) {
    return repository.createCategoryRequest(params: params);
  }
}
