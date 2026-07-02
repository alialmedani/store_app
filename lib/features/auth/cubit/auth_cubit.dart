import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/results/result.dart';
import '../../../../core/classes/cashe_helper.dart';

import '../data/model/current_user_model.dart';
import '../data/repository/auth_repository.dart';
import '../data/usecase/change_password_usecase.dart';
import '../data/usecase/force_change_password_usecase.dart';
import '../data/usecase/get_app_config_usecase.dart';
import '../data/usecase/get_user_by_username_usecase.dart';
import '../data/usecase/login_usecase.dart';
import '../data/usecase/register_usecase.dart';
import '../data/usecase/register_driver_usecase.dart';
import '../data/usecase/register_merchant_usecase.dart';
import '../data/usecase/reset_password_usecase.dart';
import '../data/usecase/send_otp_usecase.dart';
import '../data/usecase/verify_otp_usecase.dart';
import '../data/usecase/set_decive_id_usecase.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isLoginButtonEnabled = false;
  bool isVerificationButtonEnabled = false;
  bool canResend = false;
  int remainingSeconds = 60;
  Timer? _timer;
  bool isObscure = true;

 LoginParams loginParams = LoginParams(
    username: 'admin',                           // ✅ اسم المستخدم الصحيح
    password: '1q2w3E*',                         // ✅ كلمة المرور الافتراضية
    grantType: 'password',                       // ✅ صح
    clientId: 'StoreManagement_Mobile',          // ✅ الـ Client ID الصحيح
    scope: 'openid profile email phone address roles offline_access StoreManagement',  // ✅ كامل
);

  RegisterParams registerParams = RegisterParams(
    userName: '',
    emailAddress: '',
    password: '',
    appName: 'StoreManagement',
  );

  RegisterDriverParams registerDriverParams = RegisterDriverParams(
    username: '',
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    firstNameAr: '',
    lastNameAr: '',
    phone: '',
    nationalId: '',
    licenseNumber: '',
    licenseExpiryDate: '',
    vehicleType: '',
    vehiclePlate: '',
    type: 2,
  );

  RegisterMerchantParams registerMerchantParams = RegisterMerchantParams(
    username: '',
    email: '',
    password: '',
    businessName: '',
    businessNameAr: '',
    phone: '',
    commercialRegistrationNumber: '',
    taxNumber: '',
    codFeePercentage: 0.0,
    creditLimit: 0.0,
    hasPhysicalShop: false,
    cityId: '',
    provinceId: '',
    description: '',
    latitude: null,
    longitude: null,
  );

  SetDeviceIdParams setDeviceIdParams = SetDeviceIdParams(deviceId: "");

  // RegisterUserDeviceParams registerUserDeviceParams = RegisterUserDeviceParams(
  //   deviceToken: '',
  //   platform: '',
  //   deviceModel: '',
  //   appVersion: '',
  //   osVersion: '',
  // );

  ChangePasswordParams changePasswordParams = ChangePasswordParams(
    currentPassword: '',
    newPassword: '',
  );

  ForceChangePasswordParams forceChangePasswordParams =
      ForceChangePasswordParams(
        userId: '',
        currentPassword: '',
        newPassword: '',
      );

  SendOtpParams sendOtpParams = SendOtpParams(phone: '');

  VerifyOtpParams verifyOtpParams = VerifyOtpParams(phone: '', code: '');

  GetUserByUsernameParams getUserByUsernameParams = GetUserByUsernameParams(
    userName: '',
  );

  ResetPasswordParams resetPasswordParams = ResetPasswordParams(
    userId: '',
    newPassword: '',
  );

  CurrentUserModel? currentUser;
  String? driverId;
  String? merchantId;

  /// The logged-in merchant's business name (set at splash from the merchant
  /// profile). Used to greet the merchant on the dashboard.
  String? merchantBusinessName;
  String? merchantBusinessNameAr;

  /// Locale-aware merchant display name: Arabic name when the app is in Arabic
  /// and it exists, otherwise the default business name.
  String? merchantDisplayName(bool isArabic) {
    final ar = merchantBusinessNameAr?.trim();
    final en = merchantBusinessName?.trim();
    if (isArabic && ar != null && ar.isNotEmpty) return ar;
    if (en != null && en.isNotEmpty) return en;
    return (ar != null && ar.isNotEmpty) ? ar : null;
  }

  Future<Result> login() async {
    return await LoginUsecase(AuthRepository()).call(params: loginParams);
  }

  Future<Result> register() async {
    return await RegisterUsecase(AuthRepository()).call(params: registerParams);
  }

  Future<Result<CurrentUserModel>> getAppConfig() async {
    return await GetAppConfigUsecase(
      AuthRepository(),
    ).call(params: GetAppConfigParams());
  }

  // Future<Result> registerMerchant() async {
  //   return await RegisterMerchantUsecase(
  //     AuthRepository(),
  //   ).call(params: registerMerchantParams);
  // }

  // Future<Result<SendOtpModel>> sendOtp() async {
  //   return await SendOtpUsecase(AuthRepository()).call(params: sendOtpParams);
  // }

  // Future<Result<VerifyOtpModel>> verifyOtp() async {
  //   return await VerifyOtpUsecase(
  //     AuthRepository(),
  //   ).call(params: verifyOtpParams);
  // }

  // Future<Result> registerDriver() async {
  //   return await RegisterDriverUsecase(
  //     AuthRepository(),
  //   ).call(params: registerDriverParams);
  // }

  void changeObscurePassword() {
    isObscure = !isObscure;
    emit(UpdateObscureState());
  }

  void updateRegisterDriverType(int type) {
    registerDriverParams.type = type;
    emit(UpdateRegisterDriverParams());
  }

  void updateRegisterDriverLicenseExpiryDate(String date) {
    registerDriverParams.licenseExpiryDate = date;
    emit(UpdateRegisterDriverParams());
  }

  void updateMerchantProvince(String provinceId) {
    registerMerchantParams.provinceId = provinceId;
    emit(UpdateRegisterMerchantParams());
  }

  void updateMerchantDistrict(String districtId) {
    registerMerchantParams.cityId = districtId;
    emit(UpdateRegisterMerchantParams());
  }

  void updateMerchantLocation(double latitude, double longitude) {
    registerMerchantParams.latitude = latitude;
    registerMerchantParams.longitude = longitude;
    emit(UpdateRegisterMerchantParams());
  }

  void toggleVerificationButton(String value) {
    final shouldEnable =
        value.trim().length == 6 && RegExp(r'^\d{6}$').hasMatch(value.trim());
    if (isVerificationButtonEnabled != shouldEnable) {
      isVerificationButtonEnabled = shouldEnable;
      emit(AuthVerificationButtonStateChanged(shouldEnable));
    }
  }

  void startTimer() {
    canResend = false;
    remainingSeconds = 60;
    _timer?.cancel();
    emit(AuthTimerTick(remainingSeconds, canResend));

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      remainingSeconds--;
      if (remainingSeconds <= 0) {
        timer.cancel();
        canResend = true;
        emit(AuthTimerTick(0, canResend));
      } else {
        emit(AuthTimerTick(remainingSeconds, canResend));
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  /// Logout user and clear authentication data
  Future<void> logout() async {
    // Clear current user data
    currentUser = null;
    
    // Clear all auth data from cache
    await CacheHelper.clearAuth();
  }

  // Future<Result> setDeviceId() async {
  //   return SetDeviceIdUsecase(AuthRepository()).call(params: setDeviceIdParams);
  // }

  // Future<void> logout() async {
  //   // Capture the token before clearing local state so we can release it below.
  //   final deviceToken = CacheHelper.getDeviceToken;

  //   // Clear in-memory auth + realtime immediately (preserves instant logout UX).
  //   currentUser = null;
  //   driverId = null;
  //   merchantId = null;
  //   merchantBusinessName = null;
  //   merchantBusinessNameAr = null;
  //   RealtimeService.instance.disconnect();

  //   // Best-effort: release this user's push token so notifications for this user
  //   // stop firing on this device and can't leak to the next user who logs in here.
  //   // Never block logout on token cleanup.
  //   try {
  //     if (deviceToken != null && deviceToken.isNotEmpty) {
  //       await UserDeviceRepository()
  //           .unregisterUserDeviceRequest(deviceToken: deviceToken);
  //     }
  //     // Drop the FCM token so the next user on this device mints a fresh one.
  //     await FirebaseMessaging.instance.deleteToken();
  //     await CacheHelper.setDeviceToken('');
  //   } catch (_) {
  //     // ignore — token cleanup must never prevent logout
  //   }
  // }

  /// Automatically fetches device information and registers the device
  // Future<Result> registerUserDevice(String firebaseToken) async {
  //   try {
  //     // Get package info for app version
  //     final packageInfo = await PackageInfo.fromPlatform();

  //     // Determine platform and OS version
  //     String platform = '';
  //     String osVersion = '';
  //     String deviceModel = '';

  //     if (kIsWeb) {
  //       platform = 'Web';
  //       osVersion = 'Web';
  //       deviceModel = 'Web Browser';
  //     } else if (Platform.isAndroid) {
  //       platform = 'Android';
  //       // In a real app, you'd use device_info_plus to get actual device info
  //       osVersion = 'Android';
  //       deviceModel = 'Android Device';
  //     } else if (Platform.isIOS) {
  //       platform = 'iOS';
  //       osVersion = 'iOS';
  //       deviceModel = 'iOS Device';
  //     } else if (Platform.isWindows) {
  //       platform = 'Windows';
  //       osVersion = 'Windows';
  //       deviceModel = 'Windows Device';
  //     } else if (Platform.isMacOS) {
  //       platform = 'MacOS';
  //       osVersion = 'MacOS';
  //       deviceModel = 'Mac Device';
  //     } else if (Platform.isLinux) {
  //       platform = 'Linux';
  //       osVersion = 'Linux';
  //       deviceModel = 'Linux Device';
  //     }

  //     // Update params with fetched data
  //     registerUserDeviceParams.deviceToken = firebaseToken;
  //     registerUserDeviceParams.platform = platform;
  //     registerUserDeviceParams.deviceModel = deviceModel;
  //     registerUserDeviceParams.appVersion = packageInfo.version;
  //     registerUserDeviceParams.osVersion = osVersion;

  //     // Call the register device API
  //     return await RegisterUserDeviceUsecase(
  //       UserDeviceRepository(),
  //     ).call(params: registerUserDeviceParams);
  //   } catch (e) {
  //     return Result(error: 'Failed to register device: $e');
  //   }
  // }

  // Future<Result> changePassword() async {
  //   return await ChangePasswordUsecase(
  //     AuthRepository(),
  //   ).call(params: changePasswordParams);
  // }

  // Future<Result> forceChangePassword() async {
  //   return await ForceChangePasswordUsecase(
  //     AuthRepository(),
  //   ).call(params: forceChangePasswordParams);
  // }

  // Future<Result<DriverProfileModel>> getDriverProfile() async {
  //   return await GetDriverProfileUsecase(
  //     DriverOrderRepository(),
  //   ).call(params: GetDriverProfileParams());
  // }

  // Future<void> saveCurrentSession() async {
  //   final token = CacheHelper.token;
  //   final refreshToken = CacheHelper.refreshtoken;
  //   final user = currentUser;
  //   if (token != null && user != null) {
  //     final accounts = CacheHelper.getAccountsList()
  //         .map((e) => StoredAccount.fromJson(e))
  //         .toList();

  //     // Remove existing entry for this user if it exists to update it
  //     accounts.removeWhere((a) => a.user.id == user.id);

  //     accounts.add(
  //       StoredAccount(
  //         user: user,
  //         token: token,
  //         refreshToken: refreshToken,
  //         lastActive: DateTime.now(),
  //       ),
  //     );

  //     await CacheHelper.saveAccountsList(
  //       accounts.map((e) => e.toJson()).toList(),
  //     );
  //   }
  // }

  // Future<void> switchAccount(StoredAccount account) async {
  //   // 1. Save current session before switching
  //   await saveCurrentSession();

  //   // 2. Set new active session
  //   await CacheHelper.setToken(account.token);
  //   await CacheHelper.setRefreshToken(account.refreshToken);
  //   await CacheHelper.setUserId(account.user.id);

  //   // 3. Update local state
  //   currentUser = account.user;

  //   // 4. Update the 'last active' time for the account we just switched TO in the list
  //   final accounts = CacheHelper.getAccountsList()
  //       .map((e) => StoredAccount.fromJson(e))
  //       .toList();
  //   accounts.removeWhere((a) => a.user.id == account.user.id);
  //   accounts.add(
  //     StoredAccount(
  //       user: account.user,
  //       token: account.token,
  //       refreshToken: account.refreshToken,
  //       lastActive: DateTime.now(),
  //     ),
  //   );
  //   await CacheHelper.saveAccountsList(
  //     accounts.map((e) => e.toJson()).toList(),
  //   );
  // }

  // Future<void> removeAccount(String userId) async {
  //   final accounts = CacheHelper.getAccountsList()
  //       .map((e) => StoredAccount.fromJson(e))
  //       .toList();
  //   accounts.removeWhere((a) => a.user.id == userId);
  //   await CacheHelper.saveAccountsList(
  //     accounts.map((e) => e.toJson()).toList(),
  //   );
  // }

  // Future<Result<AppInfoListModel>> getAppInfo() async {
  //   return await GetAppInfoUsecase(
  //     AppInfoRepository(),
  //   ).call(params: GetAppInfoParams());
  // }

  // Future<Result<UserIdentityModel>> getUserByUsername() async {
  //   return await GetUserByUsernameUsecase(
  //     AuthRepository(),
  //   ).call(params: getUserByUsernameParams);
  // }

  // Future<Result<String>> resetPassword() async {
  //   return await ResetPasswordUsecase(
  //     AuthRepository(),
  //   ).call(params: resetPasswordParams);
  // }
}
