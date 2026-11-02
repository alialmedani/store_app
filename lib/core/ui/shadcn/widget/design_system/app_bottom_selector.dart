import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import '../../design_system/app_design_tokens.dart';
import 'app_skeleton_loader.dart';
import 'package:easy_localization/easy_localization.dart';

/// Generic reusable bottom sheet selector for mobile
/// Fully customizable for any entity type T
///
/// Each selector can provide:
/// - Custom itemBuilder to match the real item layout
/// - Custom loadingBuilder for skeleton that matches the item shape
/// - Custom emptyBuilder for empty state
///
/// Usage example:
/// ```dart
/// AppBottomSelector.show<CategoryModel>(
///   context: context,
///   title: 'select_category'.tr(),
///   itemBuilder: (item, isSelected, onTap) {
///     return CategorySelectorItem(
///       category: item,
///       isSelected: isSelected,
///       onTap: onTap,
///     );
///   },
///   loadingBuilder: () => CategorySelectorSkeleton(),
///   content: PaginationList<CategoryModel>(...),
/// );
/// ```
class AppBottomSelector {
  /// Shows a generic bottom sheet selector
  ///
  /// [title] - Header title
  /// [content] - Main content widget (usually a PaginationList or ListView)
  /// [height] - Optional custom height (default: 75% of screen)
  static Future<T?> show<T>({
    required fw.BuildContext context,
    required String title,
    required fw.Widget content,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const fw.Color(0x00000000),
      builder: (context) {
        final theme = Theme.of(context);

        return fw.Container(
          height: height ?? fw.MediaQuery.of(context).size.height * 0.75,
          decoration: fw.BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const fw.BorderRadius.only(
              topLeft: fw.Radius.circular(20),
              topRight: fw.Radius.circular(20),
            ),
          ),
          child: fw.Column(
            children: [
              // Drag handle
              fw.Container(
                margin: const fw.EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: fw.BoxDecoration(
                  color: theme.colorScheme.border,
                  borderRadius: fw.BorderRadius.circular(2),
                ),
              ),

              // Header
              fw.Padding(
                padding: const fw.EdgeInsets.fromLTRB(
                  AppDesignTokens.screenPaddingHorizontal,
                  AppDesignTokens.smallGap,
                  AppDesignTokens.screenPaddingHorizontal,
                  AppDesignTokens.itemGap,
                ),
                child: fw.Row(
                  children: [
                    fw.Expanded(
                      child: fw.Text(
                        title,
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.sectionTitleFontSize,
                          fontWeight: AppDesignTokens.bold,
                          color: AppDesignTokens.titleTextColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const fw.Icon(Icons.close, size: 20),
                      onPressed: () => fw.Navigator.pop(context),
                      variance: ButtonVariance.ghost,
                    ),
                  ],
                ),
              ),

              // Divider
              fw.Container(
                height: 1,
                color: theme.colorScheme.border.withValues(alpha: 0.1),
              ),

              // Content
              fw.Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  /// Helper to build a standard selectable list item
  /// Use this for simple cases, or create custom item widgets for complex layouts
  ///
  /// For complex selectors (products, customers), create custom item widgets instead
  static fw.Widget buildStandardItem<T>({
    required fw.BuildContext context,
    required T item,
    required String Function(T) titleBuilder,
    String? Function(T)? subtitleBuilder,
    bool isSelected = false,
    required fw.VoidCallback onTap,
    fw.Widget? Function(T)? leadingBuilder,
  }) {
    final theme = Theme.of(context);

    return fw.GestureDetector(
      onTap: onTap,
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(
          horizontal: AppDesignTokens.screenPaddingHorizontal,
          vertical: AppDesignTokens.itemGap,
        ),
        decoration: fw.BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : const fw.Color(0x00000000),
        ),
        child: fw.Row(
          children: [
            if (leadingBuilder != null) ...[
              leadingBuilder(item) ?? const fw.SizedBox.shrink(),
              const fw.SizedBox(width: AppDesignTokens.itemGap),
            ],
            fw.Expanded(
              child: fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: [
                  fw.Text(
                    titleBuilder(item),
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.bodyFontSize,
                      fontWeight: isSelected
                          ? AppDesignTokens.semiBold
                          : AppDesignTokens.medium,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : AppDesignTokens.titleTextColor,
                    ),
                  ),
                  if (subtitleBuilder != null &&
                      subtitleBuilder(item) != null) ...[
                    const fw.SizedBox(height: AppDesignTokens.tinyGap),
                    fw.Text(
                      subtitleBuilder(item)!,
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.captionFontSize,
                        color: AppDesignTokens.mutedTextColor,
                      ),
                      maxLines: 2,
                      overflow: fw.TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected) ...[
              const fw.SizedBox(width: AppDesignTokens.smallGap),
              fw.Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Legacy method - kept for backward compatibility
  /// Use buildStandardItem instead
  @Deprecated('Use buildStandardItem instead')
  static fw.Widget buildListItem<T>({
    required fw.BuildContext context,
    required T item,
    required String Function(T) titleBuilder,
    String? Function(T)? subtitleBuilder,
    bool Function(T)? isSelected,
    required fw.VoidCallback onTap,
    fw.Widget? Function(T)? leadingBuilder,
  }) {
    return buildStandardItem<T>(
      context: context,
      item: item,
      titleBuilder: titleBuilder,
      subtitleBuilder: subtitleBuilder,
      isSelected: isSelected?.call(item) ?? false,
      onTap: onTap,
      leadingBuilder: leadingBuilder,
    );
  }
}

/// Selectable row used in every selector list/dialog.
/// Real item and [SelectorListSkeleton] share the same geometry.
class SelectorTile extends fw.StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final fw.VoidCallback onTap;

  const SelectorTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isSelected = false,
  });

  static const double verticalPadding = 14;
  static const double gap = 10;

  @override
  fw.Widget build(fw.BuildContext context) {
    final primary = AppDesignTokens.primaryColor;
    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: gap),
      child: fw.GestureDetector(
        behavior: fw.HitTestBehavior.opaque,
        onTap: onTap,
        child: fw.Container(
          padding: const fw.EdgeInsets.symmetric(
            horizontal: 16,
            vertical: verticalPadding,
          ),
          decoration: fw.BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: 0.12)
                : AppDesignTokens.mutedSurfaceColor.withValues(alpha: 0.55),
            borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
            border: fw.Border.all(
              color: isSelected
                  ? primary.withValues(alpha: 0.7)
                  : AppDesignTokens.borderColor.withValues(alpha: 0.5),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: fw.Row(
            children: [
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      title,
                      maxLines: 1,
                      overflow: fw.TextOverflow.ellipsis,
                      style: fw.TextStyle(
                        fontSize: 14.5,
                        fontWeight: isSelected
                            ? AppDesignTokens.bold
                            : AppDesignTokens.semiBold,
                        color: isSelected
                            ? primary
                            : AppDesignTokens.titleTextColor,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const fw.SizedBox(height: 3),
                      fw.Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: fw.TextOverflow.ellipsis,
                        style: fw.TextStyle(
                          fontSize: 12,
                          color: AppDesignTokens.mutedTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                fw.Icon(Icons.check_circle_rounded, size: 20, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton with exactly the same geometry as [SelectorTile].
class SelectorListSkeleton extends fw.StatelessWidget {
  final int count;
  final bool withSubtitle;
  final fw.EdgeInsetsGeometry padding;
  const SelectorListSkeleton({
    super.key,
    this.count = 6,
    this.withSubtitle = false,
    this.padding = fw.EdgeInsets.zero,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView.builder(
      physics: const fw.NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: count,
      itemBuilder: (context, i) => fw.Padding(
        padding: const fw.EdgeInsets.only(bottom: SelectorTile.gap),
        child: fw.Container(
          width: double.infinity,
          padding: const fw.EdgeInsets.symmetric(
            horizontal: 16,
            vertical: SelectorTile.verticalPadding,
          ),
          decoration: fw.BoxDecoration(
            color: AppDesignTokens.mutedSurfaceColor.withValues(alpha: 0.55),
            borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
            border: fw.Border.all(
              color: AppDesignTokens.borderColor.withValues(alpha: 0.5),
            ),
          ),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              const AppSkeletonBox(width: 140, height: 16, borderRadius: 6),
              if (withSubtitle) ...[
                const fw.SizedBox(height: 3),
                const AppSkeletonBox(width: 90, height: 12, borderRadius: 6),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
