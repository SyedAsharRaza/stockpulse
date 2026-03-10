import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/quick_action_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDefaultData(); // dashboard screen wala
  }

  void _initializeDefaultData() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    if (!categoryProvider.hasCategories) {
      categoryProvider.addDefaultCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'StockPulse',
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, inventoryProvider, child) {
          if (!inventoryProvider.hasProducts) {
            return _buildEmptyDashboard(context);
          }
          return _buildDashboardContent(context, inventoryProvider);
        },
      ),
    );
  }

  Widget _buildEmptyDashboard(BuildContext context) {
    return EmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'No Products Yet',
      subtitle: 'Start by adding your first product to track inventory and see insights here.',
      buttonText: 'Add First Product',
      onButtonPressed: () {
        _navigateToInventory(context);
      },
    );
  }

  void _navigateToInventory(BuildContext context) {
    final scaffold = Scaffold.of(context);
    if (scaffold.hasDrawer) {
      Navigator.of(context).pop();
    }
    // abhi ke lie snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Go to Inventory tab to add products'), // fix !
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, InventoryProvider inventoryProvider) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return RefreshIndicator(
      onRefresh: () async {
        // refresh dummy
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingSection(context),
            const SizedBox(height: 24),
            _buildMetricsSection(context, inventoryProvider),
            const SizedBox(height: 24),
            _buildQuickActionsSection(context, inventoryProvider),
            const SizedBox(height: 24),
            _buildRecentActivitySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final hour = DateTime.now().hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: AppTextStyles.h2(context),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your inventory overview',
            style: AppTextStyles.bodyMedium(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(BuildContext context, InventoryProvider inventoryProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics',
            style: AppTextStyles.h4(context),
          ),
          const SizedBox(height: 12),

          // First Row
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Total Value',
                  value: Helpers.formatCompactCurrency(inventoryProvider.totalInventoryValue),
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.primary,
                  subtitle: '${inventoryProvider.productCount} products',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: 'Alerts',
                  value: inventoryProvider.alertCount.toString(),
                  icon: Icons.warning_amber_rounded,
                  iconColor: inventoryProvider.alertCount > 0
                      ? AppColors.error
                      : AppColors.success,
                  valueColor: inventoryProvider.alertCount > 0
                      ? AppColors.error
                      : null,
                  subtitle: 'Need attention',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // doosri row
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Health Score',
                  value: '${inventoryProvider.inventoryHealthPercentage.toStringAsFixed(0)}%',
                  icon: Icons.favorite_outline_rounded,
                  iconColor: _getHealthColor(inventoryProvider.inventoryHealthPercentage),
                  valueColor: _getHealthColor(inventoryProvider.inventoryHealthPercentage),
                  subtitle: '${inventoryProvider.healthyStockCount} healthy items',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: 'Out of Stock',
                  value: inventoryProvider.outOfStockCount.toString(),
                  icon: Icons.remove_shopping_cart_outlined,
                  iconColor: inventoryProvider.outOfStockCount > 0
                      ? AppColors.error
                      : AppColors.success,
                  valueColor: inventoryProvider.outOfStockCount > 0
                      ? AppColors.error
                      : null,
                  subtitle: 'Items depleted',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double percentage) {
    if (percentage >= 70) return AppColors.success;
    if (percentage >= 40) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildQuickActionsSection(BuildContext context, InventoryProvider inventoryProvider) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final criticalProducts = inventoryProvider.criticalProducts;

    if (criticalProducts.isEmpty) {
      return _buildAllHealthyCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Needs Attention',
                style: AppTextStyles.h4(context),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${criticalProducts.length} items',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: criticalProducts.length,
            itemBuilder: (context, index) {
              final product = criticalProducts[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < criticalProducts.length - 1 ? 12 : 0,
                ),
                child: QuickActionCard(
                  product: product,
                  onTap: () => _showProductDetails(context, product),
                  onIncrement: () => _handleIncrement(context, product),
                  onDecrement: () => _handleDecrement(context, product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllHealthyCard(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.success.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Stock Healthy!',
                    style: AppTextStyles.h4(context, color: AppColors.success),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No items need immediate attention.', // sab set hay
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final recentTransactions = transactionProvider.recentTransactions;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: AppTextStyles.h4(context),
                  ),
                  if (recentTransactions.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Go to History tab for full audit trail'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (recentTransactions.isEmpty)
                _buildNoActivityCard(context)
              else
                _buildActivityList(context, recentTransactions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoActivityCard(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 40,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'No Recent Activity',
            style: AppTextStyles.labelLarge(context),
          ),
          const SizedBox(height: 4),
          Text(
            'Stock changes will appear here',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, List<TransactionModel> transactions) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildActivityTile(context, transaction);
        },
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, TransactionModel transaction) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isAddition = transaction.isAddition;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isAddition ? AppColors.success : AppColors.error).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isAddition ? Icons.add_rounded : Icons.remove_rounded,
              size: 16,
              color: isAddition ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.productName,
                  style: AppTextStyles.labelLarge(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.type.displayName} • ${transaction.reason.displayName}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedQuantity,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isAddition ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Helpers.formatTimeAgo(transaction.timestamp),
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${product.name}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleIncrement(BuildContext context, ProductModel product) {
    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    final updatedProduct = inventoryProvider.addStock(product.id, 1);

    if (updatedProduct != null) {
      transactionProvider.logAddition(
        productId: product.id,
        productName: product.name,
        productSku: product.sku,
        quantity: 1,
        balanceAfter: updatedProduct.currentQuantity,
        reason: TransactionReason.restock,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added 1 to ${product.name}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleDecrement(BuildContext context, ProductModel product) {
    if (product.currentQuantity <= 0) return;

    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    final updatedProduct = inventoryProvider.removeStock(product.id, 1);

    if (updatedProduct != null) {
      transactionProvider.logRemoval(
        productId: product.id,
        productName: product.name,
        productSku: product.sku,
        quantity: 1,
        balanceAfter: updatedProduct.currentQuantity,
        reason: TransactionReason.sale,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed 1 from ${product.name}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}