import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/brand_model.dart';
import '../repository/brand_repository.dart';

class GetBrandsParams extends BaseParams {}

class GetBrandByIdParams extends BaseParams {
  final int id;

  GetBrandByIdParams({required this.id});
}

class CreateBrandParams extends BaseParams {
  String name;
  String? description;

  CreateBrandParams({required this.name, this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
    };
  }
}

class UpdateBrandParams extends BaseParams {
  int id;
  String name;
  String? description;

  UpdateBrandParams({
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

class BrandActionParams extends BaseParams {
  final int id;

  BrandActionParams({required this.id});
}

class GetBrandsUsecase extends UseCase<List<BrandModel>, GetBrandsParams> {
  final BrandRepository repository;

  GetBrandsUsecase(this.repository);

  @override
  Future<Result<List<BrandModel>>> call({required GetBrandsParams params}) {
    return repository.getBrandsRequest();
  }
}

class GetBrandByIdUsecase extends UseCase<BrandModel, GetBrandByIdParams> {
  final BrandRepository repository;

  GetBrandByIdUsecase(this.repository);

  @override
  Future<Result<BrandModel>> call({required GetBrandByIdParams params}) {
    return repository.getBrandByIdRequest(params: params);
  }
}

class CreateBrandUsecase extends UseCase<BrandModel, CreateBrandParams> {
  final BrandRepository repository;

  CreateBrandUsecase(this.repository);

  @override
  Future<Result<BrandModel>> call({required CreateBrandParams params}) {
    return repository.createBrandRequest(params: params);
  }
}

class UpdateBrandUsecase extends UseCase<BrandModel, UpdateBrandParams> {
  final BrandRepository repository;

  UpdateBrandUsecase(this.repository);

  @override
  Future<Result<BrandModel>> call({required UpdateBrandParams params}) {
    return repository.updateBrandRequest(params: params);
  }
}

class DeleteBrandUsecase extends UseCase<dynamic, BrandActionParams> {
  final BrandRepository repository;

  DeleteBrandUsecase(this.repository);

  @override
  Future<Result<dynamic>> call({required BrandActionParams params}) {
    return repository.deleteBrandRequest(params: params);
  }
}

class ActivateBrandUsecase extends UseCase<BrandModel, BrandActionParams> {
  final BrandRepository repository;

  ActivateBrandUsecase(this.repository);

  @override
  Future<Result<BrandModel>> call({required BrandActionParams params}) {
    return repository.activateBrandRequest(params: params);
  }
}

class DeactivateBrandUsecase extends UseCase<BrandModel, BrandActionParams> {
  final BrandRepository repository;

  DeactivateBrandUsecase(this.repository);

  @override
  Future<Result<BrandModel>> call({required BrandActionParams params}) {
    return repository.deactivateBrandRequest(params: params);
  }
}