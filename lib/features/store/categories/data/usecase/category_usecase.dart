import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoriesParams extends BaseParams {}

class GetCategoryByIdParams extends BaseParams {
  final int id;

  GetCategoryByIdParams({required this.id});
}

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

class UpdateCategoryParams extends BaseParams {
  int id;
  String name;
  String? description;

  UpdateCategoryParams({
    required this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
    };
  }
}

class CategoryActionParams extends BaseParams {
  final int id;

  CategoryActionParams({required this.id});
}

class GetCategoriesUsecase
    extends UseCase<List<CategoryModel>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategoriesUsecase(this.repository);

  @override
  Future<Result<List<CategoryModel>>> call({
    required GetCategoriesParams params,
  }) {
    return repository.getCategoriesRequest();
  }
}

class GetCategoryByIdUsecase
    extends UseCase<CategoryModel, GetCategoryByIdParams> {
  final CategoryRepository repository;

  GetCategoryByIdUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required GetCategoryByIdParams params,
  }) {
    return repository.getCategoryByIdRequest(params: params);
  }
}

class CreateCategoryUsecase
    extends UseCase<CategoryModel, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required CreateCategoryParams params,
  }) {
    return repository.createCategoryRequest(params: params);
  }
}

class UpdateCategoryUsecase
    extends UseCase<CategoryModel, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required UpdateCategoryParams params,
  }) {
    return repository.updateCategoryRequest(params: params);
  }
}

class DeleteCategoryUsecase extends UseCase<dynamic, CategoryActionParams> {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  @override
  Future<Result<dynamic>> call({
    required CategoryActionParams params,
  }) {
    return repository.deleteCategoryRequest(params: params);
  }
}

class ActivateCategoryUsecase
    extends UseCase<CategoryModel, CategoryActionParams> {
  final CategoryRepository repository;

  ActivateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required CategoryActionParams params,
  }) {
    return repository.activateCategoryRequest(params: params);
  }
}

class DeactivateCategoryUsecase
    extends UseCase<CategoryModel, CategoryActionParams> {
  final CategoryRepository repository;

  DeactivateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required CategoryActionParams params,
  }) {
    return repository.deactivateCategoryRequest(params: params);
  }
}