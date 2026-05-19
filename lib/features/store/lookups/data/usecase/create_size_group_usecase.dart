import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/size_group_model.dart';
import '../repository/lookups_repository.dart';

class CreateSizeOptionParams {
  String name;
  int sortOrder;

  CreateSizeOptionParams({
    required this.name,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sortOrder': sortOrder,
    };
  }
}

class CreateSizeGroupParams extends BaseParams {
  int categoryId;
  String name;
  String? description;
  bool isActive;
  List<CreateSizeOptionParams> sizeOptions;

  CreateSizeGroupParams({
    required this.categoryId,
    required this.name,
    this.description,
    this.isActive = true,
    required this.sizeOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
      'isActive': isActive,
      'sizeOptions': sizeOptions.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateSizeGroupUsecase
    extends UseCase<SizeGroupModel, CreateSizeGroupParams> {
  final LookupsRepository repository;

  CreateSizeGroupUsecase(this.repository);

  @override
  Future<Result<SizeGroupModel>> call({
    required CreateSizeGroupParams params,
  }) {
    return repository.createSizeGroupRequest(params: params);
  }
}