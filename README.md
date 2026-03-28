

```markdown
# 📦 StockPulse - Inventory Management System

> A comprehensive B2B inventory tracking solution built with Flutter and Provider state management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![Provider](https://img.shields.io/badge/State-Provider-green?style=flat)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)

---

## 🎯 Overview

StockPulse is a production-ready inventory management application designed for small to medium businesses. It provides real-time stock monitoring, intelligent low-stock alerts, comprehensive analytics, and a complete audit trail—all wrapped in a modern, intuitive interface with dark/light theme support.

Perfect for retail shops, warehouses, distributors, and any business needing efficient inventory control without the complexity of enterprise systems.

---

## ✨ Key Features

### 📊 Real-Time Dashboard
- **Live Metrics** - Total inventory value, critical alerts, health score, out-of-stock count
- **Quick Actions** - Inline stock adjustments for critical items
- **Activity Feed** - Recent transaction history at a glance
- **Time-Based Greeting** - Personalized user experience (Good Morning/Afternoon/Evening)

### 📦 Inventory Management
- **Full CRUD Operations** - Create, read, update, and delete products
- **Advanced Search** - Real-time search by product name or SKU
- **Multi-Criteria Filtering** - Filter by category and stock status simultaneously
- **7 Sort Options** - Name (A-Z/Z-A), Value (High/Low), Quantity (High/Low), Recently Updated
- **Inline Adjustments** - Quick +/- buttons on product cards
- **Auto-Generated SKU** - Intelligent SKU code generation based on product name
- **Form Validation** - Comprehensive input validation with helpful error messages

### 📈 Analytics & Insights
- **Total Valuation** - Real-time calculation of entire inventory worth
- **Health Distribution** - Visual progress bar showing stock status breakdown
- **Category Analysis** - Breakdown by category with percentages and progress indicators
- **Top Products** - Top 5 products ranked by total value
- **Transaction Stats** - Total items added, removed, and net change tracking

### 🗂️ Audit Trail
- **Complete History** - Every stock movement logged with timestamp
- **Date Filtering** - Presets for Today, Last 7 days, Last 30 days, All time
- **Type Filtering** - Filter by Added, Removed, or Adjusted transactions
- **Product Filtering** - View transaction history for specific products
- **Reason Tracking** - Track why stock changed (Sale, Restock, Damaged, Adjustment, etc.)
- **Chronological Grouping** - Transactions grouped by Today, Yesterday, or specific dates

### ⚙️ Settings & Customization
- **Theme Toggle** - Switch between dark and light modes with persistent state
- **Category Management** - Add, edit, delete categories with validation
- **Default Categories** - Quick setup with 6 pre-defined categories
- **Data Management** - Clear transaction history or reset all data
- **About Section** - App information and version details

---

## 🛠️ Tech Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.0+ | Cross-platform UI development |
| **Language** | Dart 3.0+ | Modern, type-safe programming |
| **State Management** | Provider | Reactive state management with ChangeNotifier |
| **Architecture** | Clean Architecture | Separation of concerns (Models, Providers, Screens, Widgets) |
| **UI Design** | Material Design 3 | Modern, adaptive design system |
| **Typography** | Google Fonts | Poppins, Inter, JetBrains Mono |
| **Data Storage** | In-Memory | No backend required (local state only) |

---

## 📁 Project Structure

```
stockpulse/
│
├── lib/
│   ├── core/                               # Core configurations & utilities
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Color palette (dark/light themes)
│   │   │   └── app_text_styles.dart       # Typography system
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Material 3 theme configuration
│   │   │   └── theme_provider.dart        # Theme state management
│   │   └── utils/
│   │       └── helpers.dart               # Formatters, validators, calculators
│   │
│   ├── models/                             # Data models
│   │   ├── category_model.dart            # Product category entity
│   │   ├── product_model.dart             # Product with computed properties
│   │   └── transaction_model.dart         # Audit trail transaction
│   │
│   ├── providers/                          # State management
│   │   ├── category_provider.dart         # Category CRUD operations
│   │   ├── inventory_provider.dart        # Product CRUD, search, filters, metrics
│   │   ├── transaction_provider.dart      # Transaction logging & filtering
│   │   └── theme_provider.dart            # Theme switching logic
│   │
│   ├── screens/                            # Feature screens
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart      # Metrics, quick actions, activity feed
│   │   ├── inventory/
│   │   │   ├── inventory_screen.dart      # Product list with search & filters
│   │   │   ├── add_product_screen.dart    # Add/Edit product form
│   │   │   └── product_detail_screen.dart # Product details & history
│   │   ├── audit_trail/
│   │   │   └── audit_trail_screen.dart    # Transaction history
│   │   ├── analytics/
│   │   │   └── analytics_screen.dart      # Insights & metrics
│   │   └── settings/
│   │       └── settings_screen.dart       # Configuration
│   │
│   ├── widgets/                            # Reusable components
│   │   ├── common/                         # Shared widgets
│   │   ├── dashboard/                      # Dashboard-specific
│   │   └── inventory/                      # Inventory-specific
│   │
│   └── main.dart                           # App entry point
│
├── screenshots/                            # Application screenshots
├── pubspec.yaml                            # Dependencies
└── README.md                               # Documentation
```

### 🏗️ Architecture Highlights

| Layer | Purpose | Components |
|-------|---------|------------|
| **Core** | App-wide configuration | Theme, colors, typography, utilities |
| **Models** | Data structures | 3 immutable models with `copyWith` pattern |
| **Providers** | Business logic & state | 4 specialized providers with `ChangeNotifier` |
| **Screens** | Feature modules | 5 main screens organized by feature |
| **Widgets** | Reusable UI | 11 custom components for consistency |

---

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK: 3.0.0 or higher
Dart SDK: 3.0.0 or higher
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/stockpulse.git
   cd stockpulse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   # Android
   flutter build apk --release

   # iOS
   flutter build ios --release

   # Web
   flutter build web --release
   ```

