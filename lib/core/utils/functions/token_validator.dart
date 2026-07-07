import '../../classes/cashe_helper.dart';
import '../../../features/auth/data/repository/auth_repository.dart';
import '../../../features/auth/data/usecase/refresh_token_usecase.dart';
import '../../results/result.dart';
import '../../../features/auth/data/model/login_model.dart';

Future<void> checkToken() async {
  if (CacheHelper.token?.isNotEmpty ?? false) {
    final expiryDate = CacheHelper.datenow;
    
    if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
      // Token expired, refresh it
      final refreshToken = CacheHelper.refreshtoken;
      
      if (refreshToken != null && refreshToken.isNotEmpty) {
        Result<LoginModel> response = await RefreshTokenUsecase(
          AuthRepository(),
        ).call(
          params: RefreshTokenParams(
            grantType: "refresh_token",
            clientId: "StoreManagement_Mobile",
            refreshToken: refreshToken,
          ),
        );
        
        if (response.hasDataOnly) {
          await CacheHelper.setToken(response.data!.accessToken);
          await CacheHelper.setRefreshToken(response.data!.refreshToken);
          await CacheHelper.setExpiresIn(response.data!.expiresIn);
          await CacheHelper.setDateWithExpiry(response.data!.expiresIn ?? 3600);
        }
      }
    }
  }
}
