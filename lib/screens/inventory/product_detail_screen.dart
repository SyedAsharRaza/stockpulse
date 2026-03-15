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
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/status_badge.dart';
import 'add_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final product = inventoryProvider.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Product Details', showBackButton: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
              ),
              const SizedBox(height: 16),
              Text('Product not found', style: AppTextStyles.h4(context)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Product Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => _openEditSheet(context, product),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => _showDeleteDialog(context, product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductInfoCard(context, product),
            const SizedBox(height: 16),

            _buildStockStatusCard(context, product),
            const SizedBox(height: 16),

            _buildQuickActionsCard(context, product),
            const SizedBox(height: 24),

            _buildTransactionHistory(context, product),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoCard(BuildContext context, ProductModel product) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categoryName = categoryProvider.getCategoryName(product.categoryId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.h2(context)),
                    const SizedBox(height: 4),
                    Text(product.sku, style: AppTextStyles.bodyMedium(context)),
                  ],
                ),
              ),
              StatusBadge(status: product.stockStatus),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Category', categoryName),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Unit Cost', Helpers.formatCurrency(product.unitCost)),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Total Value', Helpers.formatCurrency(product.totalValue)),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Last Updated', Helpers.formatDateTime(product.lastUpdated)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium(context)),
        Text(value, style: AppTextStyles.labelLarge(context)),
      ],
    );
  }

  Widget _buildStockStatusCard(BuildContext context, ProductModel product) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final statusColor = Helpers.getStockStatusColor(product.stockStatus);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Stock',
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: 8),
                Text(
                  product.currentQuantity.toString(),
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                Text(
                  'Min Threshold: ${product.minThreshold}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),

          // Stock Bar Indicator
          SizedBox(
            width: 60,
            height: 100,
            child: _buildStockBar(context, product),
          ),
        ],
      ),
    );
  }

  Widget _buildStockBar(BuildContext context, ProductModel product) {
    final percentage = product.stockPercentage / 100;
    final statusColor = Helpers.getStockStatusColor(product.stockStatus);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: 24,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: percentage.clamp(0.05, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, ProductModel product) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text('Quick Actions', style: AppTextStyles.h4(context)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Add Stock',
                  icon: Icons.add_rounded,
                  color: AppColors.success,
                  onTap: () => _showStockAdjustmentDialog(context, product, isAdding: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Remove Stock',
                  icon: Icons.remove_rounded,
                  color: AppColors.error,
                  onTap: product.currentQuantity > 0
                      ? () => _showStockAdjustmentDialog(context, product, isAdding: false)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder).withOpacity(0.5)
              : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDisabled ? Colors.transparent : color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDisabled
                  ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)
                  : color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)
                    : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(BuildContext context, ProductModel product) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.getProductTransactions(product.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction History', style: AppTextStyles.h4(context)),
        const SizedBox(height: 12),

        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
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
                Text('No transactions yet', style: AppTextStyles.labelLarge(context)),
              ],
            ),
          )
        else
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
              itemCount: transactions.length.clamp(0, 10),
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionTile(context, transaction);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel transaction) {
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
                  transaction.reason.displayName,
                  style: AppTextStyles.labelLarge(context),
                ),
                const SizedBox(height: 2),
                Text(
                  Helpers.formatDateTime(transaction.timestamp),
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
              Text(
                'Balance: ${transaction.balanceAfter}',
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditSheet(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductScreen(product: product),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductModel product) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Product', style: AppTextStyles.h3(context)),

        content: Text(
          'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
          style: AppTextStyles.bodyMedium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
              final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

              inventoryProvider.deleteProduct(product.id);
              transactionProvider.deleteProductTransactions(product.id);

              Navigator.pop(context); // dialog close
              Navigator.pop(context); // wapsi inventory list

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStockAdjustmentDialog(BuildContext context, ProductModel product, {required bool isAdding}) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final quantityController = TextEditingController(text: '1');
    TransactionReason selectedReason = isAdding ? TransactionReason.restock : TransactionReason.sale;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isAdding ? 'Add Stock' : 'Remove Stock',
            style: AppTextStyles.h3(context),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantity',
                style: AppTextStyles.labelMedium(context),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  filled: true,
                  fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Reason', style: AppTextStyles.labelMedium(context)),
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
                  child: DropdownButton<TransactionReason>(
                    value: selectedReason,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    items: TransactionReason.values.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason.displayName,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedReason = value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid quantity'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
                final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

                ProductModel? updatedProduct;
                if (isAdding) {
                  updatedProduct = inventoryProvider.addStock(product.id, quantity);
                  if (updatedProduct != null) {
                    transactionProvider.logAddition(
                      productId: product.id,
                      productName: product.name,
                      productSku: product.sku,
                      quantity: quantity,
                      balanceAfter: updatedProduct.currentQuantity,
                      reason: selectedReason,
                    );
                  }
                } else {
                  updatedProduct = inventoryProvider.removeStock(product.id, quantity);
                  if (updatedProduct != null) {
                    transactionProvider.logRemoval(
                      productId: product.id,
                      productName: product.name,
                      productSku: product.sku,
                      quantity: quantity,
                      balanceAfter: updatedProduct.currentQuantity,
                      reason: selectedReason,
                    );
                  }
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isAdding
                          ? 'Added $quantity to ${product.name}'
                          : 'Removed $quantity from ${product.name}',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isAdding ? AppColors.success : AppColors.warning,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdding ? AppColors.success : AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isAdding ? 'Add' : 'Remove',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}