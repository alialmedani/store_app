import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'create_category_screen.dart';

/// Category List Screen - Shows all categories with pagination
/// Uses PaginationList widget from boilerplate
class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.border.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          onPressed: () => Navigator.pop(context),
                          variance: ButtonVariance.ghost,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: PaginationList<CategoryModel>(
                    withPagination: true,
                    withRefresh: true,
                    repositoryCallBack: (data) {
                      return context.read<CategoryCubit>().fetchCategoryList(
                        data,
                      );
                    },
                    listBuilder: (list) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final category = list[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CategoryCard(category: category),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // Floating Action Button
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCategoryScreen(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.add, size: 20),
                  child: const Text(
                    'Add Category',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category Card Widget
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = ImageHelper.getCategoryImageUrl(category.id ?? '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.muted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.border.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AuthenticatedImage(
                    imageUrl: imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.muted.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        color: theme.colorScheme.mutedForeground,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            category.name ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: (category.isActive ?? false)
                                ? const Color(0xFF10B981).withOpacity(0.12)
                                : const Color(0xFFEF4444).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (category.isActive ?? false) ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: (category.isActive ?? false)
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (category.description != null &&
              category.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              category.description!,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.mutedForeground,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (category.sizeTypeName != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.straighten,
                  size: 15,
                  color: theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: 6),
                Text(
                  'Size Type: ${category.sizeTypeName}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
