import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/primary_button.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _quantityController;
  late final TextEditingController _thresholdController;
  late final TextEditingController _costController;

  String? _selectedCategoryId;
  bool _isLoading = false;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _quantityController = TextEditingController(
      text: widget.product?.currentQuantity.toString() ?? '',
    );
    _thresholdController = TextEditingController(
      text: widget.product?.minThreshold.toString() ?? '10',
    );
    _costController = TextEditingController(
      text: widget.product?.unitCost.toString() ?? '',
    );
    _selectedCategoryId = widget.product?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Product' : 'Add New Product',
                      style: AppTextStyles.h3(context),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Product Name',
                        hint: 'Enter product name',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Helpers.validateRequired(value, 'Product name'),
                      ),
                      const SizedBox(height: 16),

                      // sku
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'SKU',
                              hint: 'Enter SKU code',
                              controller: _skuController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                final error = Helpers.validateRequired(value, 'SKU');
                                if (error != null) return error;

                                final inventoryProvider = Provider.of<InventoryProvider>(
                                  context,
                                  listen: false,
                                );
                                if (inventoryProvider.skuExists(
                                  value!,
                                  excludeId: widget.product?.id,
                                )) {
                                  return 'SKU already exists';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: IconButton(
                              onPressed: _generateSku,
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.auto_fix_high_rounded,
                                color: AppColors.primary,
                              ),
                              tooltip: 'Generate SKU',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildCategoryDropdown(context),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: isEditing ? 'Current Quantity' : 'Initial Quantity',
                              hint: '0',
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              enabled: !isEditing,
                              validator: (value) => Helpers.validatePositiveInteger(value, 'Quantity'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Min Threshold',
                              hint: '10',
                              controller: _thresholdController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) => Helpers.validatePositiveInteger(value, 'Threshold'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // unit cost
                      CustomTextField(
                        label: 'Unit Cost (\$)',
                        hint: '0.00',
                        controller: _costController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) => Helpers.validatePositiveNumber(value, 'Unit cost'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            '\$',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // submission button
                      PrimaryButton(
                        text: isEditing ? 'Update Product' : 'Add Product',
                        isLoading: _isLoading,
                        onPressed: _submitForm,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: _selectedCategoryId,
              isExpanded: true,
              hint: Text(
                'Select a category',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                ),
              ),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              items: categoryProvider.categoriesSorted.map((category) {
                return DropdownMenuItem<String?>(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategoryId = value);
              },
            ),
          ),
        ),
        if (_selectedCategoryId == null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              'Please select a category',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.error.withOpacity(0.8),
              ),
            ),
          ),
      ],
    );
  }

  void _generateSku() {
    if (_nameController.text.isNotEmpty) {
      final sku = Helpers.generateSKU(_nameController.text);
      _skuController.text = sku;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter product name first to generate SKU'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _submitForm() {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    final name = _nameController.text.trim();
    final sku = _skuController.text.trim();
    final quantity = int.parse(_quantityController.text);
    final threshold = int.parse(_thresholdController.text);
    final cost = double.parse(_costController.text);

    if (isEditing) {
      inventoryProvider.updateProduct(
        id: widget.product!.id,
        name: name,
        sku: sku,
        categoryId: _selectedCategoryId,
        minThreshold: threshold,
        unitCost: cost,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name updated successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      // add
      inventoryProvider.addProduct(
        name: name,
        sku: sku,
        categoryId: _selectedCategoryId!,
        initialQuantity: quantity,
        minThreshold: threshold,
        unitCost: cost,
      );

      final newProduct = inventoryProvider.products.last;
      if (quantity > 0) {
        transactionProvider.logAddition(
          productId: newProduct.id,
          productName: name,
          productSku: sku,
          quantity: quantity,
          balanceAfter: quantity,
          reason: TransactionReason.restock,
          notes: 'Initial stock',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name added successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
    }

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }
}