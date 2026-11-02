import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';

import '../../product/data/model/product_model.dart';
import 'bulk_create_variant_screen.dart';
import 'create_product_variant_screen.dart';
import 'generate_variant_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Variant Creation Options Screen
/// Allows admin to choose between 3 methods:
/// 1. Create Single Variant
/// 2. Bulk Create Variants
/// 3. Generate Variants (Auto)
class VariantCreationOptionsScreen extends StatelessWidget {
  final ProductModel? initialProduct;
  const VariantCreationOptionsScreen({super.key, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: ScrollAwayHeader(header: Column(children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => fw.Navigator.of(context).pop(),
                    variance: ButtonVariance.ghost,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'add_product_variants'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (initialProduct != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'step_2_of_2'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'adding_variants_for'.tr(args: ['${initialProduct!.name ?? ''}']),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'choose_creation_method'.tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'select_the_most_suitable_method_for_ad'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Option 1: Create Single Variant
                    _OptionCard(
                      icon: Icons.add_circle_outline,
                      title: 'create_single_variant'.tr(),
                      description:
                          'add_one_variant_at_a_time_with_precise'.tr(),
                      useCaseTitle: 'best_for'.tr(),
                      useCases: [
                        'adding_a_specific_variant_e_g_red_t_sh'.tr(),
                        'when_you_need_full_control_over_each_f'.tr(),
                        'testing_or_adding_individual_items'.tr(),
                      ],
                      buttonText: 'create_single'.tr(),
                      buttonColor: theme.colorScheme.primary,
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                CreateProductVariantScreen(initialProduct: initialProduct),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Option 2: Bulk Create Variants
                    _OptionCard(
                      icon: Icons.list_alt,
                      title: 'bulk_create_variants'.tr(),
                      description:
                          'create_multiple_specific_variants_with'.tr(),
                      useCaseTitle: 'best_for'.tr(),
                      useCases: [
                        'adding_several_variants_with_different'.tr(),
                        'example_red_l_50_qty_blue_m_20_qty_gre'.tr(),
                        'when_you_know_exact_quantity_for_each'.tr(),
                      ],
                      buttonText: 'bulk_create'.tr(),
                      buttonColor: AppDesignTokens.successColor,
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                BulkCreateVariantScreen(initialProduct: initialProduct),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Option 3: Generate Variants
                    _OptionCard(
                      icon: Icons.auto_awesome,
                      title: 'generate_variants_auto'.tr(),
                      description:
                          'automatically_generate_all_color_size'.tr(),
                      useCaseTitle: 'best_for'.tr(),
                      useCases: [
                        'creating_all_combinations_quickly'.tr(),
                        'example_3_colors_4_sizes_12_variants'.tr(),
                        'same_stock_quantity_for_all_variants'.tr(),
                      ],
                      buttonText: 'auto_generate'.tr(),
                      buttonColor: AppDesignTokens.accentSecondaryColor,
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                GenerateVariantScreen(initialProduct: initialProduct),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                  
                  ],
                ),
              ))),
            if (initialProduct != null)
              StickyBottomAction(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        onPressed: () => fw.Navigator.of(context).pop(),
                        child: Text('skip_for_now'.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () => fw.Navigator.of(context).pop(),
                        child: Text('done'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Option Card Widget
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String useCaseTitle;
  final List<String> useCases;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.useCaseTitle,
    required this.useCases,
    required this.buttonText,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return fw.GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon & Title
              Row(
                children: [
                  fw.Container(
                    padding: const fw.EdgeInsets.all(12),
                    decoration: fw.BoxDecoration(
                      color: buttonColor.withValues(alpha: 0.16),
                      borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
                    ),
                    child: Icon(icon, size: 28, color: buttonColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Divider
              fw.Container(
                height: 1,
                color: theme.colorScheme.border.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),

              // Use Cases
              Text(
                useCaseTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...useCases.map((useCase) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fw.Container(
                        margin: const fw.EdgeInsets.only(top: 6),
                        width: 5,
                        height: 5,
                        decoration: fw.BoxDecoration(
                          color: theme.colorScheme.mutedForeground,
                          shape: fw.BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          useCase,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.mutedForeground,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: fw.GestureDetector(
                  onTap: onTap,
                  child: fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: fw.BoxDecoration(
                      color: buttonColor,
                      borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 18, color: AppDesignTokens.onAccentColor),
                        const SizedBox(width: 8),
                        Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppDesignTokens.onAccentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
