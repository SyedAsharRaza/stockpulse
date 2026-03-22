import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/primary_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppearanceSection(context),
            const SizedBox(height: 24),

            _buildCategorySection(context),
            const SizedBox(height: 24),
            _buildDataManagementSection(context),
            const SizedBox(height: 24),
            _buildAboutSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTextStyles.h4(context)),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Appearance'),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Column(
            children: [
              // toggle theme
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Dark Mode',
                  style: AppTextStyles.labelLarge(context),
                ),
                subtitle: Text(
                  isDark ? 'Currently using dark theme' : 'Currently using light theme',
                  style: AppTextStyles.bodySmall(context),
                ),
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(context, 'Categories'),
            IconButton(
              onPressed: () => _showAddCategoryDialog(context),
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              tooltip: 'Add Category',
            ),
          ],
        ),
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (!categoryProvider.hasCategories) {
              return Container(
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
                      Icons.category_outlined,
                      size: 40,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text('No categories yet', style: AppTextStyles.labelLarge(context)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => categoryProvider.addDefaultCategories(),
                      icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                      label: const Text('Add Default Categories'),
                    ),
                  ],
                ),
              );
            }

            return Container(
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
                itemCount: categoryProvider.categoriesSorted.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
                itemBuilder: (context, index) {
                  final category = categoryProvider.categoriesSorted[index];
                  return _buildCategoryTile(context, category);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryTile(BuildContext context, CategoryModel category) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final isInUse = inventoryProvider.isCategoryInUse(category.id);
    final productCount = inventoryProvider.productCountByCategory[category.id] ?? 0;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.folder_outlined,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        category.name,
        style: AppTextStyles.labelLarge(context),
      ),
      subtitle: Text(
        '$productCount products',
        style: AppTextStyles.bodySmall(context),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 20,
            ),
            onPressed: () => _showEditCategoryDialog(context, category),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: isInUse ? AppColors.darkTextTertiary : AppColors.error,
              size: 20,
            ),
            onPressed: isInUse
                ? () => _showCategoryInUseDialog(context, category.name, productCount)
                : () => _showDeleteCategoryDialog(context, category),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Data Management'),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Clear Transaction History',
                  style: AppTextStyles.labelLarge(context),
                ),
                subtitle: Text(
                  'Remove all audit trail records',
                  style: AppTextStyles.bodySmall(context),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showClearTransactionsDialog(context),
              ),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              // Reset All Data
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                title: Text(
                  'Reset All Data',
                  style: AppTextStyles.labelLarge(context, color: AppColors.error),
                ),
                subtitle: Text(
                  'Delete all products, categories & history',
                  style: AppTextStyles.bodySmall(context),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showResetAllDataDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'About'),
        Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(16),
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
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'StockPulse',
                style: AppTextStyles.h2(context),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: AppTextStyles.bodyMedium(context),
              ),
              const SizedBox(height: 16),
              Text(
                'A modern inventory management system built with Flutter & Provider.',
                style: AppTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTechBadge(context, 'Flutter'),
                  const SizedBox(width: 8),
                  _buildTechBadge(context, 'Provider'),
                  const SizedBox(width: 8),
                  _buildTechBadge(context, 'Material 3'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechBadge(BuildContext context, String label) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

// dialogs
  void _showAddCategoryDialog(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Category', style: AppTextStyles.h3(context)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Category name',
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
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a category name'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
              if (categoryProvider.categoryExists(name)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category already exists'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              categoryProvider.addCategory(name);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name added'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            //
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel category) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;


    final controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Category', style: AppTextStyles.h3(context)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Category name',

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
              final name = controller.text.trim();


              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a category name'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
              if (categoryProvider.categoryExists(name, excludeId: category.id)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category already exists'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }

              categoryProvider.updateCategory(category.id, name);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category updated to "$name"'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, CategoryModel category) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Category', style: AppTextStyles.h3(context)),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
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
              Provider.of<CategoryProvider>(context, listen: false)
                  .deleteCategory(category.id);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${category.name} deleted'),
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

  void _showCategoryInUseDialog(BuildContext context, String categoryName, int productCount) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 8),
            Text('Cannot Delete', style: AppTextStyles.h3(context)),
          ],
        ),
        content: Text(
          '"$categoryName" is used by $productCount product${productCount > 1 ? 's' : ''}. '
              'Please reassign or delete those products first.',
          style: AppTextStyles.bodyMedium(context),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Got it', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearTransactionsDialog(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear History', style: AppTextStyles.h3(context)),
        content: Text(
          'This will permanently delete all ${transactionProvider.transactionCount} transaction records. '
              'This action cannot be undone.',
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
              transactionProvider.clearAll();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction history cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showResetAllDataDialog(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Text('Reset All Data', style: AppTextStyles.h3(context)),
          ],
        ),
        content: Text(
          'This will permanently delete ALL:\n\n'
              '• Products\n'
              '• Categories\n'
              '• Transaction History\n\n'
              'This action CANNOT be undone!',
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
              // clear
              Provider.of<InventoryProvider>(context, listen: false).clearAll();
              Provider.of<CategoryProvider>(context, listen: false).clearAll();
              Provider.of<TransactionProvider>(context, listen: false).clearAll();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been reset'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset Everything', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}