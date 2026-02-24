import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../core/utils/helpers.dart';

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];



  List<CategoryModel> get categories => List.unmodifiable(_categories);

  // alphabetical order
  List<CategoryModel> get categoriesSorted {
    final sorted = List<CategoryModel>.from(_categories);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  int get categoryCount => _categories.length;

  bool get hasCategories => _categories.isNotEmpty;

  bool categoryExists(String name, {String? excludeId}) {
    return _categories.any((cat) =>
    cat.name.toLowerCase() == name.toLowerCase() && cat.id != excludeId);
  }

  // crud
  // add
  void addCategory(String name) {
    if (name.trim().isEmpty) return;
    if (categoryExists(name)) return;

    final category = CategoryModel(
      id: Helpers.generateId(),
      name: name.trim(),
    );

    _categories.add(category);
    notifyListeners();
  }

  // update
  void updateCategory(String id, String newName) {
    if (newName.trim().isEmpty) return;
    if (categoryExists(newName, excludeId: id)) return;

    final index = _categories.indexWhere((cat) => cat.id == id);
    if (index == -1) return;

    _categories[index] = _categories[index].copyWith(name: newName.trim());
    notifyListeners();
  }

  // delete
  bool deleteCategory(String id) {
    final initialLength = _categories.length;
    _categories.removeWhere((cat) => cat.id == id);

    if (_categories.length < initialLength) {
      notifyListeners();
      return true;
    }
    return false;
  }

  // get category by id
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  // get category name by id
  String getCategoryName(String id) {
    final category = getCategoryById(id);
    return category?.name ?? 'Unknown';
  }

  // asal kaam
  void addDefaultCategories() {
    final defaults = [
      'Electronics',
      'Furniture',
      'Office Supplies',
      'Raw Materials',
      'Packaging',
      'Tools & Equipment',
    ]; // ye default rakh raha hu filhal, future me user se bhi le sakte hai

    for (final name in defaults) {
      if (!categoryExists(name)) {
        addCategory(name);
      }
    }
  }

  void clearAll() {
    _categories.clear();
    notifyListeners();
  }
}