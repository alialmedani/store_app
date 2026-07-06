import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'bulk_create_variant_screen.dart';
import 'create_product_variant_screen.dart';
import 'generate_variant_screen.dart';

/// Variant Creation Options Screen
/// Allows admin to choose between 3 methods:
/// 1. Create Single Variant
/// 2. Bulk Create Variants
/// 3. Generate Variants (Auto)
class VariantCreationOptionsScreen extends StatelessWidget {
  const VariantCreationOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
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
                  const Expanded(
                    child: Text(
                      'Add Product Variants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Creation Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Select the most suitable method for adding product variants',
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
                      title: 'Create Single Variant',
                      description:
                          'Add one variant at a time with precise control over each detail',
                      useCaseTitle: 'Best for:',
                      useCases: [
                        'Adding a specific variant (e.g., Red T-shirt - Size L)',
                        'When you need full control over each field',
                        'Testing or adding individual items',
                      ],
                      buttonText: 'Create Single',
                      buttonColor: theme.colorScheme.primary,
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                const CreateProductVariantScreen(),
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
                      title: 'Bulk Create Variants',
                      description:
                          'Create multiple specific variants with different stock quantities',
                      useCaseTitle: 'Best for:',
                      useCases: [
                        'Adding several variants with different stock levels',
                        'Example: Red L (50 qty), Blue M (20 qty), Green XL (10 qty)',
                        'When you know exact quantity for each variant',
                      ],
                      buttonText: 'Bulk Create',
                      buttonColor: const Color(0xFF10B981),
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                const BulkCreateVariantScreen(),
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
                      title: 'Generate Variants (Auto)',
                      description:
                          'Automatically generate all color-size combinations',
                      useCaseTitle: 'Best for:',
                      useCases: [
                        'Creating all combinations quickly',
                        'Example: 3 colors × 4 sizes = 12 variants',
                        'Same stock quantity for all variants',
                      ],
                      buttonText: 'Auto Generate',
                      buttonColor: const Color(0xFF8B5CF6),
                      onTap: () {
                        fw.Navigator.of(context).push(
                          fw.PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                const GenerateVariantScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                      color: buttonColor.withOpacity(0.1),
                      borderRadius: fw.BorderRadius.circular(12),
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
                color: theme.colorScheme.border.withOpacity(0.3),
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
                      borderRadius: fw.BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
