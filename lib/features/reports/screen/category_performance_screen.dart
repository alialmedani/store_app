import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:store/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/category_performance_model.dart';
import 'widgets/report_widgets.dart';

/// Category Performance report. Items arrive pre-sorted by revenue descending.
class CategoryPerformanceScreen extends fw.StatefulWidget {
  const CategoryPerformanceScreen({super.key});

  @override
  fw.State<CategoryPerformanceScreen> createState() =>
      _CategoryPerformanceScreenState();
}

class _CategoryPerformanceScreenState
    extends fw.State<CategoryPerformanceScreen> {
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
              title: 'report_category_performance'.tr(),
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
                        from: reports.categoryFrom,
                        to: reports.categoryTo,
                        onChanged: (f, t) {
                          reports.setCategoryRange(f, t);
                          _reload();
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      ReportToggleRow(
                        label: 'report_include_deleted'.tr(),
                        value: reports.categoryIncludeDeleted,
                        onChanged: (v) {
                          reports.setCategoryIncludeDeleted(v);
                          _reload();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            fw.Expanded(
              child: GetModel<CategoryPerformanceModel>(
                onCubitCreated: (c) => _modelCubit = c,
                useCaseCallBack: () =>
                    context.read<ReportsCubit>().getCategoryPerformance(),
                modelBuilder: (model) => _CategoryBody(model: model),
                loading: const ReportSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBody extends fw.StatelessWidget {
  final CategoryPerformanceModel model;
  const _CategoryBody({required this.model});

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
            children: [
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
                      icon: Icons.sell_rounded,
                      title: 'report_units_sold'.tr(),
                      value: '${model.totalUnitsSold}',
                      color: AppDesignTokens.successColor,
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
          child: AppCard(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Row(
                  children: [
                    fw.Flexible(
                      child: fw.Text(
                        item.categoryName ?? 'unknown'.tr(),
                        maxLines: 1,
                        overflow: fw.TextOverflow.ellipsis,
                        style: const fw.TextStyle(
                          fontSize: AppDesignTokens.cardTitleFontSize,
                          fontWeight: AppDesignTokens.bold,
                        ),
                      ),
                    ),
                    if (item.isCategoryDeleted) ...[
                      const fw.SizedBox(width: 8),
                      const DiscontinuedChip(),
                    ],
                  ],
                ),
                const fw.SizedBox(height: AppDesignTokens.itemGap),
                ReportStatLine(
                  label: 'report_revenue'.tr(),
                  value: reportMoney(item.revenue),
                  valueColor: theme.colorScheme.primary,
                ),
                ReportStatLine(
                  label: 'report_units_sold'.tr(),
                  value: '${item.unitsSold}',
                ),
                ReportStatLine(
                  label: 'report_order_count'.tr(),
                  value: '${item.orderCount}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
