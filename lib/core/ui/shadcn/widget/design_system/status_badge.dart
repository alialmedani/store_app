import 'package:flutter/widgets.dart' as fw;
import '../../design_system/app_design_tokens.dart';

/// Status badge for active/inactive/draft/paid/unpaid/lowStock/outOfStock
/// Provides consistent status indicators across the app
class StatusBadge extends fw.StatelessWidget {
  final String text;
  final StatusBadgeType type;
  final double? fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
    this.fontSize,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final colors = _getColors();

    return fw.Container(
      padding: const fw.EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: fw.BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
      ),
      child: fw.Text(
        text,
        style: fw.TextStyle(
          fontSize: fontSize ?? AppDesignTokens.smallCaptionFontSize,
          fontWeight: AppDesignTokens.bold,
          color: colors.textColor,
          letterSpacing: AppDesignTokens.captionLetterSpacing,
        ),
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (type) {
      case StatusBadgeType.active:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.successSoftColor,
          textColor: AppDesignTokens.successColor,
        );
      case StatusBadgeType.inactive:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.dangerSoftColor,
          textColor: AppDesignTokens.dangerColor,
        );
      case StatusBadgeType.draft:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.infoSoftColor,
          textColor: AppDesignTokens.infoColor,
        );
      case StatusBadgeType.paid:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.successSoftColor,
          textColor: AppDesignTokens.successColor,
        );
      case StatusBadgeType.unpaid:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.warningSoftColor,
          textColor: AppDesignTokens.warningColor,
        );
      case StatusBadgeType.lowStock:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.warningSoftColor,
          textColor: AppDesignTokens.warningColor,
        );
      case StatusBadgeType.outOfStock:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.dangerSoftColor,
          textColor: AppDesignTokens.dangerColor,
        );
      case StatusBadgeType.success:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.successSoftColor,
          textColor: AppDesignTokens.successColor,
        );
      case StatusBadgeType.info:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.infoSoftColor,
          textColor: AppDesignTokens.infoColor,
        );
      case StatusBadgeType.warning:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.warningSoftColor,
          textColor: AppDesignTokens.warningColor,
        );
      case StatusBadgeType.error:
        return _BadgeColors(
          backgroundColor: AppDesignTokens.dangerSoftColor,
          textColor: AppDesignTokens.dangerColor,
        );
    }
  }
}

enum StatusBadgeType {
  active,
  inactive,
  draft,
  paid,
  unpaid,
  lowStock,
  outOfStock,
  success,
  info,
  warning,
  error,
}

class _BadgeColors {
  final fw.Color backgroundColor;
  final fw.Color textColor;

  _BadgeColors({
    required this.backgroundColor,
    required this.textColor,
  });
}
