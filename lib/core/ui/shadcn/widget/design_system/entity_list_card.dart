import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';
import 'app_cards.dart';
import 'status_badge.dart';

/// Reusable entity list card for categories/products/orders/variants
/// Provides consistent layout for list items across features
class EntityListCard extends fw.StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final fw.Widget? image;
  final StatusBadge? statusBadge;
  final List<EntityMetaItem>? metaItems;
  final fw.VoidCallback? onTap;
  final fw.VoidCallback? onEdit;
  final fw.Widget? trailing;

  const EntityListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.image,
    this.statusBadge,
    this.metaItems,
    this.onTap,
    this.onEdit,
    this.trailing,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              // Image (optional)
              if (image != null) ...[
                fw.Container(
                  width: 80,
                  height: 80,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(
                      AppDesignTokens.inputRadius,
                    ),
                    border: fw.Border.all(
                      color: AppDesignTokens.borderColor,
                      width: 1,
                    ),
                  ),
                  child: fw.ClipRRect(
                    borderRadius: fw.BorderRadius.circular(
                      AppDesignTokens.inputRadius,
                    ),
                    child: image,
                  ),
                ),
                const fw.SizedBox(width: AppDesignTokens.cardGap),
              ],
              // Content
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Row(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        fw.Expanded(
                          child: fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Text(
                                title,
                                style: const fw.TextStyle(
                                  fontSize: AppDesignTokens.cardTitleFontSize,
                                  fontWeight: AppDesignTokens.bold,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 2,
                                overflow: fw.TextOverflow.ellipsis,
                              ),
                              if (subtitle != null) ...[
                                const fw.SizedBox(
                                  height: AppDesignTokens.tinyGap,
                                ),
                                fw.Text(
                                  subtitle!,
                                  style: fw.TextStyle(
                                    fontSize: AppDesignTokens.captionFontSize,
                                    fontWeight: AppDesignTokens.medium,
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                  maxLines: 1,
                                  overflow: fw.TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.smallGap),
                        // Status badge
                        if (statusBadge != null) statusBadge!,
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing (edit button or custom widget)
              if (onEdit != null || trailing != null) ...[
                const fw.SizedBox(width: AppDesignTokens.smallGap),
                trailing ??
                    fw.GestureDetector(
                      onTap: onEdit,
                      child: fw.Container(
                        padding: const fw.EdgeInsets.all(8),
                        decoration: fw.BoxDecoration(
                          color: AppDesignTokens.mutedSurfaceColor,
                          borderRadius: fw.BorderRadius.circular(
                            AppDesignTokens.badgeRadius,
                          ),
                        ),
                        child: fw.Icon(
                          Icons.edit,
                          size: 18,
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                    ),
              ],
            ],
          ),
          // Description
          if (description != null && description!.isNotEmpty) ...[
            const fw.SizedBox(height: AppDesignTokens.itemGap),
            fw.Text(
              description!,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize + 1,
                color: theme.colorScheme.mutedForeground,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: fw.TextOverflow.ellipsis,
            ),
          ],
          // Meta items
          if (metaItems != null && metaItems!.isNotEmpty) ...[
            const fw.SizedBox(height: AppDesignTokens.itemGap),
            fw.Wrap(
              spacing: AppDesignTokens.cardGap,
              runSpacing: AppDesignTokens.smallGap,
              children: metaItems!.map((item) {
                return fw.Row(
                  mainAxisSize: fw.MainAxisSize.min,
                  children: [
                    fw.Icon(
                      item.icon,
                      size: 15,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const fw.SizedBox(width: 6),
                    fw.Text(
                      item.text,
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.captionFontSize,
                        fontWeight: AppDesignTokens.medium,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Meta item for EntityListCard
/// Shows icon with text for additional information
class EntityMetaItem {
  final fw.IconData icon;
  final String text;

  EntityMetaItem({required this.icon, required this.text});
}
