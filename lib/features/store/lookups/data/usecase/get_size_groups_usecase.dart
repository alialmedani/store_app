import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/size_group_model.dart';
import '../repository/lookups_repository.dart';

class GetSizeGroupsParams extends BaseParams {
  final int categoryId;

  GetSizeGroupsParams({
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'CategoryId': categoryId,
    };
  }
}

class GetSizeGroupsUsecase
    extends UseCase<List<SizeGroupModel>, GetSizeGroupsParams> {
  final LookupsRepository repository;

  GetSizeGroupsUsecase(this.repository);

  @override
  Future<Result<List<SizeGroupModel>>> call({
    required GetSizeGroupsParams params,
  }) {
    return repository.getSizeGroupsRequest(params: params);
  }
}