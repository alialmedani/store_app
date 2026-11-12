import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:store/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/inventory_status_model.dart';
import 'widgets/report_widgets.dart';

/// Inventory Status report (stock snapshot / alerts). Not paged; rendered with
/// a lazy ListView.builder so large catalogs stay performant.
class InventoryStatusScreen extends fw.StatefulWidget {
  const InventoryStatusScreen({super.key});

  @override
  fw.State<InventoryStatusScreen> createState() =>
      _InventoryStatusScreenState();
}

class _InventoryStatusScreenState extends fw.State<InventoryStatusScreen> {
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
              title: 'report_inventory_status'.tr(),
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
                  child: AppCard(
                    child: fw.Column(
                      children: [
                        fw.Row(
                          mainAxisAlignment:
                              fw.MainAxisAlignment.spaceBetween,
                          children: [
                            fw.Expanded(
                              child: fw.Text(
                                'report_low_stock_only'.tr(),
                                style: fw.TextStyle(
                                  fontSize:
                                      AppDesignTokens.bodyFontSize,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .foreground,
                                ),
                              ),
                            ),
                            Switch(
                              value: reports.inventoryLowStockOnly,
                              activeThumbColor: AppDesignTokens.primaryColor,
                              onChanged: (v) {
                                reports.setInventoryLowStockOnly(v);
                                _reload();
                              },
                            ),
                          ],
                        ),
                        _ThresholdStepper(
                          value: reports.inventoryLowStockThreshold,
                          onChanged: (v) {
                            reports.setInventoryLowStockThreshold(v);
                            _reload();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            fw.Expanded(
              child: GetModel<InventoryStatusModel>(
                onCubitCreated: (c) => _modelCubit = c,
                useCaseCallBack: () =>
                    context.read<ReportsCubit>().getInventoryStatus(),
                modelBuilder: (model) => _InventoryBody(model: model),
                loading: const ReportSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryBody extends fw.StatelessWidget {
  final InventoryStatusModel model;
  const _InventoryBody({required this.model});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView.builder(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      itemCount: model.items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _summary(context);
        final item = model.items[index - 1];
        return fw.Padding(
          padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
          child: _InventoryItemCard(item: item),
        );
      },
    );
  }

  fw.Widget _summary(fw.BuildContext context) {
    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        fw.Row(
          children: [
            fw.Expanded(
              child: StatCard(
                animationIndex: 0,
                icon: Icons.savings_rounded,
                title: 'report_total_stock_value'.tr(),
                value: reportMoney(model.totalStockValue),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const fw.SizedBox(width: AppDesignTokens.cardGap),
            fw.Expanded(
              child: StatCard(
                animationIndex: 1,
                icon: Icons.numbers_rounded,
                title: 'report_total_units'.tr(),
                value: '${model.totalUnits}',
                color: AppDesignTokens.infoColor,
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
                icon: Icons.warning_amber_rounded,
                title: 'report_low_stock_count'.tr(),
                value: '${model.lowStockCount}',
                color: AppDesignTokens.warningColor,
              ),
            ),
            const fw.SizedBox(width: AppDesignTokens.cardGap),
            fw.Expanded(
              child: StatCard(
                animationIndex: 3,
                icon: Icons.remove_shopping_cart_rounded,
                title: 'report_out_of_stock_count'.tr(),
                value: '${model.outOfStockCount}',
                color: AppDesignTokens.dangerColor,
              ),
            ),
          ],
        ),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),
        ReportSectionTitle(
          'report_variants_count'.tr(args: ['${model.variantCount}']),
        ),
      ],
    );
  }
}

class _InventoryItemCard extends fw.StatelessWidget {
  final InventoryStatusItem item;
  const _InventoryItemCard({required this.item});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final showCost = item.costPrice != null && item.costPrice! > 0;

    return AppCard(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Text(
            item.productName ?? 'unknown_product'.tr(),
            style: const fw.TextStyle(
              fontSize: AppDesignTokens.cardTitleFontSize,
              fontWeight: AppDesignTokens.bold,
            ),
          ),
          const fw.SizedBox(height: 4),
          fw.Text(
            '${item.categoryName ?? ''} · ${item.color ?? ''} ${item.size ?? ''}'
                .trim(),
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          fw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (item.isOutOfStock)
                StatusBadge(
                  text: 'out_of_stock'.tr(),
                  type: StatusBadgeType.outOfStock,
                )
              else if (item.isLowStock)
                StatusBadge(
                  text: 'low_stock'.tr(),
                  type: StatusBadgeType.lowStock,
                )
              else
                StatusBadge(
                  text: 'in_stock'.tr(),
                  type: StatusBadgeType.active,
                ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          ReportStatLine(
            label: 'report_stock_quantity'.tr(),
            value: '${item.stockQuantity}',
          ),
          ReportStatLine(
            label: 'price'.tr(),
            value: reportMoney(item.price),
          ),
          ReportStatLine(
            label: 'report_stock_value'.tr(),
            value: reportMoney(item.stockValue),
          ),
          if (showCost)
            ReportStatLine(
              label: 'report_cost_price'.tr(),
              value: reportMoney(item.costPrice!),
            ),
        ],
      ),
    );
  }
}

class _ThresholdStepper extends fw.StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const _ThresholdStepper({required this.value, required this.onChanged});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Padding(
      padding: const fw.EdgeInsets.only(top: 6),
      child: fw.Row(
        mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
        children: [
          fw.Expanded(
            child: fw.Text(
              'report_low_stock_threshold'.tr(),
              style: fw.TextStyle(
                fontSize: AppDesignTokens.bodyFontSize,
                color: theme.colorScheme.foreground,
              ),
            ),
          ),
          IconButton(
            icon: const fw.Icon(Icons.remove, size: 18),
            variance: ButtonVariance.secondary,
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
          ),
          fw.Padding(
            padding: const fw.EdgeInsets.symmetric(horizontal: 12),
            child: fw.Text(
              '$value',
              style: const fw.TextStyle(
                fontSize: AppDesignTokens.bodyFontSize,
                fontWeight: AppDesignTokens.bold,
              ),
            ),
          ),
          IconButton(
            icon: const fw.Icon(Icons.add, size: 18),
            variance: ButtonVariance.secondary,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}
