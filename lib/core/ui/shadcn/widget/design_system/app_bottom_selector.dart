import 'package:flutter/widgets.dart' as fw;
import 'package:flutter/material.dart'
    show showModalBottomSheet; // Required for bottom sheet API
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Generic reusable bottom sheet selector for mobile
/// Supports any item type T with customizable display
class AppBottomSelector<T> {
  /// Shows a bottom sheet selector with a list of items
  static Future<T?> show<T>({
    required fw.BuildContext context,
    required String title,
    required fw.Widget content,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: fw.Color(0x00000000),
      builder: (context) {
        final theme = Theme.of(context);

        return fw.Container(
          height: height ?? fw.MediaQuery.of(context).size.height * 0.75,
          decoration: fw.BoxDecoration(
            color: theme.colorScheme.background,
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
                color: theme.colorScheme.border.withOpacity(0.1),
              ),

              // Content
              fw.Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  /// Creates a selectable list item for the bottom sheet
  static fw.Widget buildListItem<T>({
    required fw.BuildContext context,
    required T item,
    required String Function(T) titleBuilder,
    String? Function(T)? subtitleBuilder,
    bool Function(T)? isSelected,
    required fw.VoidCallback onTap,
    fw.Widget? Function(T)? leadingBuilder,
  }) {
    final theme = Theme.of(context);
    final selected = isSelected?.call(item) ?? false;

    return fw.GestureDetector(
      onTap: onTap,
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(
          horizontal: AppDesignTokens.screenPaddingHorizontal,
          vertical: AppDesignTokens.itemGap,
        ),
        decoration: fw.BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : fw.Color(0x00000000),
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
                      fontWeight: selected
                          ? AppDesignTokens.semiBold
                          : AppDesignTokens.medium,
                      color: selected
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
            if (selected) ...[
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
}
