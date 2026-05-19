import 'package:store/features/store/lookups/data/model/size_group_model.dart';
import 'package:store/features/store/lookups/data/usecase/get_size_groups_usecase.dart';

import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/lookup_model.dart';

const String baseUrl = 'http://10.200.0.112:7151';

class LookupsRepository extends CoreRepository {
  Future<Result<List<LookupModel>>> getCategoriesRequest() async {
    final result = await RemoteDataSource.request<List<LookupModel>>(
      withAuthentication: false,
      url: '$baseUrl/api/Categories',
      method: HttpMethod.GET,
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((item) => LookupModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<List<LookupModel>>> getBrandsRequest() async {
    final result = await RemoteDataSource.request<List<LookupModel>>(
      withAuthentication: false,
      url: '$baseUrl/api/Brands',
      method: HttpMethod.GET,
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((item) => LookupModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<List<SizeGroupModel>>> getSizeGroupsRequest({
    required GetSizeGroupsParams params,
  }) async {
    final result = await RemoteDataSource.request<List<SizeGroupModel>>(
      withAuthentication: false,
      url: '$baseUrl/api/SizeGroups',
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) {
        final List<dynamic> data = json['items'] ?? [];
        return data.map((item) => SizeGroupModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }
}
