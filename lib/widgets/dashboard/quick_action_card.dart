import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../common/status_badge.dart';

class QuickActionCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const QuickActionCard({
    super.key,
    required this.product,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final statusColor = Helpers.getStockStatusColor(product.stockStatus);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(status: product.stockStatus, compact: true),
            const SizedBox(height: 10),
            // product ka naam
            Text(
              product.name,
              style: AppTextStyles.labelLarge(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,  // (....)
            ),
            const SizedBox(height: 2),

            // sku
            Text(
              product.sku,
              style: AppTextStyles.bodySmall(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Qty: ${product.currentQuantity}',
                  style: AppTextStyles.metricSmall(context, color: statusColor),
                ),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.remove,
                      onTap: product.currentQuantity > 0 ? onDecrement : null,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 4),
                    _ActionButton(
                      icon: Icons.add,
                      onTap: onIncrement,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkElevated : AppColors.lightElevated,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 14,
          color: onTap != null
              ? AppColors.primary
              : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
        ),
      ),
    );
  }
}