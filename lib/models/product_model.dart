import '../core/utils/helpers.dart';

class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String categoryId;
  final int currentQuantity;
  final int minThreshold;
  final double unitCost;
  final DateTime createdAt;
  final DateTime lastUpdated;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.categoryId,
    required this.currentQuantity,
    required this.minThreshold,
    required this.unitCost,
    DateTime? createdAt,
    DateTime? lastUpdated,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now();



  // total value of current stock
  double get totalValue => currentQuantity * unitCost;

  // stock status
  StockStatus get stockStatus => Helpers.getStockStatus(currentQuantity, minThreshold);

  // check kro k stock restock ki zarurat hay ya nahi
  bool get needsRestock => currentQuantity <= minThreshold;

  // check kro k stock out of stock hay ya nahi
  bool get isOutOfStock => currentQuantity <= 0;

  //check kro k stock healthy hay ya nahi
  bool get isHealthy => stockStatus == StockStatus.healthy;

  double get stockPercentage {
    if (minThreshold == 0) return 100.0;
    final ratio = currentQuantity / (minThreshold * 3); // 3x threshold = 100%
    return (ratio * 100).clamp(0, 100);
  }

  // copyWith ProductModel kelie
  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? categoryId,
    int? currentQuantity,
    int? minThreshold,
    double? unitCost,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      minThreshold: minThreshold ?? this.minThreshold,
      unitCost: unitCost ?? this.unitCost,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }


  // stock adjustment part

  ProductModel adjustStock(int adjustment) {
    final newQuantity = (currentQuantity + adjustment).clamp(0, 999999);
    return copyWith(
      currentQuantity: newQuantity,
      lastUpdated: DateTime.now(),
    );
  }

  ProductModel setStock(int newQuantity) {
    return copyWith(
      currentQuantity: newQuantity.clamp(0, 999999),
      lastUpdated: DateTime.now(),
    );
  }
  // phir DSA Kam agya
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, sku: $sku, qty: $currentQuantity)';
  }
}