---

## 📱 Screenshots

### Dashboard
![Dashboard](screenshots/dashboard.jpeg)
*Real-time metrics, critical stock alerts, and recent activity feed*

### Inventory Management
![Inventory](screenshots/inventory.jpeg)
*Product list with search, filters, and inline stock adjustments*

### Analytics Overview
![Analytics Overview](screenshots/analytics1.jpeg)
*Total inventory value and stock health distribution*

### Analytics Details
![Analytics Details](screenshots/analytics2.jpeg)
*Category breakdown and top products ranking*

### Product Details
![Product Detail](screenshots/product_detail.jpeg)
*Detailed product view with transaction history and quick actions*

---

## 🎨 Design System

### Color Palette

| Mode | Background | Surface | Primary | Success | Warning | Error |
|------|-----------|---------|---------|---------|---------|-------|
| **Dark** | `#121212` | `#1E1E1E` | `#3B82F6` | `#10B981` | `#F59E0B` | `#EF4444` |
| **Light** | `#F9FAFB` | `#FFFFFF` | `#2563EB` | `#059669` | `#D97706` | `#DC2626` |

### Typography

- **Headings**: Poppins (Bold 700, SemiBold 600)
- **Body Text**: Inter (Regular 400, Medium 500)
- **Data/Metrics**: JetBrains Mono (for numbers and codes)

### Stock Status Logic

```dart
Out of Stock  → quantity = 0
Critical      → quantity ≤ min threshold
Low Stock     → quantity ≤ min threshold × 2
Healthy       → quantity > min threshold × 2
```

---

## 🧩 Provider Architecture

```
MultiProvider
├── ThemeProvider          → App-wide theme state
├── CategoryProvider       → Category CRUD operations
├── InventoryProvider      → Product management & business logic
└── TransactionProvider    → Transaction logging & filtering
```

### Key Design Patterns

- **Immutable State** - Using `copyWith` pattern for predictable updates
- **Computed Properties** - Real-time metrics calculated via getters
- **Separation of Concerns** - Models, Providers, Screens, Widgets clearly separated
- **Reactive UI** - `Consumer` widgets for efficient rebuilds
- **Single Responsibility** - Each provider handles one domain

### Business Logic Examples

