import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:store/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/stock_movement_report_model.dart';
import 'widgets/report_widgets.dart';

/// Stock Movement Audit report (PAGED, like other list screens).
class StockMovementsReportScreen extends fw.StatefulWidget {
  const StockMovementsReportScreen({super.key});

  @override
  fw.State<StockMovementsReportScreen> createState() =>
      _StockMovementsReportScreenState();
}

class _StockMovementsReportScreenState
    extends fw.State<StockMovementsReportScreen> {
  PaginationCubit? _listCubit;

  void _reload() => _listCubit?.getList();

  @override
  fw.Widget build(fw.BuildContext context) {
    final reports = context.read<ReportsCubit>();

    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            AppHeader(
              title: 'report_stock_movements'.tr(),
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
                      _MovementTypeFilter(
                        selected: reports.movementsType,
                        onChanged: (t) {
                          reports.setMovementsType(t);
                          _reload();
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      ReportToggleRow(
                        label: 'report_include_deleted'.tr(),
                        value: reports.movementsIncludeDeleted,
                        onChanged: (v) {
                          reports.setMovementsIncludeDeleted(v);
                          _reload();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            fw.Expanded(
              child: PaginationList<StockMovementReportModel>(
                onCubitCreated: (cubit) => _listCubit = cubit,
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) =>
                    context.read<ReportsCubit>().fetchStockMovements(data),
                listBuilder: (list) {
                  return fw.ListView.builder(
                    padding: const fw.EdgeInsets.fromLTRB(
                      AppDesignTokens.screenPaddingHorizontal,
                      0,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.sectionGap,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(
                          bottom: AppDesignTokens.cardGap,
                        ),
                        child: _MovementCard(movement: list[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementCard extends fw.StatelessWidget {
  final StockMovementReportModel movement;
  const _MovementCard({required this.movement});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final deleted = movement.isProductDeleted || movement.isVariantDeleted;
    final positive = movement.change >= 0;

    return AppCard(
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
                    fw.Row(
                      children: [
                        fw.Flexible(
                          child: fw.Text(
                            movement.productVariantName ??
                                'unknown_product'.tr(),
                            maxLines: 1,
                            overflow: fw.TextOverflow.ellipsis,
                            style: const fw.TextStyle(
                              fontSize: AppDesignTokens.cardTitleFontSize,
                              fontWeight: AppDesignTokens.semiBold,
                            ),
                          ),
                        ),
                        if (deleted) ...[
                          const fw.SizedBox(width: 8),
                          const DiscontinuedChip(),
                        ],
                      ],
                    ),
                    if (movement.date != null)
                      fw.Text(
                        DateFormat('MMM d, y · HH:mm').format(movement.date!),
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.captionFontSize,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
              fw.Text(
                '${positive ? '+' : ''}${movement.change}',
                style: fw.TextStyle(
                  fontSize: AppDesignTokens.largeTitleFontSize,
                  fontWeight: AppDesignTokens.bold,
                  color: positive
                      ? AppDesignTokens.successColor
                      : AppDesignTokens.dangerColor,
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          fw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                text: movementTypeLabel(movement.reason?.id),
                type: StatusBadgeType.info,
              ),
              if (movement.sourceType != null)
                StatusBadge(
                  text: sourceTypeLabel(movement.sourceType?.id),
                  type: StatusBadgeType.draft,
                ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          ReportStatLine(
            label: 'report_quantity_change'.tr(),
            value: '${movement.oldQuantity} → ${movement.newQuantity}',
          ),
          if (movement.note != null && movement.note!.isNotEmpty)
            ReportStatLine(
              label: 'note'.tr(),
              value: movement.note!,
            ),
        ],
      ),
    );
  }
}

class _MovementTypeFilter extends fw.StatelessWidget {
  final int? selected;
  final void Function(int?) onChanged;

  const _MovementTypeFilter({required this.selected, required this.onChanged});

  @override
  fw.Widget build(fw.BuildContext context) {
    final entries = <int?, String>{
      null: 'all'.tr(),
      1: 'report_movement_increase'.tr(),
      2: 'report_movement_decrease'.tr(),
      3: 'report_movement_adjustment'.tr(),
      4: 'report_movement_sale'.tr(),
      5: 'report_movement_order_cancellation'.tr(),
      6: 'report_movement_return'.tr(),
      7: 'report_movement_opening_stock'.tr(),
    };

    return fw.SizedBox(
      height: 38,
      child: fw.ListView(
        scrollDirection: fw.Axis.horizontal,
        children: [
          for (final entry in entries.entries)
            fw.Padding(
              padding: const fw.EdgeInsets.only(right: 8),
              child: _chip(context, entry.key, entry.value),
            ),
        ],
      ),
    );
  }

  fw.Widget _chip(fw.BuildContext context, int? value, String label) {
    final theme = Theme.of(context);
    final active = selected == value;
    return PressScale(
      onTap: () => onChanged(value),
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        alignment: fw.Alignment.center,
        decoration: fw.BoxDecoration(
          gradient: active ? AppDesignTokens.primaryGradient : null,
          color: active ? null : theme.colorScheme.card,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
          border: fw.Border.all(
            color: active
                ? AppDesignTokens.primaryColor
                : AppDesignTokens.glassBorder,
          ),
        ),
        child: fw.Text(
          label,
          style: fw.TextStyle(
            fontSize: AppDesignTokens.captionFontSize,
            fontWeight: AppDesignTokens.semiBold,
            color: active
                ? AppDesignTokens.onAccentColor
                : theme.colorScheme.foreground,
          ),
        ),
      ),
    );
  }
}
