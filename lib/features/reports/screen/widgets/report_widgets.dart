import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

// ---------------------------------------------------------------------------
// Formatting helpers
// ---------------------------------------------------------------------------

/// Money formatting shared across report screens. Mirrors the `$` prefix used
/// elsewhere in the app (order screens).
String reportMoney(double value) => '\$${value.toStringAsFixed(2)}';

String reportPercent(double value) => '${value.toStringAsFixed(1)}%';

// ---------------------------------------------------------------------------
// Enum label helpers. Backend sends RAW INTS (sales-summary) or `{id,name}`
// lookups (stock-movements). We never show the raw English enum name; map to
// localized keys here.
// ---------------------------------------------------------------------------

/// OrderStatus: 1=Draft, 2=Confirmed, 3=Cancelled
String orderStatusLabel(int? status) {
  switch (status) {
    case 1:
      return 'report_status_draft'.tr();
    case 2:
      return 'report_status_confirmed'.tr();
    case 3:
      return 'cancelled'.tr();
    default:
      return 'unknown'.tr();
  }
}

/// OrderPaymentStatus: 1=Unpaid, 2=PartiallyPaid, 3=Paid
String paymentStatusLabel(int? status) {
  switch (status) {
    case 1:
      return 'report_payment_unpaid'.tr();
    case 2:
      return 'report_payment_partially_paid'.tr();
    case 3:
      return 'report_payment_paid'.tr();
    default:
      return 'unknown'.tr();
  }
}

/// PaymentMethod: 1=Cash, 2=Card, 3=BankTransfer, 4=Other
String paymentMethodLabel(int? method) {
  switch (method) {
    case 1:
      return 'cash'.tr();
    case 2:
      return 'card'.tr();
    case 3:
      return 'bank_transfer'.tr();
    case 4:
      return 'other'.tr();
    default:
      return 'unknown'.tr();
  }
}

/// StockMovementType (stock-movements `reason.id`):
/// 1=Increase, 2=Decrease, 3=Adjustment, 4=Sale, 5=OrderCancellation,
/// 6=Return, 7=OpeningStock
String movementTypeLabel(int? type) {
  switch (type) {
    case 1:
      return 'report_movement_increase'.tr();
    case 2:
      return 'report_movement_decrease'.tr();
    case 3:
      return 'report_movement_adjustment'.tr();
    case 4:
      return 'report_movement_sale'.tr();
    case 5:
      return 'report_movement_order_cancellation'.tr();
    case 6:
      return 'report_movement_return'.tr();
    case 7:
      return 'report_movement_opening_stock'.tr();
    default:
      return 'unknown'.tr();
  }
}

/// StockMovementSourceType (`sourceType.id`):
/// 1=Manual, 2=ProductVariant, 3=Order, 4=Return
String sourceTypeLabel(int? type) {
  switch (type) {
    case 1:
      return 'report_source_manual'.tr();
    case 2:
      return 'report_source_product_variant'.tr();
    case 3:
      return 'report_source_order'.tr();
    case 4:
      return 'report_source_return'.tr();
    default:
      return 'unknown'.tr();
  }
}

