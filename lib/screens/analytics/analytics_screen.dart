import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Analytics'),
      body: !inventoryProvider.hasProducts
          ? const EmptyState(
        icon: Icons.analytics_outlined,
        title: 'No Data Yet',
        subtitle: 'Add products to see analytics and insights.',
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewSection(context),
            const SizedBox(height: 24),

            _buildStockHealthSection(context),
            const SizedBox(height: 24),

            _buildCategorySection(context),
            const SizedBox(height: 24),

            _buildTopProductsSection(context),
            const SizedBox(height: 24),

            _buildTransactionSummarySection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Inventory Value',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Helpers.formatCurrency(inventoryProvider.totalInventoryValue),
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildOverviewStat(
                    label: 'Products',
                    value: inventoryProvider.productCount.toString(),
                  ),
                  const SizedBox(width: 24),
                  _buildOverviewStat(
                    label: 'Categories',
                    value: Provider.of<CategoryProvider>(context).categoryCount.toString(),
                  ),
                  const SizedBox(width: 24),
                  _buildOverviewStat(
                    label: 'Health',
                    value: '${inventoryProvider.inventoryHealthPercentage.toStringAsFixed(0)}%',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStockHealthSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    final healthyCount = inventoryProvider.healthyStockCount;
    final lowCount = inventoryProvider.lowStockCount;
    final criticalCount = inventoryProvider.criticalStockCount;
    final outOfStockCount = inventoryProvider.outOfStockCount;
    final total = inventoryProvider.productCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stock Health Distribution', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Column(
            children: [// progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      if (healthyCount > 0)
                        Expanded(
                          flex: healthyCount,
                          child: Container(color: AppColors.success),
                        ),
                      if (lowCount > 0)
                        Expanded(
                          flex: lowCount,
                          child: Container(color: AppColors.warning),
                        ),
                      if (criticalCount > 0)
                        Expanded(
                          flex: criticalCount,
                          child: Container(color: AppColors.error),
                        ),
                      if (outOfStockCount > 0)
                        Expanded(
                          flex: outOfStockCount,
                          child: Container(
                            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHealthLegendItem(
                    context: context,
                    label: 'Healthy',
                    count: healthyCount,
                    color: AppColors.success,
                    percentage: total > 0 ? (healthyCount / total * 100) : 0,
                  ),
                  _buildHealthLegendItem(
                    context: context,
                    label: 'Low',
                    count: lowCount,
                    color: AppColors.warning,
                    percentage: total > 0 ? (lowCount / total * 100) : 0,
                  ),
                  _buildHealthLegendItem(
                    context: context,
                    label: 'Critical',
                    count: criticalCount,
                    color: AppColors.error,
                    percentage: total > 0 ? (criticalCount / total * 100) : 0,
                  ),
                  _buildHealthLegendItem(
                    context: context,
                    label: 'Out',
                    count: outOfStockCount,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    percentage: total > 0 ? (outOfStockCount / total * 100) : 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthLegendItem({
    required BuildContext context,
    required String label,
    required int count,
    required Color color,
    required double percentage,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall(context),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: AppTextStyles.bodySmall(context),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final valueByCategory = inventoryProvider.totalValueByCategory;
    final countByCategory = inventoryProvider.productCountByCategory;

    final sortedCategories = valueByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category Breakdown', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedCategories.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            itemBuilder: (context, index) {
              final entry = sortedCategories[index];
              final categoryName = categoryProvider.getCategoryName(entry.key);
              final productCount = countByCategory[entry.key] ?? 0;
              final totalValue = entry.value;
              final maxValue = sortedCategories.first.value;
              final percentage = maxValue > 0 ? (totalValue / maxValue) : 0.0;

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: AppTextStyles.labelLarge(context),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$productCount products',
                                style: AppTextStyles.bodySmall(context),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          Helpers.formatCurrency(totalValue),
                          style: AppTextStyles.metricSmall(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: isDark
                            ? AppColors.darkCardBorder
                            : AppColors.lightCardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(index),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      const Color(0xFF8B5CF6), // ye purple
      const Color(0xFFEC4899), // ye pink hay
      const Color(0xFF06B6D4), // ye Cyan hay (among us haha)
    ];
    return colors[index % colors.length];
  }

  Widget _buildTopProductsSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final topProducts = inventoryProvider.topProductsByValue;

    if (topProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Products by Value', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topProducts.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            itemBuilder: (context, index) {
              final product = topProducts[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // rank
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _getRankColor(index).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _getRankColor(index),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: AppTextStyles.labelLarge(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${product.currentQuantity} units × ${Helpers.formatCurrency(product.unitCost)}',
                            style: AppTextStyles.bodySmall(context),
                          ),
                        ],
                      ),
                    ),

                    // value
                    Text(
                      Helpers.formatCurrency(product.totalValue),
                      style: AppTextStyles.metricSmall(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // this is gold
      case 1:
        return const Color(0xFFC0C0C0); // silver
      case 2:
        return const Color(0xFFCD7F32); // this is bronze
      default:
        return AppColors.primary;
    }
  }

  Widget _buildTransactionSummarySection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final countByType = transactionProvider.transactionCountByType;
    final totalAdded = transactionProvider.totalItemsAdded;
    final totalRemoved = transactionProvider.totalItemsRemoved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction Summary', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context: context,
                title: 'Total Transactions',
                value: transactionProvider.transactionCount.toString(),
                icon: Icons.receipt_long_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context: context,
                title: 'Items Added',
                value: '+$totalAdded',
                icon: Icons.add_circle_outline_rounded,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context: context,
                title: 'Items Removed',
                value: '-$totalRemoved',
                icon: Icons.remove_circle_outline_rounded,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context: context,
                title: 'Net Change',
                value: (totalAdded - totalRemoved) >= 0
                    ? '+${totalAdded - totalRemoved}'
                    : '${totalAdded - totalRemoved}',
                icon: Icons.swap_vert_rounded,
                color: (totalAdded - totalRemoved) >= 0
                    ? AppColors.success
                    : AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}