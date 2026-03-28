# StockPulse - Inventory Management System

A modern, production-ready inventory management application built with Flutter and Provider state management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![Provider](https://img.shields.io/badge/State-Provider-green)

## About

StockPulse is a comprehensive B2B inventory tracking solution designed for small to medium businesses. It provides real-time stock monitoring, intelligent alerts, and detailed analytics in a modern, intuitive interface.

## Features

### Core Functionality
- **Real-time Inventory Tracking** - Monitor stock levels with automated alerts
- **Advanced Search & Filters** - Multi-criteria filtering by name, SKU, category, and status
- **Comprehensive Analytics** - Health metrics, category insights, and value tracking
- **Complete Audit Trail** - Full transaction history with advanced filtering
- **Dark/Light Theme** - Persistent theme switching with Material Design 3
- **Offline-First** - Pure client-side state management (no backend required)

### Dashboard
- Live inventory value calculation
- Critical stock alerts with quick actions
- Health score percentage tracking
- Recent transaction activity feed

### Inventory Management
- Complete CRUD operations
- Real-time search by name or SKU
- Multi-criteria filtering and sorting
- Inline stock adjustments
- Auto-generated SKU codes
- Form validation

### Analytics
- Total inventory valuation
- Stock health distribution
- Category-wise breakdown
- Top 5 products by value
- Transaction statistics

### Audit Trail
- Complete transaction history
- Date range filtering
- Transaction type filtering
- Product-specific history
- Chronological grouping

## Tech Stack

- **Framework:** Flutter 3.0+
- **Language:** Dart 3.0+
- **State Management:** Provider (MultiProvider architecture)
- **Architecture:** Clean Architecture with separation of concerns
- **UI/UX:** Material Design 3 with custom design system
- **Typography:** Google Fonts (Poppins, Inter, JetBrains Mono)

## Project Structure
lib/
├── core/ # App-wide configurations
│ ├── constants/ # Colors, text styles
│ ├── theme/ # Theme data and provider
│ └── utils/ # Helper functions
├── models/ # Data models
├── providers/ # State management (4 providers)
├── screens/ # Feature screens
│ ├── dashboard/
│ ├── inventory/
│ ├── audit_trail/
│ ├── analytics/
│ └── settings/
└── widgets/ # Reusable UI components

text


## Getting Started

### Prerequisites
Flutter SDK: 3.0.0+
Dart SDK: 3.0.0+

text


### Installation

1. Clone the repository
```bash
git clone https://github.com/SyedAsharRaza/stockpulse.git
cd stockpulse
Install dependencies
Bash

flutter pub get
Run the app
Bash

flutter run
## Screenshots

### Dashboard
![Dashboard](screenshots/dashboard.jpeg)

### Inventory Management
![Inventory](screenshots/inventory.jpeg)

### Analytics
![Analytics](screenshots/analytics1.jpeg)
![Analytics](screenshots/analytics2.jpeg)

### Product Details
![Product Detail](screenshots/product_detail.jpeg)

State Management Architecture
Providers
ThemeProvider - Manages app theme state
CategoryProvider - Handles product categories
InventoryProvider - Core product CRUD and business logic
TransactionProvider - Transaction logging and filtering
Key Design Patterns
Immutable state using copyWith pattern
Computed properties for dynamic metrics
Separation of concerns (Models, Providers, Screens, Widgets)
Reactive UI with Consumer widgets
Features in Detail
Business Logic
Stock status calculation:

dart

- Out of Stock: quantity = 0
- Critical: quantity <= min threshold
- Low: quantity <= min threshold × 2
- Healthy: quantity > min threshold × 2
Inventory metrics:

dart

- Total Value: Sum of (quantity × unit cost) for all products
- Health Score: (Healthy products / Total products) × 100
- Alerts: Count of Critical + Low stock items
Search & Filter
Real-time search by product name or SKU
Filter by category (Electronics, Furniture, Office Supplies, etc.)
Filter by stock status (All, Healthy, Low, Critical, Out of Stock)
Sort by Name, Value, Quantity, Recently Updated
Future Enhancements
Backend integration (Firebase/REST API)
User authentication and multi-user support
Barcode scanning for products
Export reports (PDF/CSV)
Push notifications for low stock alerts
Product images with cloud storage
Supplier management
Purchase order tracking
Learning Outcomes
This project demonstrates:

Advanced Flutter state management with Provider
Clean architecture implementation
Complex filtering and search algorithms
Real-time data calculations
Custom theming and design systems
Form validation and error handling
Transaction logging patterns
Author
Syed Ashar Raza

GitHub: https://github.com/SyedAsharRaza 
LinkedIn: https://www.linkedin.com/in/ashar-raza-129484325/
Email: asharrazanaqvi@gmail.com
License
This project is open source and available under the MIT License.

Acknowledgments
Flutter team for the amazing framework
Material Design for UI/UX guidelines
Provider package maintainers
The Flutter community
If you found this project helpful, please consider giving it a star!

Built with Flutter and Provider.