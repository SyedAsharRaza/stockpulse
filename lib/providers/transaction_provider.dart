import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../core/utils/helpers.dart';

class TransactionProvider extends ChangeNotifier {

  final List<TransactionModel> _transactions = [];

  String? _filterProductId;
  TransactionType? _filterType;
  DateTimeRange? _filterDateRange;

  // sab se nayi transactions pehle
  List<TransactionModel> get transactions {
    final sorted = List<TransactionModel>.from(_transactions);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  List<TransactionModel> get filteredTransactions {
    var result = List<TransactionModel>.from(_transactions);

    // Filter by product
    if (_filterProductId != null) {
      result = result.where((t) => t.productId == _filterProductId).toList();
    }

    if (_filterType != null) {
      result = result.where((t) => t.type == _filterType).toList();
    }

    if (_filterDateRange != null) {
      result = result.where((t) {
        return t.timestamp.isAfter(_filterDateRange!.start) &&
            t.timestamp.isBefore(_filterDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    result.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return result;
  }

  List<TransactionModel> get recentTransactions {
    return transactions.take(5).toList();
  }

  List<TransactionModel> getProductTransactions(String productId) {
    return transactions.where((t) => t.productId == productId).toList();
  }

  int get transactionCount => _transactions.length;

  bool get hasActiveFilters =>
      _filterProductId != null ||
          _filterType != null ||
          _filterDateRange != null;

  String? get filterProductId => _filterProductId;
  TransactionType? get filterType => _filterType;
  DateTimeRange? get filterDateRange => _filterDateRange;

  // filtering wala kam
  void setProductFilter(String? productId) {
    _filterProductId = productId;
    notifyListeners();
  }
  void setTypeFilter(TransactionType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? range) {
    _filterDateRange = range;
    notifyListeners();
  }
  void setDatePreset(DatePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (preset) {
      case DatePreset.today:
        _filterDateRange = DateTimeRange(
          start: today,
          end: today,
        );
        break;
      case DatePreset.last7Days:
        _filterDateRange = DateTimeRange(
          start: today.subtract(const Duration(days: 6)),
          end: today,
        );
        break;
      case DatePreset.last30Days:
        _filterDateRange = DateTimeRange(
          start: today.subtract(const Duration(days: 29)),
          end: today,
        );
        break;
      case DatePreset.thisMonth:
        _filterDateRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: today,
        );
        break;
      case DatePreset.all:
        _filterDateRange = null;
        break;
    }
    notifyListeners();
  }

  void clearFilters() {
    _filterProductId = null;
    _filterType = null;
    _filterDateRange = null;
    notifyListeners();
  }

  // transaction log karne ke methods
  void logAddition({
    required String productId,
    required String productName,
    required String productSku,
    required int quantity,
    required int balanceAfter,
    required TransactionReason reason,
    String? notes,
  }) {
    final transaction = TransactionModel.add(
      productId: productId,
      productName: productName,
      productSku: productSku,
      quantity: quantity,
      balanceAfter: balanceAfter,
      reason: reason,
      notes: notes,
    );

    _transactions.add(transaction);
    notifyListeners();
  }

  void logRemoval({
    required String productId,
    required String productName,
    required String productSku,
    required int quantity,
    required int balanceAfter,
    required TransactionReason reason,
    String? notes,
  }) {
    final transaction = TransactionModel.remove(
      productId: productId,
      productName: productName,
      productSku: productSku,
      quantity: quantity,
      balanceAfter: balanceAfter,
      reason: reason,
      notes: notes,
    );

    _transactions.add(transaction);
    notifyListeners();
  }

  void logAdjustment({
    required String productId,
    required String productName,
    required String productSku,
    required int quantityChanged,
    required int balanceAfter,
    String? notes,
  }) {
    final transaction = TransactionModel.adjust(
      productId: productId,
      productName: productName,
      productSku: productSku,
      quantityChanged: quantityChanged,
      balanceAfter: balanceAfter,
      notes: notes,
    );

    _transactions.add(transaction);
    notifyListeners();
  }

  // analytics
  Map<TransactionType, int> get transactionCountByType {
    final counts = <TransactionType, int>{};
    for (final type in TransactionType.values) {
      counts[type] = _transactions.where((t) => t.type == type).length;
    }
    return counts;
  }
  int get totalItemsAdded {
    return _transactions
        .where((t) => t.type == TransactionType.added)
        .fold(0, (sum, t) => sum + t.absoluteQuantity);
  }

  int get totalItemsRemoved {
    return _transactions
        .where((t) => t.type == TransactionType.removed)
        .fold(0, (sum, t) => sum + t.absoluteQuantity);
  }

  // cleanup

  void deleteProductTransactions(String productId) {
    _transactions.removeWhere((t) => t.productId == productId);
    notifyListeners();
  }

  void clearAll() {
    _transactions.clear();
    _filterProductId = null;
    _filterType = null;
    _filterDateRange = null;
    notifyListeners();
  }
}

// enums
enum DatePreset {
  today,
  last7Days,
  last30Days,
  thisMonth,
  all,
}
// yaha par bhi gpt ki help li
extension DatePresetExtension on DatePreset {
  String get displayName {
    switch (this) {
      case DatePreset.today:
        return 'Today';
      case DatePreset.last7Days:
        return 'Last 7 Days';
      case DatePreset.last30Days:
        return 'Last 30 Days';
      case DatePreset.thisMonth:
        return 'This Month';
      case DatePreset.all:
        return 'All Time';
    }
  }
}