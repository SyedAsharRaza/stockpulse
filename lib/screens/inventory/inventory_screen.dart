import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/inventory/product_card.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Inventory',
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off_rounded : Icons.filter_list_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () => _openAddProductSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          if (_showFilters) _buildFilterSection(context),
          _buildActiveFiltersChips(context),
          Expanded(
            child: _buildProductList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddProductSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          inventoryProvider.setSearchQuery(value);
        },
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search by name or SKU...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            onPressed: () {
              _searchController.clear();
              inventoryProvider.setSearchQuery('');
            },
          )
              : null,
          filled: true,
          fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(context),
          const SizedBox(height: 12),
          _buildStockStatusFilter(context),
          const SizedBox(height: 12),
          _buildSortOptions(context),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.labelMedium(context),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: inventoryProvider.filterCategoryId,
              isExpanded: true,
              hint: Text(
                'All Categories',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    'All Categories',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                ...categoryProvider.categoriesSorted.map((category) {
                  return DropdownMenuItem<String?>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                inventoryProvider.setCategoryFilter(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockStatusFilter(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stock Status',
          style: AppTextStyles.labelMedium(context),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStatusChip(
                context: context,
                label: 'All',
                isSelected: inventoryProvider.filterStockStatus == null,
                onTap: () => inventoryProvider.setStockStatusFilter(null),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                context: context,
                label: 'Healthy',
                isSelected: inventoryProvider.filterStockStatus == StockStatus.healthy,
                color: AppColors.success,
                onTap: () => inventoryProvider.setStockStatusFilter(StockStatus.healthy),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                context: context,
                label: 'Low',
                isSelected: inventoryProvider.filterStockStatus == StockStatus.low,
                color: AppColors.warning,
                onTap: () => inventoryProvider.setStockStatusFilter(StockStatus.low),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                context: context,
                label: 'Critical',
                isSelected: inventoryProvider.filterStockStatus == StockStatus.critical,
                color: AppColors.error,
                onTap: () => inventoryProvider.setStockStatusFilter(StockStatus.critical),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                context: context,
                label: 'Out of Stock',
                isSelected: inventoryProvider.filterStockStatus == StockStatus.outOfStock,
                color: AppColors.error,
                onTap: () => inventoryProvider.setStockStatusFilter(StockStatus.outOfStock),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip({
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
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
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

  Widget _buildSortOptions(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: AppTextStyles.labelMedium(context),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SortOption>(
              value: inventoryProvider.sortOption,
              isExpanded: true,
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              items: SortOption.values.map((option) {
                return DropdownMenuItem<SortOption>(
                  value: option,
                  child: Text(
                    option.displayName,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  inventoryProvider.setSortOption(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFiltersChips(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    if (!inventoryProvider.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (inventoryProvider.searchQuery.isNotEmpty)
              _buildFilterChip(
                context: context,
                label: 'Search: "${inventoryProvider.searchQuery}"',
                onRemove: () {
                  _searchController.clear();
                  inventoryProvider.setSearchQuery('');
                },
              ),
            if (inventoryProvider.filterCategoryId != null) ...[
              if (inventoryProvider.searchQuery.isNotEmpty) const SizedBox(width: 8),
              _buildFilterChip(
                context: context,
                label: categoryProvider.getCategoryName(inventoryProvider.filterCategoryId!),
                onRemove: () => inventoryProvider.setCategoryFilter(null),
              ),
            ],
            if (inventoryProvider.filterStockStatus != null) ...[
              const SizedBox(width: 8),
              _buildFilterChip(
                context: context,
                label: Helpers.getStockStatusText(inventoryProvider.filterStockStatus!),
                onRemove: () => inventoryProvider.setStockStatusFilter(null),
              ),
            ],
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _searchController.clear();
                inventoryProvider.clearFilters();
              },
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

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required VoidCallback onRemove,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

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
  Widget _buildProductList(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        final products = inventoryProvider.filteredProducts;

        if (!inventoryProvider.hasProducts) {
          return Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Products Yet',
                subtitle: 'Add your first product to start managing inventory.',
                buttonText: 'Add Product',
                onButtonPressed: () => _openAddProductSheet(context),
              ),
            ),
          );
        }

        if (products.isEmpty) {
          return Center(
            child: SingleChildScrollView( // changed to single child scroll because porana wala error de rha tha bottom oveflow ka
              physics: const AlwaysScrollableScrollPhysics(),
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No Results Found',
                subtitle: 'Try adjusting your search or filters.',
                buttonText: 'Clear Filters',
                onButtonPressed: () {
                  _searchController.clear();
                  inventoryProvider.clearFilters();
                },
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _openProductDetail(context, product),
              onIncrement: () => _handleIncrement(context, product),
              onDecrement: () => _handleDecrement(context, product),
            );
          },
        );
      },
    );
  }

  void _openAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddProductScreen(),
    );
  }

  void _openProductDetail(BuildContext context, ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: product.id),
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
    }
  }
}