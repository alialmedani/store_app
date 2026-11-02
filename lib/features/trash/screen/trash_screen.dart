import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../core/results/result.dart';
import '../../../core/ui/dialogs/action_helpers.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../category/cubit/category_cubit.dart';
import '../../category/data/model/category_model.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../../product_variant/cubit/product_variant_cubit.dart';
import '../../product_variant/data/model/product_variant_model.dart';
import 'package:easy_localization/easy_localization.dart';

/// Trash Screen - Soft deleted categories / products / variants that can be
/// restored. Backed by the `deleted-list` and `restore` API endpoints.
class TrashScreen extends fw.StatefulWidget {
  const TrashScreen({super.key});

  @override
  fw.State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends fw.State<TrashScreen> {
  static List<String> get _tabs => ['categories'.tr(), 'products'.tr(), 'variants'.tr()];

  int _tab = 0;
  PaginationCubit? _listCubit;

  void _reload() {
    _listCubit?.getList();
  }

  Future<void> _restore(
    Future<Result<bool>> Function() action,
    String successMessage,
  ) async {
    final ok = await runRemoteAction<bool>(
      action,
      successMessage: successMessage,
    );
    if (ok) _reload();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(
              title: 'deleted_items'.tr(),
              onBack: () => fw.Navigator.pop(context),
            ),
            fw.Padding(
              padding: const fw.EdgeInsets.fromLTRB(
                AppDesignTokens.screenPaddingHorizontal,
                AppDesignTokens.screenPaddingHorizontal,
                AppDesignTokens.screenPaddingHorizontal,
                0,
              ),
              child: fw.Container(
                padding: const fw.EdgeInsets.all(4),
                decoration: fw.BoxDecoration(
                  color: theme.colorScheme.muted.withValues(alpha: 0.3),
                  borderRadius: fw.BorderRadius.circular(12),
                ),
                child: fw.Row(
                  children: [
                    for (var i = 0; i < _tabs.length; i++) ...[
                      if (i > 0) const fw.SizedBox(width: 4),
                      fw.Expanded(
                        child: _tab == i
                            ? PrimaryButton(
                                onPressed: () {},
                                child: Text(_tabs[i]),
                              )
                            : OutlineButton(
                                onPressed: () => setState(() => _tab = i),
                                child: Text(_tabs[i]),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            )]), body: _buildTab(context)),
      ),
    );
  }

  fw.Widget _buildTab(fw.BuildContext context) {
    switch (_tab) {
      case 0:
        final cubit = context.read<CategoryCubit>();
        return PaginationList<CategoryModel>(
          key: const fw.ValueKey('trash-categories'),
          onCubitCreated: (c) => _listCubit = c,
          withPagination: true,
          withRefresh: true,
          repositoryCallBack: (data) => cubit.fetchDeletedCategoryList(data),
          listBuilder: (list) => _buildList<CategoryModel>(
            list,
            title: (item) => item.name ?? 'N/A',
            subtitle: (item) => item.description,
            onRestore: (item) => _restore(
              () => cubit.restoreCategory(item.id ?? ''),
              'category_restored'.tr(),
            ),
          ),
        );
      case 1:
        final cubit = context.read<ProductCubit>();
        return PaginationList<ProductModel>(
          key: const fw.ValueKey('trash-products'),
          onCubitCreated: (c) => _listCubit = c,
          withPagination: true,
          withRefresh: true,
          repositoryCallBack: (data) => cubit.fetchDeletedProductList(data),
          listBuilder: (list) => _buildList<ProductModel>(
            list,
            title: (item) => item.name ?? 'N/A',
            subtitle: (item) => item.description,
            onRestore: (item) => _restore(
              () => cubit.restoreProduct(item.id ?? ''),
              'product_restored'.tr(),
            ),
          ),
        );
      default:
        final cubit = context.read<ProductVariantCubit>();
        return PaginationList<ProductVariantModel>(
          key: const fw.ValueKey('trash-variants'),
          onCubitCreated: (c) => _listCubit = c,
          withPagination: true,
          withRefresh: true,
          repositoryCallBack: (data) =>
              cubit.fetchDeletedProductVariantList(data),
          listBuilder: (list) => _buildList<ProductVariantModel>(
            list,
            title: (item) => item.productName ?? 'N/A',
            subtitle: (item) => '${item.color ?? ''} / ${item.size ?? ''}',
            onRestore: (item) => _restore(
              () => cubit.restoreProductVariant(item.id ?? ''),
              'variant_restored'.tr(),
            ),
          ),
        );
    }
  }

  fw.Widget _buildList<T>(
    List<T> list, {
    required String Function(T item) title,
    required String? Function(T item) subtitle,
    required Future<void> Function(T item) onRestore,
  }) {
    final theme = Theme.of(context);

    return fw.ListView.builder(
      padding: const fw.EdgeInsets.all(AppDesignTokens.screenPaddingHorizontal),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final sub = subtitle(item);
        return fw.Padding(
          padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
          child: AppCard(
            child: fw.Row(
              children: [
                fw.Expanded(
                  child: fw.Column(
                    crossAxisAlignment: fw.CrossAxisAlignment.start,
                    children: [
                      Text(
                        title(item),
                        style: const fw.TextStyle(
                          fontSize: AppDesignTokens.cardTitleFontSize,
                          fontWeight: AppDesignTokens.bold,
                        ),
                      ),
                      if (sub != null && sub.trim().isNotEmpty) ...[
                        const fw.SizedBox(height: 4),
                        Text(
                          sub,
                          maxLines: 2,
                          style: fw.TextStyle(
                            fontSize: AppDesignTokens.captionFontSize,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const fw.SizedBox(width: 12),
                OutlineButton(
                  onPressed: () => onRestore(item),
                  child: Text('restore'.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
