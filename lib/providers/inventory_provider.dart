import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../core/utils/helpers.dart';

class InventoryProvider extends ChangeNotifier {

  final List<ProductModel> _products = [];

  String _searchQuery = '';
  String? _filterCategoryId;
  StockStatus? _filterStockStatus;
  SortOption _sortOption = SortOption.nameAsc;



  List<ProductModel> get products => List.unmodifiable(_products);

  int get productCount => _products.length;

  bool get hasProducts => _products.isNotEmpty;


  String get searchQuery => _searchQuery;

  String? get filterCategoryId => _filterCategoryId;
  StockStatus? get filterStockStatus => _filterStockStatus;

  SortOption get sortOption => _sortOption;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
          _filterCategoryId != null ||
          _filterStockStatus != null;
  // sab se mushkil part ye hai ki search, filter, sort ko ek sath kaise handle karu.
  // gpt se help li hay yah pr thori thori
  List<ProductModel> get filteredProducts {
    var result = List<ProductModel>.from(_products);


    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.sku.toLowerCase().contains(query);
      }).toList();
    }

    if (_filterCategoryId != null) {
      result = result.where((p) => p.categoryId == _filterCategoryId).toList();
    }

    if (_filterStockStatus != null) {
      result = result.where((p) => p.stockStatus == _filterStockStatus).toList();
    }

    result = _applySorting(result);

    return result;
  }

  List<ProductModel> _applySorting(List<ProductModel> products) {
    switch (_sortOption) {
      case SortOption.nameAsc:
        products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.nameDesc:
        products.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortOption.valueHighToLow:
        products.sort((a, b) => b.totalValue.compareTo(a.totalValue));
        break;
      case SortOption.valueLowToHigh:
        products.sort((a, b) => a.totalValue.compareTo(b.totalValue));
        break;
      case SortOption.quantityHighToLow:
        products.sort((a, b) => b.currentQuantity.compareTo(a.currentQuantity));
        break;
      case SortOption.quantityLowToHigh:
        products.sort((a, b) => a.currentQuantity.compareTo(b.currentQuantity));
        break;
      case SortOption.recentlyUpdated:
        products.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
    }
    return products;
  }


  double get totalInventoryValue {
    if (_products.isEmpty) return 0;
    return _products.fold(0, (sum, product) => sum + product.totalValue);
  }

  int get criticalStockCount {
    return _products.where((p) => p.stockStatus == StockStatus.critical).length;
  }

  int get lowStockCount {
    return _products.where((p) => p.stockStatus == StockStatus.low).length;
  }

  int get alertCount => criticalStockCount + lowStockCount;

  int get healthyStockCount {
    return _products.where((p) => p.stockStatus == StockStatus.healthy).length; // healthy walay
  }

  int get outOfStockCount {
    return _products.where((p) => p.stockStatus == StockStatus.outOfStock).length;
  }

  double get inventoryHealthPercentage {
    if (_products.isEmpty) return 100.0;
    return (healthyStockCount / _products.length) * 100;
  }

  List<ProductModel> get productsNeedingRestock {
    return _products.where((p) => p.needsRestock).toList()
      ..sort((a, b) => a.currentQuantity.compareTo(b.currentQuantity));
  }

  List<ProductModel> get criticalProducts {
    return _products
        .where((p) => p.stockStatus == StockStatus.critical ||
        p.stockStatus == StockStatus.outOfStock)
        .toList()
      ..sort((a, b) => a.currentQuantity.compareTo(b.currentQuantity));
  }

  List<ProductModel> get topProductsByValue {
    final sorted = List<ProductModel>.from(_products);
    sorted.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    return sorted.take(5).toList();
  }


  // Get products


  Map<String, List<ProductModel>> get productsByCategory {
    final map = <String, List<ProductModel>>{};
    for (final product in _products) {
      map.putIfAbsent(product.categoryId, () => []).add(product);
    }
    return map;
  }

  Map<String, int> get productCountByCategory {
    final map = <String, int>{};
    for (final product in _products) {
      map[product.categoryId] = (map[product.categoryId] ?? 0) + 1;
    }
    return map;
  }
  Map<String, double> get totalValueByCategory {
    final map = <String, double>{};
    for (final product in _products) {
      map[product.categoryId] = (map[product.categoryId] ?? 0) + product.totalValue;
    }
    return map;
  }

  bool isCategoryInUse(String categoryId) {
    return _products.any((p) => p.categoryId == categoryId);
  }

  // search or filter wala kam
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
  }

  void setStockStatusFilter(StockStatus? status) {
    _filterStockStatus = status;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // filters simply reset kar die
  void clearFilters() {
    _searchQuery = '';
    _filterCategoryId = null;
    _filterStockStatus = null;
    notifyListeners();
  }

  void resetFiltersAndSort() {
    _searchQuery = '';
    _filterCategoryId = null;
    _filterStockStatus = null;
    _sortOption = SortOption.nameAsc;
    notifyListeners();
  }

  // crud here
  // add
  void addProduct({
    required String name,
    required String sku,
    required String categoryId,
    required int initialQuantity,
    required int minThreshold,
    required double unitCost,
  }) {
    final product = ProductModel(
      id: Helpers.generateId(),
      name: name.trim(),
      sku: sku.trim().toUpperCase(),
      categoryId: categoryId,
      currentQuantity: initialQuantity,
      minThreshold: minThreshold,
      unitCost: unitCost,
    );

    _products.add(product);
    notifyListeners();
  }

  // upadte
  void updateProduct({
    required String id,
    String? name,
    String? sku,
    String? categoryId,
    int? minThreshold,
    double? unitCost,
  }) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _products[index] = _products[index].copyWith(
      name: name?.trim(),
      sku: sku?.trim().toUpperCase(),
      categoryId: categoryId,
      minThreshold: minThreshold,
      unitCost: unitCost,
    );
    notifyListeners();
  }

  // delete
  bool deleteProduct(String id) {
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);

    if (_products.length != initialLength) {
      notifyListeners();
      return true;
    }
    return false;
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  bool skuExists(String sku, {String? excludeId}) {
    return _products.any((p) =>
    p.sku.toLowerCase() == sku.toLowerCase() && p.id != excludeId);
  }


  // Add stock
  ProductModel? addStock(String productId, int quantity) {
    if (quantity <= 0) return null;

    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return null;

    _products[index] = _products[index].adjustStock(quantity);
    notifyListeners();
    return _products[index];
  }

  // Remove stock
  ProductModel? removeStock(String productId, int quantity) {
    if (quantity <= 0) return null;

    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return null;

    _products[index] = _products[index].adjustStock(-quantity);
    notifyListeners();
    return _products[index];
  }

  // Set stcok
  ProductModel? setStock(String productId, int newQuantity) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return null;

    _products[index] = _products[index].setStock(newQuantity);
    notifyListeners();
    return _products[index];
  }

  ProductModel? incrementStock(String productId) {
    return addStock(productId, 1);
  }

  ProductModel? decrementStock(String productId) {
    final product = getProductById(productId);
    if (product == null || product.currentQuantity <= 0) return null;
    return removeStock(productId, 1);
  }

  // major kam here

  void clearAll() {
    _products.clear();
    resetFiltersAndSort();
    notifyListeners();
  }

  void updateProductsCategory(String oldCategoryId, String newCategoryId) { // this is a really important function
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].categoryId == oldCategoryId) {
        _products[i] = _products[i].copyWith(categoryId: newCategoryId);
      }
    }
    notifyListeners();
  }
}
// enums
enum SortOption {
  nameAsc,
  nameDesc,
  valueHighToLow,
  valueLowToHigh,
  quantityHighToLow,
  quantityLowToHigh,
  recentlyUpdated,
}
// this was something new (took help from gpt)
extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.valueHighToLow:
        return 'Value (High to Low)';
      case SortOption.valueLowToHigh:
        return 'Value (Low to High)';
      case SortOption.quantityHighToLow:
        return 'Quantity (High to Low)';
      case SortOption.quantityLowToHigh:
        return 'Quantity (Low to High)';
      case SortOption.recentlyUpdated:
        return 'Recently Updated';
    }
  }
}