// ---------------------------------------------------------------------------
// "Discontinued / Deleted" chip shown next to a deleted entity name. The real
// original name is still shown; the row is never hidden or greyed out.
// ---------------------------------------------------------------------------
class DiscontinuedChip extends fw.StatelessWidget {
  const DiscontinuedChip({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return StatusBadge(
      text: 'report_discontinued'.tr(),
      type: StatusBadgeType.error,
      fontSize: AppDesignTokens.smallCaptionFontSize,
    );
  }
}

// ---------------------------------------------------------------------------
// Section header row for grouping report content.
// ---------------------------------------------------------------------------
class ReportSectionTitle extends fw.StatelessWidget {
  final String title;
  const ReportSectionTitle(this.title, {super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.itemGap),
      child: fw.Row(
        children: [
          fw.Container(
            width: 3,
            height: 18,
            decoration: fw.BoxDecoration(
              gradient: AppDesignTokens.primaryGradient,
              borderRadius: fw.BorderRadius.circular(1.5),
            ),
          ),
          const fw.SizedBox(width: AppDesignTokens.itemGap),
          fw.Text(
            title,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: AppDesignTokens.bold,
              color: theme.colorScheme.foreground,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date-range selector. Enforces ToDate >= FromDate client-side.
// ---------------------------------------------------------------------------
class ReportDateRangeBar extends fw.StatelessWidget {
  final DateTime from;
  final DateTime to;
  final void Function(DateTime from, DateTime to) onChanged;

  const ReportDateRangeBar({
    super.key,
    required this.from,
    required this.to,
    required this.onChanged,
  });

  Future<void> _pickFrom(fw.BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: from,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Keep To >= From.
      final newTo = to.isBefore(picked) ? picked : to;
      onChanged(picked, newTo);
    }
  }

  Future<void> _pickTo(fw.BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: to.isBefore(from) ? from : to,
      firstDate: from, // enforces To >= From
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onChanged(from, picked);
    }
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      children: [
        fw.Expanded(
          child: _DateChip(
            label: 'report_from'.tr(),
            value: DateFormat('MMM d, y').format(from),
            onTap: () => _pickFrom(context),
          ),
        ),
        const fw.SizedBox(width: AppDesignTokens.cardGap),
        fw.Expanded(
          child: _DateChip(
            label: 'report_to'.tr(),
            value: DateFormat('MMM d, y').format(to),
            onTap: () => _pickTo(context),
          ),
        ),
      ],
    );
  }
}

class _DateChip extends fw.StatelessWidget {
  final String label;
  final String value;
  final fw.VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return PressScale(
      onTap: onTap,
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: fw.BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
          border: fw.Border.all(color: AppDesignTokens.glassBorder),
        ),
        child: fw.Row(
          children: [
            fw.Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const fw.SizedBox(width: 10),
            fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Text(
                  label,
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.smallCaptionFontSize,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                fw.Text(
                  value,
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.captionFontSize + 1,
                    fontWeight: AppDesignTokens.semiBold,
                    color: theme.colorScheme.foreground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lightweight bar chart (no chart package; built from design tokens). Scales
// bar heights to the max value. Horizontally scrollable when there are many
// buckets.
// ---------------------------------------------------------------------------
class ReportBarChart extends fw.StatelessWidget {
  final List<ReportBar> bars;
  final double height;

  const ReportBarChart({super.key, required this.bars, this.height = 180});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    if (bars.isEmpty) {
      return fw.SizedBox(
        height: height,
        child: fw.Center(
          child: fw.Text(
            'report_no_chart_data'.tr(),
            style: fw.TextStyle(color: theme.colorScheme.mutedForeground),
          ),
        ),
      );
    }

    final maxValue = bars
        .map((b) => b.value)
        .fold<double>(0, (p, v) => v > p ? v : p);
    const barWidth = 34.0;
    const barSpacing = 12.0;

    return fw.SizedBox(
      height: height,
      child: fw.SingleChildScrollView(
        scrollDirection: fw.Axis.horizontal,
        child: fw.Row(
          crossAxisAlignment: fw.CrossAxisAlignment.end,
          children: [
            for (final bar in bars)
              fw.Padding(
                padding: const fw.EdgeInsets.only(right: barSpacing),
                child: fw.Column(
                  mainAxisAlignment: fw.MainAxisAlignment.end,
                  children: [
                    fw.Text(
                      bar.valueLabel,
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.smallCaptionFontSize,
                        fontWeight: AppDesignTokens.semiBold,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const fw.SizedBox(height: 6),
                    fw.Container(
                      width: barWidth,
                      height: maxValue <= 0
                          ? 4.0
                          : (height - 56) *
                                  (bar.value / maxValue).clamp(0.0, 1.0) +
                              4.0,
                      decoration: fw.BoxDecoration(
                        gradient: AppDesignTokens.primaryGradient,
                        borderRadius: fw.BorderRadius.circular(10),
                      ),
                    ),
                    const fw.SizedBox(height: 6),
                    fw.SizedBox(
                      width: barWidth + barSpacing,
                      child: fw.Text(
                        bar.label,
                        textAlign: fw.TextAlign.center,
                        maxLines: 2,
                        overflow: fw.TextOverflow.ellipsis,
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.smallCaptionFontSize,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ReportBar {
  final double value;
  final String label;
  final String valueLabel;

  ReportBar({required this.value, required this.label, required this.valueLabel});
}

// ---------------------------------------------------------------------------
// Labelled on/off toggle row used in report filter panels.
// ---------------------------------------------------------------------------
class ReportToggleRow extends fw.StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const ReportToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Row(
      mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
      children: [
        fw.Expanded(
          child: fw.Text(
            label,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.bodyFontSize,
              color: theme.colorScheme.foreground,
            ),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: AppDesignTokens.primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// A simple label/value row used inside report cards.
// ---------------------------------------------------------------------------
class ReportStatLine extends fw.StatelessWidget {
  final String label;
  final String value;
  final fw.Color? valueColor;

  const ReportStatLine({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Padding(
      padding: const fw.EdgeInsets.symmetric(vertical: 3),
      child: fw.Row(
        mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
        children: [
          fw.Flexible(
            child: fw.Text(
              label,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize + 1,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
          const fw.SizedBox(width: 10),
          fw.Text(
            value,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: AppDesignTokens.semiBold,
              color: valueColor ?? theme.colorScheme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
