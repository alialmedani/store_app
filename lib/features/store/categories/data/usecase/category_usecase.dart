import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoriesParams extends BaseParams {}

class CreateCategoryParams extends BaseParams {
  String name;
  String? description;

  CreateCategoryParams({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
    };
  }
}

class GetCategoriesUsecase extends UseCase<List<CategoryModel>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategoriesUsecase(this.repository);

  @override
  Future<Result<List<CategoryModel>>> call({required GetCategoriesParams params}) {
    return repository.getCategoriesRequest();
  }
}

class CreateCategoryUsecase extends UseCase<CategoryModel, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({required CreateCategoryParams params}) {
    return repository.createCategoryRequest(params: params);
  }
}