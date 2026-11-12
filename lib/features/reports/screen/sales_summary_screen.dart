import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:store/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/sales_summary_model.dart';
import 'widgets/report_widgets.dart';

/// Sales Summary report (dashboard/overview with chart from buckets).
class SalesSummaryScreen extends fw.StatefulWidget {
  const SalesSummaryScreen({super.key});

  @override
  fw.State<SalesSummaryScreen> createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends fw.State<SalesSummaryScreen> {
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
              title: 'report_sales_summary'.tr(),
              onBack: () => fw.Navigator.pop(context),
            ),
            // Filters
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
                        from: reports.salesFrom,
                        to: reports.salesTo,
                        onChanged: (f, t) {
                          reports.setSalesRange(f, t);
                          _reload();
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      _GroupBySelector(
                        selected: reports.salesGroupBy,
                        onChanged: (g) {
                          reports.setSalesGroupBy(g);
                          _reload();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            fw.Expanded(
              child: GetModel<SalesSummaryModel>(
                onCubitCreated: (c) => _modelCubit = c,
                useCaseCallBack: () =>
                    context.read<ReportsCubit>().getSalesSummary(),
                modelBuilder: (model) => _SalesSummaryBody(model: model),
                loading: const ReportSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesSummaryBody extends fw.StatelessWidget {
  final SalesSummaryModel model;
  const _SalesSummaryBody({required this.model});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final bars = model.buckets
        .map((b) => ReportBar(
              value: b.revenue,
              label: b.periodStart != null
                  ? DateFormat('M/d').format(b.periodStart!)
                  : '',
              valueLabel: b.revenue.toStringAsFixed(0),
            ))
        .toList();

    return fw.ListView(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      children: [
        // KPIs — Revenue and Cash Collected labelled distinctly.
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
                icon: Icons.account_balance_rounded,
                title: 'report_cash_collected'.tr(),
                value: reportMoney(model.totalCollected),
                color: AppDesignTokens.successColor,
              ),
            ),
          ],
        ),
        const fw.SizedBox(height: AppDesignTokens.cardGap),
        StatCard(
          animationIndex: 2,
          icon: Icons.receipt_long_rounded,
          title: 'report_total_orders'.tr(),
          value: '${model.totalOrders}',
          color: AppDesignTokens.infoColor,
        ),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),

        // Revenue chart
        ReportSectionTitle('report_revenue_over_time'.tr()),
        AppCard(child: ReportBarChart(bars: bars)),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),

        // By status
        if (model.byStatus.isNotEmpty) ...[
          ReportSectionTitle('report_by_status'.tr()),
          AppCard(
            child: fw.Column(
              children: [
                for (final s in model.byStatus)
                  ReportStatLine(
                    label:
                        '${orderStatusLabel(s.status)}  ·  ${'report_orders_count'.tr(args: ['${s.orderCount}'])}',
                    value: reportMoney(s.revenue),
                  ),
              ],
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.sectionGap),
        ],

        // By payment method
        if (model.byPaymentMethod.isNotEmpty) ...[
          ReportSectionTitle('report_by_payment_method'.tr()),
          AppCard(
            child: fw.Column(
              children: [
                for (final p in model.byPaymentMethod)
                  ReportStatLine(
                    label:
                        '${paymentMethodLabel(p.paymentMethod)}  ·  ${'report_payments_count'.tr(args: ['${p.paymentCount}'])}',
                    value: reportMoney(p.amount),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _GroupBySelector extends fw.StatelessWidget {
  final int selected;
  final void Function(int) onChanged;

  const _GroupBySelector({required this.selected, required this.onChanged});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      children: [
        _seg(context, 1, 'report_group_day'.tr()),
        const fw.SizedBox(width: 8),
        _seg(context, 2, 'report_group_week'.tr()),
        const fw.SizedBox(width: 8),
        _seg(context, 3, 'report_group_month'.tr()),
      ],
    );
  }

  fw.Widget _seg(fw.BuildContext context, int value, String label) {
    final theme = Theme.of(context);
    final active = selected == value;
    return fw.Expanded(
      child: PressScale(
        onTap: () => onChanged(value),
        child: fw.Container(
          padding: const fw.EdgeInsets.symmetric(vertical: 11),
          alignment: fw.Alignment.center,
          decoration: fw.BoxDecoration(
            gradient: active ? AppDesignTokens.primaryGradient : null,
            color: active ? null : theme.colorScheme.card,
            borderRadius:
                fw.BorderRadius.circular(AppDesignTokens.inputRadius),
            border: fw.Border.all(
              color: active
                  ? AppDesignTokens.primaryColor
                  : AppDesignTokens.glassBorder,
            ),
          ),
          child: fw.Text(
            label,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: AppDesignTokens.semiBold,
              color: active
                  ? AppDesignTokens.onAccentColor
                  : theme.colorScheme.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
