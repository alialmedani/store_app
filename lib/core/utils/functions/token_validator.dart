
import 'package:store/core/results/result.dart';
import '../../classes/cashe_helper.dart';

Future<void> checkToken() async {
  if (CacheHelper.token?.isNotEmpty ?? false) {
    DateTime? expiryDate = CacheHelper.datenow;
      //to doo 

    // if (DateTime.now().isAfter(expiryDate!)) {
    //   Result<LoginModel> response = await RefreshTokenUsecase(AuthRepository())
    //       .call(
    //         params: RefreshTokenParams(
    //           grantType: "refresh_token",
    //           clientId: "CoffeeApp_App",
    //           refreshToken: CacheHelper.refreshtoken ?? "",
    //         ),
    //       );
    //   if (response.hasDataOnly) {
    //     CacheHelper.setToken(response.data!.accessToken);
    //     CacheHelper.setRefreshToken(response.data!.refreshToken);
    //     CacheHelper.setExpiresIn(response.data!.expiresIn);
    //     CacheHelper.setDateWithExpiry(response.data!.expiresIn ?? 3600);
    //   }
    // }
  }
}
