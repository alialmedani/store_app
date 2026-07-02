import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/current_user_model.dart';
import '../model/login_model.dart';
import '../model/register_model.dart';
import '../usecase/get_app_config_usecase.dart';
import '../usecase/login_usecase.dart';
import '../usecase/refresh_token_usecase.dart';
import '../usecase/register_usecase.dart';
import '../usecase/set_decive_id_usecase.dart';

class AuthRepository extends CoreRepository {
  Future<Result<LoginModel>> loginRequest({required LoginParams params}) async {
    final result = await RemoteDataSource.request<LoginModel>(
      contentType: 'application/x-www-form-urlencoded',
      withAuthentication: false,
      data: params.toJson(),
      url: loginUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return LoginModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<LoginModel>> refreshTokenRequest({
    required RefreshTokenParams params,
  }) async {
    final result = await RemoteDataSource.request<LoginModel>(
      contentType: 'application/x-www-form-urlencoded',
      withAuthentication: false,
      data: params.toJson(),
      url: loginUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return LoginModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<String>> setDeviceIdRequest({
    required SetDeviceIdParams params,
  }) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      data: params.toJson(),
      url: setDeviceIdUrl,
      method: HttpMethod.POST,
    );

    return call(result: result);
  }

  Future<Result<RegisterModel>> registerRequest({
    required RegisterParams params,
  }) async {
    final result = await RemoteDataSource.request<RegisterModel>(
      contentType: 'application/json',
      withAuthentication: false,
      data: params.toJson(),
      url: registerUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return RegisterModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  // Future<Result<RegisterDriverModel>> registerDriverRequest({
  //   required RegisterDriverParams params,
  // }) async {
  //   final result = await RemoteDataSource.request<RegisterDriverModel>(
  //     contentType: 'application/json',
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: registerDriverUrl,
  //     method: HttpMethod.POST,
  //     converter: (json) {
  //       return RegisterDriverModel.fromJson(json);
  //     },
  //   );

  //   return call(result: result);
  // }

  // Future<Result<RegisterMerchantModel>> registerMerchantRequest({
  //   required RegisterMerchantParams params,
  // }) async {
  //   final result = await RemoteDataSource.request<RegisterMerchantModel>(
  //     contentType: 'application/json',
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: registerMerchantUrl,
  //     method: HttpMethod.POST,
  //     converter: (json) {
  //       return RegisterMerchantModel.fromJson(json);
  //     },
  //   );

  //   return call(result: result);
  // }

  Future<Result<CurrentUserModel>> getAppConfigRequest({
    required GetAppConfigParams params,
  }) async {
    final result = await RemoteDataSource.request<CurrentUserModel>(
      withAuthentication: true,
      url: appConfigUrl,
      queryParameters: {'IncludeLocalizationResources': 'false'},
      method: HttpMethod.GET,
      converter: (json) {
        return CurrentUserModel.fromJson(json['currentUser']);
      },
    );

    return call(result: result);
  }

  // Future<Result<dynamic>> changePasswordRequest({
  //   required ChangePasswordParams params,
  // }) async {
  //   final result = await RemoteDataSource.noModelRequest(
  //     withAuthentication: true,
  //     data: params.toJson(),
  //     url: changePasswordUrl,
  //     method: HttpMethod.POST,
  //   );

  //   return call(result: result);
  // }

  // Future<Result<dynamic>> forceChangePasswordRequest({
  //   required ForceChangePasswordParams params,
  // }) async {
  //   final result = await RemoteDataSource.noModelRequest(
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: setPasswordUrl,
  //     method: HttpMethod.POST,
  //   );

  //   return call(result: result);
  // }

  // Future<Result<SendOtpModel>> sendOtp(SendOtpParams params) async {
  //   final result = await RemoteDataSource.request<SendOtpModel>(
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: sendOtpUrl,
  //     method: HttpMethod.POST,
  //     converter: (json) {
  //       return SendOtpModel.fromJson(json);
  //     },
  //   );

  //   return call(result: result);
  // }

  // Future<Result<VerifyOtpModel>> verifyOtp(VerifyOtpParams params) async {
  //   final result = await RemoteDataSource.request<VerifyOtpModel>(
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: verifyOtpUrl,
  //     method: HttpMethod.POST,
  //     converter: (json) {
  //       return VerifyOtpModel.fromJson(json);
  //     },
  //   );

  //   return call(result: result);
  // }

  // Future<Result<UserIdentityModel>> getUserByUsername(
  //   GetUserByUsernameParams params,
  // ) async {
  //   final result = await RemoteDataSource.request<UserIdentityModel>(
  //     withAuthentication: false,
  //     url: getUserByUsernameUrl,
  //     queryParameters: params.toJson(),
  //     method: HttpMethod.GET,
  //     converter: (json) {
  //       return UserIdentityModel.fromJson(json);
  //     },
  //   );

  //   return call(result: result);
  // }

  // Future<Result<String>> resetPassword(ResetPasswordParams params) async {
  //   final result = await RemoteDataSource.noModelRequest(
  //     withAuthentication: false,
  //     data: params.toJson(),
  //     url: getResetPasswordUrl(params.userId),
  //     method: HttpMethod.POST,
  //   );

  //   return call(result: result);
  // }
}
