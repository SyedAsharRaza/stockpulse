import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';

class StatusBadge extends StatelessWidget {
  final StockStatus status;
  final bool showIcon;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Helpers.getStockStatusColor(status);
    final text = Helpers.getStockStatusText(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: compact ? 12 : 14, color: color),
            SizedBox(width: compact ? 4 : 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(StockStatus status) {
    switch (status) {
      case StockStatus.healthy:
        return Icons.check_circle_outline_rounded;
      case StockStatus.low:
        return Icons.warning_amber_rounded;
      case StockStatus.critical:
        return Icons.error_outline_rounded;
      case StockStatus.outOfStock:
        return Icons.cancel_outlined;
    }
  }
}