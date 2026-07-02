// import 'package:noon_express/features/Express/auth/data/repository/auth_repository.dart';

import '../../../../../core/params/base_params.dart';

class SetDeviceIdParams extends BaseParams {
  String deviceId;
  SetDeviceIdParams({required this.deviceId});
  Map<String, String> toJson() {
    return {"deviceId": deviceId};
  }
}

// class SetDeviceIdUsecase extends UseCase<String, SetDeviceIdParams> {
//   late final AuthRepository repository;
//   SetDeviceIdUsecase(this.repository);

//   @override
//   Future<Result<String>> call({required SetDeviceIdParams params}) {
//     return repository.setDeviceIdRequest(params: params);
//   }
// }
