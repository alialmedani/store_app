import '../constant/end_points/api_url.dart';

/// 🖼️ Image Helper - Get image URLs by entity
/// 
/// Usage:
/// ```dart
/// // Get product image URL
/// final imageUrl = ImageHelper.getProductImageUrl(productId);
/// 
/// // Get category image URL
/// final imageUrl = ImageHelper.getCategoryImageUrl(categoryId);
/// ```
class ImageHelper {
  /// Entity Type Constants
  static const int ENTITY_TYPE_CATEGORY = 1;
  static const int ENTITY_TYPE_PRODUCT = 2;
  static const int ENTITY_TYPE_PRODUCT_VARIANT = 3;
  static const int ENTITY_TYPE_ORDER = 4;

  /// Get image URL for any entity
  static String getImageUrl({
    required String entityId,
    required int entityType,
    String? filePlacement,
  }) {
    return getFileByEntityUrl(
      entityId: entityId,
      entityType: entityType,
      filePlacement: filePlacement,
    );
  }

  /// Get product image URL
  /// Example: ImageHelper.getProductImageUrl('product-id-123')
  static String getProductImageUrl(
    String productId, {
    String? placement,
  }) {
    return getImageUrl(
      entityId: productId,
      entityType: ENTITY_TYPE_PRODUCT,
      filePlacement: placement ?? 'main',
    );
  }

  /// Get category image URL
  static String getCategoryImageUrl(
    String categoryId, {
    String? placement,
  }) {
    return getImageUrl(
      entityId: categoryId,
      entityType: ENTITY_TYPE_CATEGORY,
      filePlacement: placement ?? 'main',
    );
  }

  /// Get product variant image URL
  static String getProductVariantImageUrl(
    String variantId, {
    String? placement,
  }) {
    return getImageUrl(
      entityId: variantId,
      entityType: ENTITY_TYPE_PRODUCT_VARIANT,
      filePlacement: placement ?? 'main',
    );
  }

  /// Get order image URL
  static String getOrderImageUrl(
    String orderId, {
    String? placement,
  }) {
    return getImageUrl(
      entityId: orderId,
      entityType: ENTITY_TYPE_ORDER,
      filePlacement: placement ?? 'main',
    );
  }
}
