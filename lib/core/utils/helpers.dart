import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class Helpers {
  Helpers._();

  // date formatters :) took help from gpt here, not gonna lie
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // For currency
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String formatCompactCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return formatCurrency(value);
  }

  // for Number formatting
  static String formatNumber(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // enum value return
  static StockStatus getStockStatus(int currentQty, int minThreshold) {
    if (currentQty <= 0) {
      return StockStatus.outOfStock;
    } else if (currentQty <= minThreshold) {
      return StockStatus.critical;
    } else if (currentQty <= minThreshold * 2) {
      return StockStatus.low;
    } else {
      return StockStatus.healthy;
    }
  }

  static Color getStockStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.healthy:
        return AppColors.stockHealthy;
      case StockStatus.low:
        return AppColors.stockLow;
      case StockStatus.critical:
      case StockStatus.outOfStock:
        return AppColors.stockCritical;
    }
  }

  static String getStockStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.healthy:
        return 'Healthy';
      case StockStatus.low:
        return 'Low Stock';
      case StockStatus.critical:
        return 'Critical';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  // validation stuff
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0) {
      return '$fieldName must be positive';
    }
    return null;
  }

  static String? validatePositiveInteger(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid whole number';
    }
    if (number < 0) {
      return '$fieldName must be positive';
    }
    return null;
  }

  // id generation wala kam
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (1000 + (DateTime.now().microsecond % 9000)).toString();
  }

  static String generateSKU(String productName) {
    final prefix = productName
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$prefix-$suffix';
  }
}

// enums hi most feasible hayn for this kind of stuff
enum StockStatus {
  healthy,
  low,
  critical,
  outOfStock,
}

enum TransactionType {
  added,
  removed,
  adjusted,
}

enum TransactionReason {
  sale,
  restock,
  damaged,
  adjustment,
  returned,
  other,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.added:
        return 'Stock Added';
      case TransactionType.removed:
        return 'Stock Removed';
      case TransactionType.adjusted:
        return 'Stock Adjusted';
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.added:
        return AppColors.success;
      case TransactionType.removed:
        return AppColors.error;
      case TransactionType.adjusted:
        return AppColors.warning;
    }
  }
}

extension TransactionReasonExtension on TransactionReason {
  String get displayName {
    switch (this) {
      case TransactionReason.sale:
        return 'Sale';
      case TransactionReason.restock:
        return 'Restock';
      case TransactionReason.damaged:
        return 'Damaged';
      case TransactionReason.adjustment:
        return 'Adjustment';
      case TransactionReason.returned:
        return 'Returned';
      case TransactionReason.other:
        return 'Other';
    }
  }
}