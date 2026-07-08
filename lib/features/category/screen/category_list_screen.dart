import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'category_details_screen.dart';
import 'create_category_screen.dart';
import 'edit_category_screen.dart';

/// Category List Screen - Shows all categories with pagination
/// Uses PaginationList widget from boilerplate
class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Categories',
              onBack: () => fw.Navigator.pop(context),
              action: fw.GestureDetector(
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateCategoryScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: fw.Container(
                  width: AppDesignTokens.headerActionButtonSize,
                  height: AppDesignTokens.headerActionButtonSize,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(12),
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
            ),
            fw.Expanded(
              child: PaginationList<CategoryModel>(
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
                                ? 'Active'
                                : 'Inactive',
                            type: (category.isActive ?? false)
                                ? StatusBadgeType.active
                                : StatusBadgeType.inactive,
                          ),
                          metaItems: category.sizeTypeName != null
                              ? [
                                  EntityMetaItem(
                                    icon: Icons.straighten,
                                    text: 'Size Type: ${category.sizeTypeName}',
                                  ),
                                ]
                              : null,
                          onTap: () {
                            if (category.id != null) {
                              fw.Navigator.push(
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
                          },
                          onEdit: () {
                            if (category.id != null) {
                              fw.Navigator.push(
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
                          },
                        ),
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
