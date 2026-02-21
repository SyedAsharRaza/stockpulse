import '../core/utils/helpers.dart';

class TransactionModel {
  final String id;
  final String productId;
  final String productName;
  final String productSku;
  final TransactionType type;
  final TransactionReason reason;
  final int quantityChanged;
  final int balanceAfter;
  final String? notes;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.type,
    required this.reason,
    required this.quantityChanged,
    required this.balanceAfter,
    this.notes,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();



  String get formattedQuantity {
    if (quantityChanged >= 0) {
      return '+$quantityChanged';
    }
    return '$quantityChanged';
  }

  int get absoluteQuantity => quantityChanged.abs();

  bool get isAddition => quantityChanged > 0;

  bool get isRemoval => quantityChanged < 0;

  // transcationModel kelie copyWith
  TransactionModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productSku,
    TransactionType? type,
    TransactionReason? reason,
    int? quantityChanged,
    int? balanceAfter,
    String? notes,
    DateTime? timestamp,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productSku: productSku ?? this.productSku,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      quantityChanged: quantityChanged ?? this.quantityChanged,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
    );
  }



  factory TransactionModel.add({
    required String productId,
    required String productName,
    required String productSku,
    required int quantity,
    required int balanceAfter,
    required TransactionReason reason,
    String? notes,
  }) {
    return TransactionModel(
      id: Helpers.generateId(),
      productId: productId,
      productName: productName,
      productSku: productSku,
      type: TransactionType.added,
      reason: reason,
      quantityChanged: quantity.abs(), // positive hi hona chahie
      balanceAfter: balanceAfter,
      notes: notes,
    );
  }

  // transaction for stoc removal
  factory TransactionModel.remove({
    required String productId,
    required String productName,
    required String productSku,
    required int quantity,
    required int balanceAfter,
    required TransactionReason reason,
    String? notes,
  }) {
    return TransactionModel(
      id: Helpers.generateId(),
      productId: productId,
      productName: productName,
      productSku: productSku,
      type: TransactionType.removed,
      reason: reason,
      quantityChanged: -quantity.abs(), // negative hi hona chahie yahan
      balanceAfter: balanceAfter,
      notes: notes,
    );
  }

  factory TransactionModel.adjust({
    required String productId,
    required String productName,
    required String productSku,
    required int quantityChanged,
    required int balanceAfter,
    String? notes,
  }) {
    return TransactionModel(
      id: Helpers.generateId(),
      productId: productId,
      productName: productName,
      productSku: productSku,
      type: TransactionType.adjusted,
      reason: TransactionReason.adjustment,
      quantityChanged: quantityChanged,
      balanceAfter: balanceAfter,
      notes: notes,
    );
  }

  // again thanks to DSA Semester 3
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TransactionModel(id: $id, product: $productName, qty: $formattedQuantity, type: ${type.displayName})';
  }
}