
import 'package:hive_flutter/hive_flutter.dart';
import 'package:store/core/constant/end_points/cashe_helper_constant.dart';

class CacheHelper {
  static late Box<dynamic> box;
  static late Box<dynamic> wishlistBox;
  static late Box<dynamic> cartBox;
  static late Box<dynamic> currentUserBox;
  static late Box<dynamic> settingBox;

  static init() async {
    await Hive.initFlutter();
    // Hive.registerAdapter(MatrixModelAdapter());
    box = await Hive.openBox("default_box");
    wishlistBox = await Hive.openBox("model_box");
    cartBox = await Hive.openBox("cart_box");
    currentUserBox = await Hive.openBox("current_user_box");
    settingBox = await Hive.openBox("setting_box");
  }

  static Future<void> setLang(String value) => box.put(languageValue, value);

  static Future<void> setToken(String? value) =>
      box.put(accessToken, value ?? '');
  static Future<void> setDeviceToken(String? value) =>
      box.put(deviceToken, value ?? '');
  static Future<void> setRefreshToken(String? value) =>
      box.put(refreshToken, value ?? '');
  static Future<void> setUserId(String? value) => box.put(userId, value ?? 0);
  static Future<void> setRole(String? value) => box.put(role, value ?? '');
  static Future<void> setFloor(String? value) => box.put(floor, value ?? '');
  static Future<void> setOffice(String? value) => box.put(office, value ?? '');
  static Future<void> setDeliveryMode(String value) =>
      box.put(deliveryMode, value);
  static Future<void> setExpiresIn(int? value) =>
      box.put(expiresIn, value ?? 0);

  static Future<void> setFirstTime(bool value) async {
    await box.put(isFirstTime, value);
  }

  static Future<void> setDateWithExpiry(int expiresInSeconds) {
    DateTime expiryDateTime = DateTime.now().add(
      Duration(seconds: expiresInSeconds),
    );
    return box.put(date, expiryDateTime);
  }

  ////////////////////////////////Get///////////////////////////////

  static String get lang => box.get(languageValue) ?? 'en';
  static String? get token {
    if (!box.containsKey(accessToken)) return null;
    return "${box.get(accessToken)}";
  }

  static String? get getDeviceToken {
    if (!box.containsKey(deviceToken)) return null;
    return "${box.get(deviceToken)}";
  }

  static String? get refreshtoken {
    if (!box.containsKey(refreshToken)) return null;
    return "${box.get(refreshToken)}";
  }

  static String? get userID {
    if (!box.containsKey(userId)) return null;
    return "${box.get(userId)}";
  }

  static String? get getRole {
    if (!box.containsKey(role)) return null;
    return "${box.get(role)}";
  }

  static String? get getOffice {
    if (!box.containsKey(office)) return null;
    return "${box.get(office)}";
  }

  static String? get getFloor {
    if (!box.containsKey(floor)) return null;
    return "${box.get(floor)}";
  }

  static String get getDeliveryMode => box.get(deliveryMode) ?? 'Default';

  static bool get firstTime => box.get(isFirstTime) ?? true;
  static int? get expiresin => box.get(expiresIn);
  static DateTime? get datenow => box.get(date);

  // static Future<void> setUserInfo(LoginModel? value) =>
  //     box.put(userModel, value);

  // static LoginModel? get userInfo {
  //   if (!box.containsKey(userModel)) return null;
  //   return box.get(userModel);
  // }

  // Cart operations
  // static Future<void> addToCart(CartItemModel cartItem) async {
  //   List<CartItemModel> currentCart = getCartItems();

  //   // Check if item already exists in cart
  //   int existingIndex = currentCart.indexWhere(
  //     (item) =>
  //         item.drink.id == cartItem.drink.id &&
  //         item.size == cartItem.size &&
  //         item.sugarPercentage == cartItem.sugarPercentage,
  //   );

    // if (existingIndex != -1) {
    //   // Update quantity if item exists
    //   currentCart[existingIndex] = currentCart[existingIndex].copyWith(
    //     quantity: currentCart[existingIndex].quantity + cartItem.quantity,
    //   );
    // } else {
    //   // Add new item
    //   currentCart.add(cartItem);
    // }

    // await _saveCartItems(currentCart);
  }

  // static Future<void> removeFromCart(
  //   String drinkId,
  //   String size,
  //   double sugarPercentage,
  // ) async {
  //   List<CartItemModel> currentCart = getCartItems();
  //   currentCart.removeWhere(
  //     (item) =>
  //         item.drink.id == drinkId &&
  //         item.size == size &&
  //         item.sugarPercentage == sugarPercentage,
  //   );
  //   await _saveCartItems(currentCart);
  // }

  // static Future<void> updateCartItemQuantity(
  //   String drinkId,
  //   String size,
  //   double sugarPercentage,
  //   int newQuantity,
  // ) async {
  //   List<CartItemModel> currentCart = getCartItems();
  //   int index = currentCart.indexWhere(
  //     (item) =>
  //         item.drink.id == drinkId &&
  //         item.size == size &&
  //         item.sugarPercentage == sugarPercentage,
  //   );

  //   if (index != -1) {
  //     if (newQuantity <= 0) {
  //       currentCart.removeAt(index);
  //     } else {
  //       currentCart[index] = currentCart[index].copyWith(quantity: newQuantity);
  //     }
  //     await _saveCartItems(currentCart);
  //   }
  // }

  // static List<CartItemModel> getCartItems() {
  //   try {
  //     if (!cartBox.containsKey(cartItems)) return [];

  //     List<dynamic> cartData = cartBox.get(cartItems) ?? [];
  //     return cartData
  //         .map(
  //           (item) => CartItemModel.fromJson(Map<String, dynamic>.from(item)),
  //         )
  //         .toList();
  //   } catch (e) {
  //     // If there's any error loading cart items, clear the cache and return empty list
  //     cartBox.delete(cartItems);
  //     return [];
  //   }
  // }

  // static Future<void> clearCart() async {
  //   await cartBox.delete(cartItems);
  // }

  // // Debug method to test cart operations
  // static Future<void> debugClearCartAndTest() async {
  //   try {
  //     await clearCart();
  //   } catch (e) {
  //     debugPrint("Error clearing cart: $e");
  //   }
  // }

  // static int get cartItemCount {
  //   List<CartItemModel> cart = getCartItems();
  //   return cart.fold(0, (sum, item) => sum + item.quantity);
  // }

  // static Future<void> _saveCartItems(List<CartItemModel> cartItemsList) async {
  //   List<Map<String, dynamic>> cartData = cartItemsList
  //       .map((item) => item.toJson())
  //       .toList();
  //   await cartBox.put(cartItems, cartData);
  // }
// }
