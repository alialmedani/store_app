import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:intl/intl.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../cubit/inventory_cubit.dart';
import '../data/model/inventory_model.dart';

/// Inventory List Screen - Premium inventory movements tracking
/// Shows all stock movements with beautiful, modern design
class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Inventory',
              onBack: () => fw.Navigator.pop(context),
            ),
            fw.Expanded(
              child: PaginationList<InventoryModel>(
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) {
                  return context.read<InventoryCubit>().fetchInventoryList(
                    data,
                  );
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
                      final inventory = list[index];
                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(bottom: 16),
                        child: _InventoryCard(inventory: inventory),
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

  fw.Widget _buildEmptyState(ThemeData theme) {
    return fw.Center(
      child: fw.Padding(
        padding: const fw.EdgeInsets.all(48),
        child: fw.Column(
          mainAxisAlignment: fw.MainAxisAlignment.center,
          children: [
            fw.Container(
              padding: const fw.EdgeInsets.all(24),
              decoration: fw.BoxDecoration(
                gradient: fw.LinearGradient(
                  begin: fw.Alignment.topLeft,
                  end: fw.Alignment.bottomRight,
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.1),
                    const Color(0xFFEC4899).withOpacity(0.05),
                  ],
                ),
                borderRadius: fw.BorderRadius.circular(20),
                border: fw.Border.all(
                  color: const Color(0xFFEC4899).withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: const fw.Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Color(0xFFEC4899),
              ),
            ),
            const fw.SizedBox(height: 24),
            const fw.Text(
              'No Inventory Movements',
              style: fw.TextStyle(
                fontSize: 20,
                fontWeight: fw.FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const fw.SizedBox(height: 8),
            fw.Text(
              'Stock movements will appear here when\nproducts are added, sold, or adjusted',
              textAlign: fw.TextAlign.center,
              style: fw.TextStyle(
                fontSize: 14,
                color: theme.colorScheme.mutedForeground,
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium Inventory Card Widget
class _InventoryCard extends StatelessWidget {
  final InventoryModel inventory;

  const _InventoryCard({required this.inventory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine movement type styling
    final movementStyle = _getMovementStyle(inventory.movementType?.id);

    return Card(
      child: fw.Container(
        decoration: fw.BoxDecoration(
          borderRadius: fw.BorderRadius.circular(12),
          gradient: fw.LinearGradient(
            begin: fw.Alignment.topLeft,
            end: fw.Alignment.bottomRight,
            colors: [
              theme.colorScheme.card,
              theme.colorScheme.card.withOpacity(0.98),
            ],
          ),
          border: fw.Border.all(
            color: movementStyle.color.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: fw.Padding(
          padding: const fw.EdgeInsets.all(20),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              // Header: Product Info & Movement Badge
              fw.Row(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: [
                  // Icon Container
                  fw.Container(
                    padding: const fw.EdgeInsets.all(12),
                    decoration: fw.BoxDecoration(
                      gradient: fw.LinearGradient(
                        begin: fw.Alignment.topLeft,
                        end: fw.Alignment.bottomRight,
                        colors: [
                          movementStyle.color.withOpacity(0.15),
                          movementStyle.color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: fw.BorderRadius.circular(12),
                      border: fw.Border.all(
                        color: movementStyle.color.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: fw.Icon(
                      movementStyle.icon,
                      size: 24,
                      color: movementStyle.color,
                    ),
                  ),
                  const fw.SizedBox(width: 14),
                  // Product Details
                  fw.Expanded(
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        fw.Text(
                          inventory.productName ?? 'Unknown Product',
                          style: const fw.TextStyle(
                            fontSize: 17,
                            fontWeight: fw.FontWeight.w700,
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                        ),
                        if (inventory.color != null ||
                            inventory.size != null) ...[
                          const fw.SizedBox(height: 6),
                          fw.Row(
                            children: [
                              if (inventory.color != null) ...[
                                fw.Container(
                                  padding: const fw.EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: fw.BoxDecoration(
                                    color: theme.colorScheme.muted.withOpacity(
                                      0.4,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(6),
                                  ),
                                  child: fw.Text(
                                    inventory.color!,
                                    style: fw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: fw.FontWeight.w600,
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                ),
                                if (inventory.size != null)
                                  const fw.SizedBox(width: 6),
                              ],
                              if (inventory.size != null)
                                fw.Container(
                                  padding: const fw.EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: fw.BoxDecoration(
                                    color: theme.colorScheme.muted.withOpacity(
                                      0.4,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(6),
                                  ),
                                  child: fw.Text(
                                    inventory.size!,
                                    style: fw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: fw.FontWeight.w600,
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const fw.SizedBox(width: 12),
                  // Movement Type Badge
                  if (inventory.movementType?.name != null)
                    fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: fw.BoxDecoration(
                        gradient: fw.LinearGradient(
                          begin: fw.Alignment.topLeft,
                          end: fw.Alignment.bottomRight,
                          colors: [
                            movementStyle.color.withOpacity(0.15),
                            movementStyle.color.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: fw.BorderRadius.circular(8),
                        border: fw.Border.all(
                          color: movementStyle.color.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: fw.Text(
                        inventory.movementType!.name!,
                        style: fw.TextStyle(
                          fontSize: 12,
                          fontWeight: fw.FontWeight.w700,
                          color: movementStyle.color,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                ],
              ),

              const fw.SizedBox(height: 18),

              // Category Badge
              if (inventory.categoryName != null) ...[
                fw.Row(
                  children: [
                    fw.Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: theme.colorScheme.mutedForeground.withOpacity(0.7),
                    ),
                    const fw.SizedBox(width: 6),
                    fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.12),
                        borderRadius: fw.BorderRadius.circular(6),
                        border: fw.Border.all(
                          color: theme.colorScheme.secondary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: fw.Text(
                        inventory.categoryName!,
                        style: fw.TextStyle(
                          fontSize: 12,
                          fontWeight: fw.FontWeight.w600,
                          color: theme.colorScheme.secondaryForeground,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const fw.SizedBox(height: 18),
              ],

              // Divider
              fw.Container(
                height: 1,
                decoration: fw.BoxDecoration(
                  gradient: fw.LinearGradient(
                    colors: [
                      theme.colorScheme.border.withOpacity(0.0),
                      theme.colorScheme.border.withOpacity(0.15),
                      theme.colorScheme.border.withOpacity(0.0),
                    ],
                  ),
                ),
              ),

              const fw.SizedBox(height: 18),

              // Quantity Stats Row
              fw.Row(
                children: [
                  // Quantity Change
                  fw.Expanded(
                    child: fw.Container(
                      padding: const fw.EdgeInsets.all(14),
                      decoration: fw.BoxDecoration(
                        gradient: fw.LinearGradient(
                          begin: fw.Alignment.topLeft,
                          end: fw.Alignment.bottomRight,
                          colors: [
                            movementStyle.color.withOpacity(0.08),
                            movementStyle.color.withOpacity(0.04),
                          ],
                        ),
                        borderRadius: fw.BorderRadius.circular(10),
                        border: fw.Border.all(
                          color: movementStyle.color.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          fw.Row(
                            children: [
                              fw.Icon(
                                movementStyle.quantityIcon,
                                size: 16,
                                color: movementStyle.color,
                              ),
                              const fw.SizedBox(width: 6),
                              fw.Text(
                                'Change',
                                style: fw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: fw.FontWeight.w600,
                                  color: theme.colorScheme.mutedForeground,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 6),
                          fw.Text(
                            '${movementStyle.prefix}${inventory.quantityChange ?? 0}',
                            style: fw.TextStyle(
                              fontSize: 24,
                              fontWeight: fw.FontWeight.w800,
                              color: movementStyle.color,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const fw.SizedBox(width: 12),
                  // Current Stock
                  fw.Expanded(
                    child: fw.Container(
                      padding: const fw.EdgeInsets.all(14),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withOpacity(0.3),
                        borderRadius: fw.BorderRadius.circular(10),
                        border: fw.Border.all(
                          color: theme.colorScheme.border.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          fw.Row(
                            children: [
                              fw.Icon(
                                Icons.inventory_outlined,
                                size: 16,
                                color: theme.colorScheme.mutedForeground,
                              ),
                              const fw.SizedBox(width: 6),
                              fw.Text(
                                'Stock',
                                style: fw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: fw.FontWeight.w600,
                                  color: theme.colorScheme.mutedForeground,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 6),
                          fw.Text(
                            '${inventory.currentStockQuantity ?? 0}',
                            style: const fw.TextStyle(
                              fontSize: 24,
                              fontWeight: fw.FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const fw.SizedBox(height: 16),

              // Metadata Row
              fw.Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  if (inventory.sourceType?.name != null)
                    _buildMetaItem(
                      theme,
                      Icons.source_outlined,
                      inventory.sourceType!.name!,
                    ),
                  _buildMetaItem(
                    theme,
                    Icons.access_time_outlined,
                    inventory.creationTime != null
                        ? DateFormat(
                            'MMM dd, yyyy • HH:mm',
                          ).format(inventory.creationTime!)
                        : 'N/A',
                  ),
                ],
              ),

              // Note Section
              if (inventory.note != null && inventory.note!.isNotEmpty) ...[
                const fw.SizedBox(height: 16),
                fw.Container(
                  padding: const fw.EdgeInsets.all(12),
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.muted.withOpacity(0.25),
                    borderRadius: fw.BorderRadius.circular(10),
                    border: fw.Border.all(
                      color: theme.colorScheme.border.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: fw.Row(
                    crossAxisAlignment: fw.CrossAxisAlignment.start,
                    children: [
                      fw.Icon(
                        Icons.note_outlined,
                        size: 16,
                        color: theme.colorScheme.mutedForeground.withOpacity(
                          0.7,
                        ),
                      ),
                      const fw.SizedBox(width: 10),
                      fw.Expanded(
                        child: fw.Text(
                          inventory.note!,
                          style: fw.TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.mutedForeground,
                            height: 1.5,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  fw.Widget _buildMetaItem(ThemeData theme, fw.IconData icon, String text) {
    return fw.Row(
      mainAxisSize: fw.MainAxisSize.min,
      children: [
        fw.Icon(
          icon,
          size: 15,
          color: theme.colorScheme.mutedForeground.withOpacity(0.7),
        ),
        const fw.SizedBox(width: 6),
        fw.Text(
          text,
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w500,
            color: theme.colorScheme.mutedForeground,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  _MovementStyle _getMovementStyle(int? typeId) {
    switch (typeId) {
      case 1: // In
        return _MovementStyle(
          color: const Color(0xFF10B981),
          icon: Icons.arrow_circle_down_rounded,
          quantityIcon: Icons.add_circle_outline,
          prefix: '+',
        );
      case 2: // Out
        return _MovementStyle(
          color: const Color(0xFFEF4444),
          icon: Icons.arrow_circle_up_rounded,
          quantityIcon: Icons.remove_circle_outline,
          prefix: '-',
        );
      default: // Adjustment
        return _MovementStyle(
          color: const Color(0xFFF59E0B),
          icon: Icons.tune_rounded,
          quantityIcon: Icons.sync_alt,
          prefix: '',
        );
    }
  }
}

class _MovementStyle {
  final Color color;
  final fw.IconData icon;
  final fw.IconData quantityIcon;
  final String prefix;

  _MovementStyle({
    required this.color,
    required this.icon,
    required this.quantityIcon,
    required this.prefix,
  });
}
