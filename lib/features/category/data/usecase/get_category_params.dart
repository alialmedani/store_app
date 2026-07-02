import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../core/params/base_params.dart';

class GetCategoryParams extends BaseParams {
  final GetListRequest? request;
  final String? id;
  final bool? isActive;

  GetCategoryParams({
    this.request,
    this.id,
    this.isActive,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (isActive != null) 'isActive': isActive,
      if (request != null) ...{
        'skip': request!.skip,
        'take': request!.take,
      },
    };
  }
}
