import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:store/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:store/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/reports_cubit.dart';
import '../data/model/top_sellers_model.dart';
import 'widgets/report_widgets.dart';

/// Top / Bottom Sellers report.
class TopSellersScreen extends fw.StatefulWidget {
  const TopSellersScreen({super.key});

  @override
  fw.State<TopSellersScreen> createState() => _TopSellersScreenState();
}

class _TopSellersScreenState extends fw.State<TopSellersScreen> {
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
              title: 'report_top_sellers'.tr(),
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
                        from: reports.topFrom,
                        to: reports.topTo,
                        onChanged: (f, t) {
                          reports.setTopRange(f, t);
                          _reload();
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      fw.Row(
                        children: [
                          fw.Expanded(
                            child: _SegButton(
                              label: 'report_direction_top'.tr(),
                              active: reports.topDirection == 1,
                              onTap: () {
                                reports.setTopDirection(1);
                                _reload();
                              },
                            ),
                          ),
                          const fw.SizedBox(width: 8),
                          fw.Expanded(
                            child: _SegButton(
                              label: 'report_direction_bottom'.tr(),
                              active: reports.topDirection == 2,
                              onTap: () {
                                reports.setTopDirection(2);
                                _reload();
                              },
                            ),
                          ),
                        ],
                      ),
                      const fw.SizedBox(height: AppDesignTokens.cardGap),
                      _ToggleRow(
                        label: 'report_group_by_variant'.tr(),
                        value: reports.topGroupByVariant,
                        onChanged: (v) {
                          reports.setTopGroupByVariant(v);
                          _reload();
                        },
                      ),
                      _ToggleRow(
                        label: 'report_include_deleted'.tr(),
                        value: reports.topIncludeDeleted,
                        onChanged: (v) {
                          reports.setTopIncludeDeleted(v);
                          _reload();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            fw.Expanded(
              child: GetModel<TopSellersModel>(
                onCubitCreated: (c) => _modelCubit = c,
                useCaseCallBack: () =>
                    context.read<ReportsCubit>().getTopSellers(),
                modelBuilder: (model) => _TopSellersBody(model: model),
                loading: const _TopSellersSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSellersBody extends fw.StatelessWidget {
  final TopSellersModel model;
  const _TopSellersBody({required this.model});

  @override
  fw.Widget build(fw.BuildContext context) {
    if (model.items.isEmpty) {
      return EmptyState(
        icon: Icons.leaderboard_outlined,
        title: 'report_no_data_title'.tr(),
        subtitle: 'report_no_data_message'.tr(),
      );
    }
    return fw.ListView.builder(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      itemCount: model.items.length,
      itemBuilder: (context, index) {
        final item = model.items[index];
        final deleted = item.isProductDeleted || item.isVariantDeleted;
        final theme = Theme.of(context);
        final variantInfo = [item.color, item.size]
            .where((e) => e != null && e.isNotEmpty)
            .join(' / ');
        return fw.Padding(
          padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
          child: AppCard(
            child: fw.Row(
              children: [
                fw.Container(
                  width: 34,
                  height: 34,
                  alignment: fw.Alignment.center,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.primarySoftColor,
                    borderRadius: fw.BorderRadius.circular(10),
                  ),
                  child: fw.Text(
                    '${index + 1}',
                    style: fw.TextStyle(
                      fontWeight: AppDesignTokens.bold,
                      color: AppDesignTokens.primaryColor,
                    ),
                  ),
                ),
                const fw.SizedBox(width: 12),
                fw.Expanded(
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
                      if (variantInfo.isNotEmpty)
                        fw.Text(
                          variantInfo,
                          style: fw.TextStyle(
                            fontSize: AppDesignTokens.captionFontSize,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      const fw.SizedBox(height: 4),
                      fw.Text(
                        'report_qty_sold'.tr(args: ['${item.quantitySold}']),
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.captionFontSize,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const fw.SizedBox(width: 8),
                fw.Text(
                  reportMoney(item.revenue),
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.cardTitleFontSize,
                    fontWeight: AppDesignTokens.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton matching the flat ranked rows of [_TopSellersBody]:
/// a small rank badge, title/subtitle/qty lines, and a trailing revenue chip.
class _TopSellersSkeleton extends fw.StatelessWidget {
  const _TopSellersSkeleton();

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView.builder(
      physics: const fw.NeverScrollableScrollPhysics(),
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      itemCount: 6,
      itemBuilder: (context, i) => fw.Padding(
        padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
        child: AppCard(
          child: fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: const [
              // Calm silhouette: rank box + a title line and a subtitle line.
              AppSkeletonBox(width: 34, height: 34, borderRadius: 10),
              fw.SizedBox(width: 12),
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    AppSkeletonBox(width: 150, height: 15),
                    fw.SizedBox(height: 8),
                    AppSkeletonBox(width: 90, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegButton extends fw.StatelessWidget {
  final String label;
  final bool active;
  final fw.VoidCallback onTap;

  const _SegButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return PressScale(
      onTap: onTap,
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(vertical: 11),
        alignment: fw.Alignment.center,
        decoration: fw.BoxDecoration(
          gradient: active ? AppDesignTokens.primaryGradient : null,
          color: active ? null : theme.colorScheme.card,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
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
    );
  }
}

class _ToggleRow extends fw.StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleRow({
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
