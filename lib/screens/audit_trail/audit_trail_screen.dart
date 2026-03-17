import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';

class AuditTrailScreen extends StatefulWidget {
  const AuditTrailScreen({super.key});

  @override
  State<AuditTrailScreen> createState() => _AuditTrailScreenState();
}

class _AuditTrailScreenState extends State<AuditTrailScreen> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Audit Trail',
        actions: [
          Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              if (!provider.hasActiveFilters) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.filter_list_off_rounded, color: AppColors.error),
                onPressed: () => provider.clearFilters(),
                tooltip: 'Clear Filters',
              );
            },
          ),
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilterSection(context),
          _buildActiveFilters(context),
          _buildTransactionStats(context),
          Expanded(child: _buildTransactionList(context)),
        ],
      ),
    );
  }
  Widget _buildFilterSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDatePresetFilter(context),
          const SizedBox(height: 16),

          _buildTypeFilter(context),
          const SizedBox(height: 16),
          _buildProductFilter(context),
        ],
      ),
    );
  }

  Widget _buildDatePresetFilter(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range', style: AppTextStyles.labelMedium(context)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DatePreset.values.map((preset) {
              final isSelected = _isPresetSelected(transactionProvider, preset);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => transactionProvider.setDatePreset(preset),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      preset.displayName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool _isPresetSelected(TransactionProvider provider, DatePreset preset) {
    if (preset == DatePreset.all && provider.filterDateRange == null) {
      return true;
    }
    //simple check
    return false;
  }

  Widget _buildTypeFilter(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction Type', style: AppTextStyles.labelMedium(context)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTypeChip(
                context: context,
                label: 'All',
                isSelected: transactionProvider.filterType == null,
                onTap: () => transactionProvider.setTypeFilter(null),
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context: context,
                label: 'Added',
                isSelected: transactionProvider.filterType == TransactionType.added,
                color: AppColors.success,
                onTap: () => transactionProvider.setTypeFilter(TransactionType.added),
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context: context,
                label: 'Removed',
                isSelected: transactionProvider.filterType == TransactionType.removed,
                color: AppColors.error,
                onTap: () => transactionProvider.setTypeFilter(TransactionType.removed),
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context: context,
                label: 'Adjusted',
                isSelected: transactionProvider.filterType == TransactionType.adjusted,
                color: AppColors.warning,
                onTap: () => transactionProvider.setTypeFilter(TransactionType.adjusted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.primary).withOpacity(0.2)
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? (color ?? AppColors.primary)
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildProductFilter(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product', style: AppTextStyles.labelMedium(context)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: transactionProvider.filterProductId,
              isExpanded: true,
              hint: Text(
                'All Products',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    'All Products',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                ...inventoryProvider.products.map((product) {
                  return DropdownMenuItem<String?>(
                    value: product.id,
                    child: Text(
                      '${product.name} (${product.sku})',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                transactionProvider.setProductFilter(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    if (!transactionProvider.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (transactionProvider.filterType != null)
              _buildActiveFilterChip(
                context: context,
                label: transactionProvider.filterType!.displayName,
                onRemove: () => transactionProvider.setTypeFilter(null),
              ),
            if (transactionProvider.filterProductId != null) ...[
              if (transactionProvider.filterType != null) const SizedBox(width: 8),
              _buildActiveFilterChip(
                context: context,
                label: inventoryProvider.getProductById(transactionProvider.filterProductId!)?.name ?? 'Unknown',
                onRemove: () => transactionProvider.setProductFilter(null),
              ),
            ],
            if (transactionProvider.filterDateRange != null) ...[
              const SizedBox(width: 8),
              _buildActiveFilterChip(
                context: context,
                label: 'Date filtered',
                onRemove: () => transactionProvider.setDateRangeFilter(null),
              ),
            ],
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => transactionProvider.clearFilters(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip({
    required BuildContext context,
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionStats(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.filteredTransactions;

        int totalAdded = 0;
        int totalRemoved = 0;

        for (final t in transactions) {
          if (t.isAddition) {
            totalAdded += t.absoluteQuantity;
          } else {
            totalRemoved += t.absoluteQuantity;
          }
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context: context,
                  label: 'Transactions',
                  value: transactions.length.toString(),
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  label: 'Added',
                  value: '+$totalAdded',
                  icon: Icons.add_circle_outline_rounded,
                  color: AppColors.success,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  label: 'Removed',
                  value: '-$totalRemoved',
                  icon: Icons.remove_circle_outline_rounded,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall(context),
        ),
      ],
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.filteredTransactions;

        if (provider.transactionCount == 0) {
          return const EmptyState(
            icon: Icons.history_rounded,
            title: 'No Transactions Yet',
            subtitle: 'Stock changes will be recorded here automatically.',
          );
        }

        if (transactions.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No Results Found',
            subtitle: 'Try adjusting your filters.',
            buttonText: 'Clear Filters',
            onButtonPressed: () => provider.clearFilters(),
          );
        }

        final groupedTransactions = _groupTransactionsByDate(transactions);

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final entry = groupedTransactions.entries.elementAt(index);
            return _buildDateGroup(context, entry.key, entry.value);
          },
        );
      },
    );
  }

  Map<String, List<TransactionModel>> _groupTransactionsByDate(List<TransactionModel> transactions) {
    final grouped = <String, List<TransactionModel>>{};

    for (final transaction in transactions) {
      final dateKey = _getDateKey(transaction.timestamp);
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }

    return grouped;
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return Helpers.formatDate(date);
    }
  }

  Widget _buildDateGroup(BuildContext context, String dateLabel, List<TransactionModel> transactions) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                dateLabel,
                style: AppTextStyles.labelLarge(context),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${transactions.length}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ),
            ],
          ),
        ),

        // transactions
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
            itemBuilder: (context, index) {
              return _buildTransactionTile(context, transactions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel transaction) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isAddition = transaction.isAddition;
    final typeColor = transaction.type.color;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isAddition ? Icons.add_rounded : Icons.remove_rounded,
              size: 18,
              color: typeColor,
            ),
          ),
          const SizedBox(width: 12),

          // Details
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
                  transaction.productSku,
                  style: AppTextStyles.bodySmall(context),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction.reason.displayName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                    ),
                    if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          transaction.notes!,
                          style: AppTextStyles.bodySmall(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Quantity & Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedQuantity,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: typeColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Bal: ${transaction.balanceAfter}',
                style: AppTextStyles.bodySmall(context),
              ),
              const SizedBox(height: 4),
              Text(
                Helpers.formatTimeAgo(transaction.timestamp),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}