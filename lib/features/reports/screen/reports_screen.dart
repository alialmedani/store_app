import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../data/report_permissions.dart';
import 'category_performance_screen.dart';
import 'inventory_status_screen.dart';
import 'profit_margin_screen.dart';
import 'sales_summary_screen.dart';
import 'stock_movements_report_screen.dart';
import 'top_sellers_screen.dart';

/// Reports landing screen. Shows a tile per report, hidden when the user is
/// not granted the matching ABP permission. The backend still enforces access
/// (403), which the individual screens handle gracefully.
class ReportsScreen extends fw.StatelessWidget {
  const ReportsScreen({super.key});

  void _open(fw.BuildContext context, fw.Widget screen) {
    fw.Navigator.push(
      context,
      fw.PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.read<AuthCubit>();

    final tiles = <fw.Widget>[];
    void addTile({
      required String permission,
      required fw.IconData icon,
      required String title,
      required String subtitle,
      required fw.Color color,
      required fw.Widget screen,
    }) {
      if (!auth.can(permission)) return;
      tiles.add(
        MenuTile(
          animationIndex: tiles.length,
          icon: icon,
          title: title,
          subtitle: subtitle,
          color: color,
          onTap: () => _open(context, screen),
        ),
      );
    }

    addTile(
      permission: ReportPermissions.salesSummary,
      icon: Icons.insights_rounded,
      title: 'report_sales_summary'.tr(),
      subtitle: 'report_sales_summary_sub'.tr(),
      color: theme.colorScheme.primary,
      screen: const SalesSummaryScreen(),
    );
    addTile(
      permission: ReportPermissions.inventoryStatus,
      icon: Icons.inventory_rounded,
      title: 'report_inventory_status'.tr(),
      subtitle: 'report_inventory_status_sub'.tr(),
      color: AppDesignTokens.infoColor,
      screen: const InventoryStatusScreen(),
    );
    addTile(
      permission: ReportPermissions.topSellers,
      icon: Icons.leaderboard_rounded,
      title: 'report_top_sellers'.tr(),
      subtitle: 'report_top_sellers_sub'.tr(),
      color: AppDesignTokens.successColor,
      screen: const TopSellersScreen(),
    );
    addTile(
      permission: ReportPermissions.stockMovements,
      icon: Icons.swap_vert_rounded,
      title: 'report_stock_movements'.tr(),
      subtitle: 'report_stock_movements_sub'.tr(),
      color: AppDesignTokens.warningColor,
      screen: const StockMovementsReportScreen(),
    );
    addTile(
      permission: ReportPermissions.categoryPerformance,
      icon: Icons.category_rounded,
      title: 'report_category_performance'.tr(),
      subtitle: 'report_category_performance_sub'.tr(),
      color: AppDesignTokens.accentSecondaryColor,
      screen: const CategoryPerformanceScreen(),
    );
    addTile(
      permission: ReportPermissions.profitMargin,
      icon: Icons.account_balance_wallet_rounded,
      title: 'report_profit_margin'.tr(),
      subtitle: 'report_profit_margin_sub'.tr(),
      color: AppDesignTokens.primaryColor,
      screen: const ProfitMarginScreen(),
    );

    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            AppHeader(
              title: 'reports'.tr(),
              onBack: () => fw.Navigator.pop(context),
            ),
            fw.Expanded(
              child: tiles.isEmpty
                  ? EmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: 'report_no_access_title'.tr(),
                      subtitle: 'report_no_access_message'.tr(),
                    )
                  : fw.GridView.count(
                      padding: const fw.EdgeInsets.all(
                        AppDesignTokens.screenPaddingHorizontal,
                      ),
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                      children: tiles,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