**Total Inventory Value:**
```dart
double get totalInventoryValue =>
    _products.fold(0, (sum, product) => sum + product.totalValue);
```

**Health Percentage:**
```dart
double get inventoryHealthPercentage {
  if (_products.isEmpty) return 100.0;
  return (healthyStockCount / _products.length) * 100;
}
```

**Search & Filter:**
```dart
List<ProductModel> get filteredProducts {
  var result = List.from(_products);
  
  // Apply search
  if (_searchQuery.isNotEmpty) {
    result = result.where((p) => 
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.sku.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }
  
  // Apply category filter
  if (_filterCategoryId != null) {
    result = result.where((p) => p.categoryId == _filterCategoryId).toList();
  }
  
  // Apply stock status filter
  if (_filterStockStatus != null) {
    result = result.where((p) => p.stockStatus == _filterStockStatus).toList();
  }
  
  return _applySorting(result);
}
```

---

## 📊 Features in Detail

### Dashboard Metrics

| Metric | Description | Calculation |
|--------|-------------|-------------|
| **Total Value** | Sum of all inventory value | `Σ(quantity × unit_cost)` |
| **Alerts** | Products needing attention | Critical + Low stock count |
| **Health Score** | Inventory health percentage | `(Healthy / Total) × 100` |
| **Out of Stock** | Items with zero quantity | Count where `qty = 0` |

### Search & Filter Options

- **Search**: Real-time by product name or SKU
- **Category Filter**: Electronics, Furniture, Office Supplies, etc.
- **Status Filter**: All, Healthy, Low, Critical, Out of Stock
- **Sort Options**:
  - Name (A-Z / Z-A)
  - Value (High to Low / Low to High)
  - Quantity (High to Low / Low to High)
  - Recently Updated

### Transaction Types & Reasons

**Types:**
- Stock Added
- Stock Removed
- Stock Adjusted

**Reasons:**
- Sale
- Restock
- Damaged
- Returned
- Adjustment
- Other

---

## 🔮 Future Enhancements

- [ ] **Backend Integration** - Firebase/Supabase/REST API support
- [ ] **User Authentication** - Multi-user support with role-based access
- [ ] **Barcode Scanning** - Quick product lookup via barcode/QR code
- [ ] **Export Reports** - PDF and CSV export functionality
- [ ] **Push Notifications** - Real-time alerts for low stock
- [ ] **Product Images** - Image upload with cloud storage
- [ ] **Supplier Management** - Track suppliers and purchase orders
- [ ] **Sales Analytics** - Revenue tracking and forecasting
- [ ] **Multi-Location Support** - Manage inventory across locations
- [ ] **Batch Operations** - Bulk product updates and imports

---

## 📚 What I Learned

Building StockPulse taught me:

✅ **Advanced Provider State Management** - Managing complex state across multiple providers  
✅ **Clean Architecture** - Organizing code for scalability and maintainability  
✅ **Complex Filtering Logic** - Implementing multi-criteria search and filters  
✅ **Computed Properties** - Real-time calculations with efficient getters  
✅ **Custom Theming** - Building a complete design system with dark/light modes  
✅ **Form Validation** - Handling user input with proper validation patterns  
✅ **Transaction Patterns** - Implementing comprehensive audit trails  
✅ **UI/UX Best Practices** - Creating intuitive, professional interfaces  
✅ **Git Workflow** - Professional commit history and version control  

---

## 🤝 Contributing

This is a personal learning project, but suggestions and feedback are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**[Syed Ashar Raza]**

- 🐱 GitHub: (https://github.com/SyedAsharRaza)
- 💼 LinkedIn: (https://www.linkedin.com/in/ashar-raza-129484325/)
- 📧 Email: asharazanaqvi@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for UI/UX guidelines
- Provider package maintainers
- The Flutter community for inspiration and support
- Google Fonts for beautiful typography

---

## ⭐ Support

If you found this project helpful or interesting, please consider giving it a star! It helps others discover the project and motivates further development.

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#-stockpulse---inventory-management-system)

</div>
```

---

---

**DONE! Your README is now beautiful and professional!** 🎉✨
