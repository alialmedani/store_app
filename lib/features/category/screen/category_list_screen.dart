import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;
import '../../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'category_details_screen.dart';
import 'create_category_screen.dart';
import 'edit_category_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Category List Screen - Shows all categories with pagination
/// Uses PaginationList widget from boilerplate
class CategoryListScreen extends fw.StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  fw.State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends fw.State<CategoryListScreen> {
  PaginationCubit? _listCubit;

  /// Reload the first page (after returning from details / edit / create)
  void _reloadList() {
    _listCubit?.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(
              title: 'categories'.tr(),
              onBack: () => fw.Navigator.pop(context),
              action: fw.GestureDetector(
                onTap: () async {
                  await fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateCategoryScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  _reloadList();
                },
                child: fw.Container(
                  width: AppDesignTokens.headerActionButtonSize,
                  height: AppDesignTokens.headerActionButtonSize,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
                  ),
                  child: fw.Center(
                    child: fw.Icon(
                      Icons.add,
                      size: 20,
                      color: Theme.of(context).colorScheme.foreground,
                    ),
                  ),
                ),
              ),
            )]), body: PaginationList<CategoryModel>(
                onCubitCreated: (cubit) => _listCubit = cubit,
                withPagination: true,
                withRefresh: true,
                loadingWidget: fw.ListView.builder(
                  padding: const fw.EdgeInsets.fromLTRB(
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const fw.Padding(
                      padding: fw.EdgeInsets.only(
                        bottom: AppDesignTokens.cardGap,
                      ),
                      child: CategoryCardSkeleton(),
                    );
                  },
                ),
                noDataWidget: EmptyState(
                  icon: Icons.category_outlined,
                  title: 'categories_empty_title'.tr(),
                  subtitle: 'categories_empty_subtitle'.tr(),
                ),
                repositoryCallBack: (data) {
                  return context.read<CategoryCubit>().fetchCategoryList(data);
                },
                listBuilder: (list) {
                  return fw.ListView.builder(
                    padding: const fw.EdgeInsets.fromLTRB(
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final category = list[index];
                      final imageUrl = ImageHelper.getCategoryImageUrl(
                        category.id ?? '',
                      );

                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(
                          bottom: AppDesignTokens.cardGap,
                        ),
                        child: EntityListCard(
                          animationIndex: index,
                          title: category.name ?? 'N/A',
                          description: category.description,
                          image: AuthenticatedImage(
                            imageUrl: imageUrl,
                            width: 80,
                            height: 80,
                            fit: fw.BoxFit.cover,
                            errorWidget: fw.Center(
                              child: fw.Icon(Icons.category_outlined, size: 32),
                            ),
                          ),
                          statusBadge: StatusBadge(
                            text: (category.isActive ?? false)
                                ? 'active'.tr()
                                : 'inactive'.tr(),
                            type: (category.isActive ?? false)
                                ? StatusBadgeType.active
                                : StatusBadgeType.inactive,
                          ),
                          metaItems: category.sizeTypeName != null
                              ? [
                                  EntityMetaItem(
                                    icon: Icons.straighten,
                                    text: 'size_type_2'.tr(args: ['${category.sizeTypeName}']),
                                  ),
                                ]
                              : null,
                          onTap: () async {
                            if (category.id != null) {
                              await fw.Navigator.push(
                                context,
                                fw.PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      CategoryDetailsScreen(
                                        categoryId: category.id!,
                                      ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            }
                            _reloadList();
                          },
                          onEdit: () async {
                            if (category.id != null) {
                              await fw.Navigator.push(
                                context,
                                fw.PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => BlocProvider(
                                    create: (_) => CategoryCubit(),
                                    child: EditCategoryScreen(
                                      categoryId: category.id!,
                                    ),
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            }
                            _reloadList();
                          },
                        ),
                      );
                    },
                  );
                },
              )),
      ),
    );
  }
}
