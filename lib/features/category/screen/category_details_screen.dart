import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'edit_category_screen.dart';

/// Category Details Screen - Shows complete category information
class CategoryDetailsScreen extends fw.StatelessWidget {
  final String categoryId;

  const CategoryDetailsScreen({super.key, required this.categoryId});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => CategoryCubit(),
      child: Scaffold(
        child: SafeArea(
          child: GetModel<CategoryModel>(
            useCaseCallBack: () =>
                context.read<CategoryCubit>().getCategoryDetails(categoryId),
            modelBuilder: (category) {
              final imageUrl = ImageHelper.getCategoryImageUrl(
                category.id ?? '',
              );

              return fw.Column(
                children: [
                  // App Bar
                  Container(
                    padding: const fw.EdgeInsets.fromLTRB(16, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.border.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: fw.Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted.withOpacity(0.3),
                            borderRadius: fw.BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            onPressed: () => fw.Navigator.of(context).pop(),
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                        const fw.SizedBox(width: 12),
                        const fw.Expanded(
                          child: Text(
                            'Category Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Edit Button
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            borderRadius: fw.BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              fw.Navigator.push(
                                context,
                                fw.PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => BlocProvider(
                                    create: (_) => CategoryCubit(),
                                    child: EditCategoryScreen(
                                      categoryId: categoryId,
                                    ),
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  fw.Expanded(
                    child: fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(20),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Category Image
                          Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withOpacity(0.3),
                              borderRadius: fw.BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.border.withOpacity(
                                  0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.ClipRRect(
                              borderRadius: fw.BorderRadius.circular(20),
                              child: AuthenticatedImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 280,
                                fit: fw.BoxFit.cover,
                                errorWidget: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.muted.withOpacity(
                                      0.3,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.category_outlined,
                                    color: theme.colorScheme.mutedForeground,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 24),

                          // Category Name
                          Text(
                            category.name ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const fw.SizedBox(height: 12),

                          // Status & Size Type Row
                          fw.Row(
                            children: [
                              fw.Expanded(
                                child: Container(
                                  padding: const fw.EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: category.isActive == true
                                        ? theme.colorScheme.primary.withOpacity(
                                            0.1,
                                          )
                                        : theme.colorScheme.muted.withOpacity(
                                            0.3,
                                          ),
                                    borderRadius: fw.BorderRadius.circular(12),
                                    border: Border.all(
                                      color: category.isActive == true
                                          ? theme.colorScheme.primary
                                                .withOpacity(0.3)
                                          : theme.colorScheme.border
                                                .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Column(
                                    crossAxisAlignment:
                                        fw.CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                      const fw.SizedBox(height: 4),
                                      Text(
                                        category.isActive == true
                                            ? 'Active'
                                            : 'Inactive',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: category.isActive == true
                                              ? theme.colorScheme.primary
                                              : theme
                                                    .colorScheme
                                                    .mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const fw.SizedBox(width: 12),
                              fw.Expanded(
                                child: Container(
                                  padding: const fw.EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.1),
                                    borderRadius: fw.BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Column(
                                    crossAxisAlignment:
                                        fw.CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Size Type',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                      const fw.SizedBox(height: 4),
                                      Text(
                                        category.sizeTypeName ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.foreground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 24),

                          // Description Section
                          if (category.description != null &&
                              category.description!.isNotEmpty) ...[
                            Text(
                              'Description',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const fw.SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.card,
                                borderRadius: fw.BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.border.withOpacity(
                                    0.5,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                category.description!,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                            ),
                            const fw.SizedBox(height: 24),
                          ],

                          // Details Section
                          Text(
                            'Details',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const fw.SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.card,
                              borderRadius: fw.BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.border.withOpacity(
                                  0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.Column(
                              children: [
                                _DetailRow(
                                  label: 'Size Type ID',
                                  value:
                                      category.sizeTypeId?.toString() ?? 'N/A',
                                  theme: theme,
                                ),
                                if (category.creationTime != null) ...[
                                  const fw.SizedBox(height: 16),
                                  _DetailRow(
                                    label: 'Created',
                                    value: _formatDate(category.creationTime!),
                                    theme: theme,
                                  ),
                                ],
                                if (category.lastModificationTime != null) ...[
                                  const fw.SizedBox(height: 16),
                                  _DetailRow(
                                    label: 'Last Modified',
                                    value: _formatDate(
                                      category.lastModificationTime!,
                                    ),
                                    theme: theme,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends fw.StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        fw.Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ),
        fw.Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
