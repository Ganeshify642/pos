# DeliveryBill 🧾

> Offline-first billing & inventory management app for food delivery businesses.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)
![Offline](https://img.shields.io/badge/Mode-100%25%20Offline-orange)

---

## Features

- 🧾 **Order Management** — Create orders for Offline, Swiggy, Zomato, or any delivery app
- 💸 **Auto Invoice PDF** — Professional invoices generated instantly after each order
- 📦 **Inventory Tracking** — Daily prep setup, real-time sold-qty deduction, low-stock alerts
- 📊 **Reports & Analytics** — Revenue by source, platform commission tracking, top items
- 🍽️ **Menu Management** — Categories and items with availability toggle
- ⚙️ **Settings** — Business info, tax (SGST/CGST/IGST), delivery app commission rates
- 🌙 **Dark Mode** — Dark-first design with light mode option
- 📴 **100% Offline** — No internet required at any point

---

## Architecture

```
MVVM pattern with Provider state management

lib/
├── data/
│   ├── database/      # Drift ORM (SQLite)
│   └── repositories/  # Data access layer
├── providers/         # ChangeNotifier ViewModels
├── services/          # Business logic (invoice, calculations)
├── screens/           # UI screens
├── widgets/           # Reusable widgets
├── models/            # Plain Dart models
└── utils/             # Colors, theme, constants, formatters
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode (for device deployment)

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Drift database code
dart run build_runner build

# 3. Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS required)
flutter build ios --release
```

---

## Key Packages

| Package | Purpose |
|---|---|
| `drift` + `drift_flutter` | SQLite database ORM |
| `provider` | State management (MVVM) |
| `pdf` + `printing` | Invoice PDF generation & viewing |
| `share_plus` | Share invoices via WhatsApp/Email |
| `fl_chart` | Revenue and order charts |
| `google_fonts` | Inter font family |
| `path_provider` | Document directory for invoice storage |

---

## Order Flow

1. **Select source** → Offline / Swiggy / Zomato / Other
2. **Add items** → Category tabs, search, quantity steppers with live stock check
3. **Checkout** → Tax/commission breakdown, payment method, complete order
4. **Invoice** → Auto-generated PDF, view in-app or share

---

## Invoice Storage

Invoices are saved to:
- **Android**: `/data/user/0/com.deliverybill.delivery_bill/app_flutter/invoices/`
- **iOS**: `<App Documents>/invoices/`

File naming: `ORDER_ORD-001_20260818.pdf`

---

## Sample Data

On first launch, the app seeds:
- 6 default categories (Starters, Main Course, Breads, Rice & Biryani, Beverages, Desserts)
- 12 sample menu items with prices
- Default Swiggy commission: 18%
- Default Zomato commission: 18%
- Tax: SGST 9% + CGST 9%

---

## Screenshots

> Run the app and explore:
> - Dashboard with revenue summary
> - Create order wizard (3 steps)
> - Morning inventory setup
> - PDF invoice preview

---

## License

MIT License — Built for offline food delivery billing.
