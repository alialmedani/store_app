import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:store/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/profit_margin_model.dart';
import 'widgets/report_widgets.dart';

/// Profit / Margin report.
///
/// Business rules enforced in the UI:
/// - Profit/margin figures are HISTORICAL (cost at sale time) — shown as-is.
/// - Rows with `hasCostData == false` show a "cost data incomplete" badge and
///   the margin % is not presented as trustworthy.
/// - A top banner warns when not all items have complete cost data.
/// - `currentCostOfGoodsSold` is shown only as an informational footnote when
///   non-null and the cost changed since sale; never substituted into profit.
class ProfitMarginScreen extends fw.StatefulWidget {
  const ProfitMarginScreen({super.key});

  @override
  fw.State<ProfitMarginScreen> createState() => _ProfitMarginScreenState();
}

class _ProfitMarginScreenState extends fw.State<ProfitMarginScreen> {
  GetModelCubit? _modelCubit;

  void _reload() => _modelCubit?.getModel();

  @override
  fw.Widget build(fw.BuildContext context) {
    final reports = context.read<ReportsCubit>();

    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            AppHeader(
              title: 'report_profit_margin'.tr(),
              onBack: () => fw.Navigator.pop(context),
            ),
            BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, _) {
                return fw.Padding(
                  padding: const fw.EdgeInsets.fromLTRB(
                    AppDesignTokens.screenPaddingHorizontal,
                    0,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.cardGap,
                  ),
                  child: fw.Column(
                    children: [
                      ReportDateRangeBar(
                        from: reports.profitFrom,
                        to: reports.profitTo,
                        onChanged: (f, t) {
                          reports.setProfitRange(f, t);
                          _reload();
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      ReportToggleRow(
                        label: 'report_group_by_variant'.tr(),
                        value: reports.profitGroupByVariant,
                        onChanged: (v) {
                          reports.setProfitGroupByVariant(v);
                          _reload();
                        },
                      ),
                      ReportToggleRow(
                        label: 'report_include_deleted'.tr(),
                        value: reports.profitIncludeDeleted,
                        onChanged: (v) {
                          reports.setProfitIncludeDeleted(v);
                          _reload();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            fw.Expanded(
              child: GetModel<ProfitMarginModel>(
                onCubitCreated: (c) => _modelCubit = c,
                useCaseCallBack: () =>
                    context.read<ReportsCubit>().getProfitMargin(),
                modelBuilder: (model) => _ProfitBody(model: model),
                loading: const ReportSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfitBody extends fw.StatelessWidget {
  final ProfitMarginModel model;
  const _ProfitBody({required this.model});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.ListView.builder(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      itemCount: model.items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              if (!model.hasCompleteCostData) _IncompleteBanner(),
              fw.Row(
                children: [
                  fw.Expanded(
                    child: StatCard(
                      animationIndex: 0,
                      icon: Icons.payments_rounded,
                      title: 'report_revenue'.tr(),
                      value: reportMoney(model.totalRevenue),
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const fw.SizedBox(width: AppDesignTokens.cardGap),
                  fw.Expanded(
                    child: StatCard(
                      animationIndex: 1,
                      icon: Icons.trending_up_rounded,
                      title: 'report_gross_profit'.tr(),
                      value: reportMoney(model.totalGrossProfit),
                      color: AppDesignTokens.successColor,
                    ),
                  ),
                ],
              ),
              const fw.SizedBox(height: AppDesignTokens.cardGap),
              fw.Row(
                children: [
                  fw.Expanded(
                    child: StatCard(
                      animationIndex: 2,
                      icon: Icons.inventory_2_rounded,
                      title: 'report_cogs'.tr(),
                      value: reportMoney(model.totalCostOfGoodsSold),
                      color: AppDesignTokens.warningColor,
                    ),
                  ),
                  const fw.SizedBox(width: AppDesignTokens.cardGap),
                  fw.Expanded(
                    child: StatCard(
                      animationIndex: 3,
                      icon: Icons.percent_rounded,
                      title: 'report_margin'.tr(),
                      value: reportPercent(model.totalMarginPercent),
                      color: AppDesignTokens.infoColor,
                    ),
                  ),
                ],
              ),
              const fw.SizedBox(height: AppDesignTokens.sectionGap),
            ],
          );
        }
        final item = model.items[index - 1];
        return fw.Padding(
          padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
          child: _ProfitItemCard(item: item),
        );
      },
    );
  }
}

class _ProfitItemCard extends fw.StatelessWidget {
  final ProfitMarginItem item;
  const _ProfitItemCard({required this.item});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final deleted = item.isProductDeleted || item.isVariantDeleted;
    final variantInfo = [item.color, item.size]
        .where((e) => e != null && e.isNotEmpty)
        .join(' / ');
    final showCurrentCostFootnote =
        item.currentCostOfGoodsSold != null && item.hasCostChangedSinceSale;

    return AppCard(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            children: [
              fw.Flexible(
                child: fw.Text(
                  item.name ?? 'unknown_product'.tr(),
                  maxLines: 1,
                  overflow: fw.TextOverflow.ellipsis,
                  style: const fw.TextStyle(
                    fontSize: AppDesignTokens.cardTitleFontSize,
                    fontWeight: AppDesignTokens.bold,
                  ),
                ),
              ),
              if (deleted) ...[
                const fw.SizedBox(width: 8),
                const DiscontinuedChip(),
              ],
            ],
          ),
          if (variantInfo.isNotEmpty)
            fw.Padding(
              padding: const fw.EdgeInsets.only(top: 2),
              child: fw.Text(
                variantInfo,
                style: fw.TextStyle(
                  fontSize: AppDesignTokens.captionFontSize,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
          if (!item.hasCostData)
            fw.Padding(
              padding: const fw.EdgeInsets.only(top: 8),
              child: StatusBadge(
                text: 'report_cost_incomplete'.tr(),
                type: StatusBadgeType.warning,
              ),
            ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          ReportStatLine(
            label: 'report_qty_sold_label'.tr(),
            value: '${item.quantitySold}',
          ),
          ReportStatLine(
            label: 'report_revenue'.tr(),
            value: reportMoney(item.revenue),
          ),
          ReportStatLine(
            label: 'report_cogs'.tr(),
            value: reportMoney(item.costOfGoodsSold),
          ),
          ReportStatLine(
            label: 'report_gross_profit'.tr(),
            value: reportMoney(item.grossProfit),
            valueColor: item.grossProfit >= 0
                ? AppDesignTokens.successColor
                : AppDesignTokens.dangerColor,
          ),
          ReportStatLine(
            label: item.hasCostData
                ? 'report_margin'.tr()
                : 'report_margin_understated'.tr(),
            value: reportPercent(item.marginPercent),
            valueColor: item.hasCostData
                ? theme.colorScheme.foreground
                : theme.colorScheme.mutedForeground,
          ),
          if (showCurrentCostFootnote)
            fw.Padding(
              padding: const fw.EdgeInsets.only(top: 8),
              child: fw.Text(
                'report_current_cost_footnote'.tr(args: [
                  reportMoney(item.currentCostOfGoodsSold!),
                  reportMoney(item.costOfGoodsSold),
                ]),
                style: fw.TextStyle(
                  fontSize: AppDesignTokens.smallCaptionFontSize,
                  fontStyle: fw.FontStyle.italic,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IncompleteBanner extends fw.StatelessWidget {
  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
      child: fw.Container(
        padding: const fw.EdgeInsets.all(14),
        decoration: fw.BoxDecoration(
          color: AppDesignTokens.warningSoftColor,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
          border: fw.Border.all(
            color: AppDesignTokens.warningColor.withValues(alpha: 0.4),
          ),
        ),
        child: fw.Row(
          children: [
            fw.Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: AppDesignTokens.warningColor,
            ),
            const fw.SizedBox(width: 10),
            fw.Expanded(
              child: fw.Text(
                'report_cost_data_incomplete_banner'.tr(),
                style: fw.TextStyle(
                  fontSize: AppDesignTokens.captionFontSize + 1,
                  fontWeight: AppDesignTokens.medium,
                  color: AppDesignTokens.warningColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
