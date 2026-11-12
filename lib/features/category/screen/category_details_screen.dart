import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/ui/dialogs/action_helpers.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/ui/widgets/image_viewer.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'edit_category_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';

/// Category Details Screen - Shows complete category information
class CategoryDetailsScreen extends fw.StatelessWidget {
  final String categoryId;

  const CategoryDetailsScreen({super.key, required this.categoryId});

  @override
  fw.Widget build(fw.BuildContext context) {
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

              return ScrollAwayHeader(header: fw.Column(children: [
                  AppHeader(
                    title: 'category_details'.tr(),
                    action: fw.Row(
                      mainAxisSize: fw.MainAxisSize.min,
                      children: [
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => showConfirmDialog(
                            context,
                            title: 'delete_category'.tr(),
                            message: 'delete_it_can_be_restored_later_from_d'.tr(args: ['${category.name ?? 'this category'}']),
                            confirmLabel: 'delete'.tr(),
                            destructive: true,
                            onConfirm: () async {
                              final deleted = await runRemoteAction(
                                () => context.read<CategoryCubit>().deleteCategory(
                                  categoryId,
                                ),
                                successMessage: 'category_deleted'.tr(),
                              );
                              if (deleted && context.mounted) {
                                fw.Navigator.of(context).pop(true);
                              }
                            },
                          ),
                          variance: ButtonVariance.ghost,
                        ),
                        // Edit Button
                        IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () async {
                              await fw.Navigator.push(
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
                              if (context.mounted) {
                                context
                                    .read<CategoryCubit>()
                                    .getCategoryDetails(categoryId);
                              }
                            },
                            variance: ButtonVariance.ghost,
                          ),
                      ],
                    ),
                  )]), body: fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(
                        AppDesignTokens.cardPaddingLarge,
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Hero image
                          fw.GestureDetector(
                            onTap: () => showImageViewer(context, imageUrl),
                            child: fw.Container(
                            width: double.infinity,
                            height: 260,
                            decoration: fw.BoxDecoration(
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              boxShadow: AppDesignTokens.glowShadow,
                            ),
                            child: fw.ClipRRect(
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              child: fw.Stack(
                                fit: fw.StackFit.expand,
                                children: [
                                  fw.DecoratedBox(
                                    decoration: const fw.BoxDecoration(
                                      gradient: AppDesignTokens.primaryGradient,
                                    ),
                                    child: fw.Center(
                                      child: fw.Icon(
                                        Icons.category_rounded,
                                        size: 72,
                                        color: const fw.Color(0xFFFFFFFF)
                                            .withValues(alpha: 0.25),
                                      ),
                                    ),
                                  ),
                                  AuthenticatedImage(
                                    imageUrl: imageUrl,
                                    width: double.infinity,
                                    height: 260,
                                    fit: fw.BoxFit.cover,
                                    errorWidget: const fw.SizedBox.shrink(),
                                  ),
                                  fw.DecoratedBox(
                                    decoration: fw.BoxDecoration(
                                      gradient: fw.LinearGradient(
                                        begin: fw.Alignment.center,
                                        end: fw.Alignment.bottomCenter,
                                        colors: [
                                          const fw.Color(0x00000000),
                                          const fw.Color(0xFF0B0D24)
                                              .withValues(alpha: 0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  fw.Positioned(
                                    left: 18,
                                    right: 18,
                                    bottom: 16,
                                    child: fw.Text(
                                      category.name ?? 'N/A',
                                      maxLines: 2,
                                      overflow: fw.TextOverflow.ellipsis,
                                      style: const fw.TextStyle(
                                        fontSize: 24,
                                        fontWeight: fw.FontWeight.w800,
                                        letterSpacing: -0.4,
                                        color: fw.Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const fw.SizedBox(height: AppDesignTokens.cardGap),

                          fw.IntrinsicHeight(
                            child: fw.Row(
                              crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                              children: [
                                fw.Expanded(
                                  child: AppStatTile(
                                    label: 'status'.tr(),
                                    value: category.isActive == true
                                        ? 'active'.tr()
                                        : 'inactive'.tr(),
                                    icon: category.isActive == true
                                        ? Icons.check_circle_rounded
                                        : Icons.pause_circle_rounded,
                                    highlight: true,
                                  ),
                                ),
                                const fw.SizedBox(width: AppDesignTokens.itemGap),
                                fw.Expanded(
                                  child: AppStatTile(
                                    label: 'size_type'.tr(),
                                    value: category.sizeTypeName ?? 'N/A',
                                    icon: Icons.straighten_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),

                          if (category.description != null &&
                              category.description!.isNotEmpty) ...[
                            AppSectionTitle('description'.tr()),
                            const fw.SizedBox(height: AppDesignTokens.itemGap),
                            AppCard(
                              elevated: true,
                              child: Text(
                                category.description!,
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize + 0.5,
                                  height: 1.65,
                                  color: AppDesignTokens.titleTextColor
                                      .withValues(alpha: 0.88),
                                ),
                              ),
                            ),
                            const fw.SizedBox(height: AppDesignTokens.sectionGap),
                          ],

                          AppSectionTitle('details'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),
                          AppInfoSection(
                            children: [
                              AppInfoRow(
                                icon: Icons.tag_rounded,
                                label: 'size_type_id'.tr(),
                                value: category.sizeTypeId?.toString() ?? 'N/A',
                              ),
                              if (category.creationTime != null)
                                AppInfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'created'.tr(),
                                  value: _formatDate(category.creationTime!),
                                ),
                              if (category.lastModificationTime != null)
                                AppInfoRow(
                                  icon: Icons.update_rounded,
                                  label: 'last_modified'.tr(),
                                  value: _formatDate(category.lastModificationTime!),
                                ),
                            ],
                          ),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),
                        ],
                      ),
                    ));
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
