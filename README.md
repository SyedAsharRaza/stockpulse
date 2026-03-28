# 📦 StockPulse - Inventory Management System

> A comprehensive B2B inventory tracking solution built with Flutter and Provider state management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat\&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat\&logo=dart)
![Provider](https://img.shields.io/badge/State-Provider-green?style=flat)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)

---

## 🎯 Overview

StockPulse is a production-ready inventory management application designed for small to medium businesses. It provides real-time stock monitoring, intelligent low-stock alerts, comprehensive analytics, and a complete audit trail—all wrapped in a modern, intuitive interface with dark/light theme support.

Perfect for retail shops, warehouses, distributors, and any business needing efficient inventory control without the complexity of enterprise systems.

---

## ✨ Key Features

### 📊 Real-Time Dashboard

* **Live Metrics** - Total inventory value, critical alerts, health score, out-of-stock count
* **Quick Actions** - Inline stock adjustments for critical items
* **Activity Feed** - Recent transaction history at a glance
* **Time-Based Greeting** - Personalized user experience (Good Morning/Afternoon/Evening)

### 📦 Inventory Management

* **Full CRUD Operations** - Create, read, update, and delete products
* **Advanced Search** - Real-time search by product name or SKU
* **Multi-Criteria Filtering** - Filter by category and stock status simultaneously
* **7 Sort Options** - Name (A-Z/Z-A), Value (High/Low), Quantity (High/Low), Recently Updated
* **Inline Adjustments** - Quick +/- buttons on product cards
* **Auto-Generated SKU** - Intelligent SKU code generation based on product name
* **Form Validation** - Comprehensive input validation with helpful error messages

### 📈 Analytics & Insights

* **Total Valuation** - Real-time calculation of entire inventory worth
* **Health Distribution** - Visual progress bar showing stock status breakdown
* **Category Analysis** - Breakdown by category with percentages and progress indicators
* **Top Products** - Top 5 products ranked by total value
* **Transaction Stats** - Total items added, removed, and net change tracking

### 🗂️ Audit Trail

* **Complete History** - Every stock movement logged with timestamp
* **Date Filtering** - Presets for Today, Last 7 days, Last 30 days, All time
* **Type Filtering** - Filter by Added, Removed, or Adjusted transactions
* **Product Filtering** - View transaction history for specific products
* **Reason Tracking** - Track why stock changed (Sale, Restock, Damaged, Adjustment, etc.)
* **Chronological Grouping** - Transactions grouped by Today, Yesterday, or specific dates

### ⚙️ Settings & Customization

* **Theme Toggle** - Switch between dark and light modes with persistent state
* **Category Management** - Add, edit, delete categories with validation
* **Default Categories** - Quick setup with 6 pre-defined categories
* **Data Management** - Clear transaction history or reset all data
* **About Section** - App information and version details

---

## 🛠️ Tech Stack

| Category             | Technology         | Purpose                                       |
| -------------------- | ------------------ | --------------------------------------------- |
| **Framework**        | Flutter 3.0+       | Cross-platform UI development                 |
| **Language**         | Dart 3.0+          | Modern, type-safe programming                 |
| **State Management** | Provider           | Reactive state management with ChangeNotifier |
| **Architecture**     | Clean Architecture | Separation of concerns                        |
| **UI Design**        | Material Design 3  | Modern design system                          |
| **Typography**       | Google Fonts       | Poppins, Inter, JetBrains Mono                |
| **Data Storage**     | In-Memory          | Local state only                              |

---

## 📁 Project Structure

```
stockpulse/
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── models/
│   ├── providers/
│   ├── screens/
│   │   ├── dashboard/
│   │   ├── inventory/
│   │   ├── audit_trail/
│   │   ├── analytics/
│   │   └── settings/
│   │
│   ├── widgets/
│   └── main.dart
│
├── screenshots/
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK 3.0+
* Dart SDK 3.0+

### Installation

```bash
git clone https://github.com/SyedAsharRaza/stockpulse.git
cd stockpulse
flutter pub get
flutter run
```

---

## 📱 Screenshots

### Dashboard

![Dashboard](screenshots/dashboard.jpeg)

### Inventory Management

![Inventory](screenshots/inventory.jpeg)

### Analytics

<p align="center">
  <img src="screenshots/analytics1.jpeg" width="45%" />
  <img src="screenshots/analytics2.jpeg" width="45%" />
</p>

### Product Detail

![Product Detail](screenshots/product_detail.jpeg)

---

## 🧩 Provider Architecture

```
MultiProvider
├── ThemeProvider
├── CategoryProvider
├── InventoryProvider
└── TransactionProvider
```

---

## 🔮 Future Enhancements

* Backend integration (Firebase / APIs)
* Authentication & roles
* Barcode scanning
* Export reports (PDF/CSV)
* Notifications system

---

## 👨‍💻 Author

**Syed Ashar Raza**

* GitHub: [https://github.com/SyedAsharRaza](https://github.com/SyedAsharRaza)
* LinkedIn: [https://www.linkedin.com/in/ashar-raza-129484325/](https://www.linkedin.com/in/ashar-raza-129484325/)
* Email: [asharrazanaqvi@gmail.com](mailto:asharrazanaqvi@gmail.com)

---

## ⭐ Support

If you found this project helpful, consider giving it a star ⭐

---

<div align="center">

**Built with ❤️ using Flutter**

</div>
