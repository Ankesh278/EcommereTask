# AuraWear Fashion — Clean Architecture & Cubit E-Commerce App

A production-grade, highly structured Flutter e-commerce application built with **Clean Architecture** and **`flutter_bloc` with Cubit exclusively** for state management.

---

## 🌟 Architecture Overview

This project strictly adheres to **Clean Architecture** and separation of concerns across feature modules:

```text
lib/
├── core/                               # Cross-cutting concerns & shared components
│   ├── constants/                      # Colors, route names, credentials
│   ├── errors/                         # Typed Failures & Exceptions
│   ├── theme/                          # Material 3 application theme
│   ├── utils/                          # Validators & functional Result types
│   └── widgets/                        # Reusable UI components (Buttons, Fields, SnackBar)
│
├── features/
│   ├── auth/                           # Authentication Feature
│   │   ├── data/                       # Data sources, models, repository implementations
│   │   ├── domain/                     # Entities, repository contracts, login use case
│   │   └── presentation/               # AuthCubit, AuthState, LoginPage, LoginForm
│   │
│   ├── products/                       # Products Feature
│   │   ├── data/                       # Local data source with static items, models
│   │   ├── domain/                     # ProductEntity, repository contract, use cases
│   │   └── presentation/               # ProductCubit, ProductState, ProductListingPage, ProductCard
│   │
│   └── cart/                           # Cart Feature
│       ├── domain/                     # CartItemEntity
│       └── presentation/               # CartCubit, CartState, CartPage, CartItemCard, SummaryBar
│
├── injection_container.dart             # Dependency injection container via get_it
├── app.dart                            # MultiBlocProvider, root MaterialApp & routing
└── main.dart                           # App initialization & bootstrapping
```

### Layer Responsibilities

1. **Domain Layer (Core Business Logic)**
   - **Entities**: Pure Dart objects representing domain models (`UserEntity`, `ProductEntity`, `CartItemEntity`). Contains zero dependencies on Flutter or data storage.
   - **Repositories (Contracts)**: Abstract interfaces defining operations without knowledge of where data comes from (`AuthRepository`, `ProductRepository`).
   - **Use Cases**: Encapsulate single executable business actions (`LoginUseCase`, `GetProductsUseCase`).

2. **Data Layer (Data Retrieval & Mapping)**
   - **Data Sources**: Concrete implementations querying local/static storage (`AuthLocalDataSource`, `ProductLocalDataSource`).
   - **Models**: Data transfer objects extending Domain Entities with JSON serialization (`UserModel`, `ProductModel`).
   - **Repository Implementations**: Implement domain repository contracts and handle mapping exceptions into typed `Failure` objects.

3. **Presentation Layer (UI & State Management)**
   - **Cubits**: Manage state transitions by extending `Cubit<State>`. Pure business logic without any UI widget dependency.
   - **States**: Immutable, value-equal classes extending `Equatable`.
   - **Pages & Widgets**: Declarative UI responding to states via `BlocProvider`, `BlocBuilder`, `BlocConsumer`, and `BlocListener`. Local widget state is restricted strictly to transient UI concerns (e.g. password visibility toggle).

4. **Dependency Injection & Shared State**
   - Configured in `injection_container.dart` using `get_it`.
   - `CartCubit` is registered as a **LazySingleton** and provided at the root of `MaterialApp` in `app.dart`. This guarantees a single, persistent cart state across navigation between product listing and cart screens.

---

## 🔑 State Management Rules Followed

- **Strictly Cubit**: Uses `flutter_bloc`'s `Cubit` exclusively (no event classes or `Bloc` base classes).
- **Immutable States**: All state classes extend `Equatable` with value equality.
- **Zero Business Logic in UI**: Form validation, authentication checks, cart computations, and product fetching live exclusively in Cubits and Use Cases.
- **No `setState` for App State**: `setState()` is only used for transient local UI states (such as toggling password obfuscation).
- **Shared Cart Lifecycle**: `CartCubit` persists across routes; items, badge counts, and totals remain intact when switching screens.

---

## 🔐 Configurable Dummy Login Credentials

| Field | Demo Value |
|---|---|
| **Email** | `user@example.com` |
| **Password** | `password123` |
| **User Name** | Alex Morgan |

> 💡 **Tip**: The login screen includes an **"Auto Fill"** shortcut button that automatically populates the demo credentials with a single tap for effortless testing!

---

## 📱 Implemented Screens & Features

### 1. Login Screen (`LoginPage`)
- Email & password text fields with validation feedback.
- Password visibility toggle (show/hide eye icon).
- Prevents invalid submissions (validates mandatory fields and email format).
- Animated loading indicator on button during sign-in.
- Navigation to Product Listing screen upon successful authentication via `BlocListener`.
- Error snackbars for failed attempts or invalid inputs.

### 2. Product Listing Screen (`ProductListingPage`)
- Displays 6 clothing products loaded from local/static data source:
  1. Heritage Denim Jacket ($89.99)
  2. Premium Pima Crewneck T-Shirt ($34.50)
  3. Slim Stretch Chino Pants ($59.00)
  4. Merino Wool Ribbed Sweater ($98.00)
  5. Urban Technical Hooded Parka ($149.95)
  6. Classic Oxford Cotton Shirt ($48.00)
- Reusable `ProductCard` with image loading fallback, category badge, rating star, and price.
- Dynamic "Add to Cart" button with quantity indicator.
- Top AppBar with shopping cart badge reflecting live `totalItemCount` from `CartCubit`.
- Pull-to-refresh and logout confirmation dialog.

### 3. Shopping Cart Screen (`CartPage`)
- Lists all items added to cart with thumbnails, unit prices, and line subtotals.
- **Quantity Controls**: `+` (increment) and `-` (decrement).
- **Auto-Removal**: Decrementing an item at quantity 1 automatically removes it from the cart.
- **Direct Removal**: Trash button removes item completely.
- **Duplicate Prevention**: Adding an already existing item increases its quantity instead of adding a duplicate row.
- **Order Summary Bottom Bar**: Live calculation of total items, free shipping, and grand total price.
- **Empty Cart State (`EmptyCartView`)**: Clean illustration with a "Start Shopping" button when cart is empty.
- **Checkout Dialog**: Mock checkout flow that confirms order details and resets cart.

---

## 🛠️ Getting Started & Commands

### Prerequisites
- Flutter SDK `^3.12.1` or newer (`Flutter 3.44.1` / Dart `3.12.1` tested)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Static Analysis
Verify that there are zero lint issues and zero analyzer warnings:
```bash
flutter analyze
```

### 3. Run Automated Tests
Execute the full suite of unit and widget tests:
```bash
flutter test
```

### 4. Run the Application
Launch the app on your connected device or simulator:
```bash
flutter run
```

---

## 🧪 Testing Suite Overview

The project features comprehensive test coverage across all features:

| Test File | Layer | What It Verifies |
|---|---|---|
| `login_usecase_test.dart` | Auth Domain | Success and Failure resolution through repository |
| `auth_cubit_test.dart` | Auth Presentation | Email/password validation, preventing invalid attempts, state transitions (`AuthInitial` -> `AuthLoading` -> `AuthSuccess` / `AuthFailureState`), reset |
| `get_products_usecase_test.dart` | Products Domain | Repository delegation and Result handling |
| `product_cubit_test.dart` | Products Presentation | Loading at least 5 products, loading states, error handling |
| `cart_cubit_test.dart` | Cart Presentation | Initial empty state, adding products, duplicate prevention, increment, decrement, auto-removal at zero quantity, direct removal, clearing, badge count and total calculations |
| `product_card_test.dart` | Widgets | Product rendering, image fallback, Add to Cart callback |
| `cart_item_card_test.dart` | Widgets | Item layout, pricing, increment, decrement, and remove buttons |
| `login_page_test.dart` | Widgets | Form elements, empty input validation errors, demo auto-fill |

All **30 tests** pass cleanly with 100% success.

---

## 📹 Demo Video Recording Checklist

Use this checklist when recording your screen demonstration for submission:

- [ ] **1. Login Validation & Error Handling**
  - Tap "Sign In" with empty fields: Observe validation errors ("Email is required", "Password is required").
  - Enter an invalid email format (e.g. `test`): Observe format validation message.
  - Enter wrong password: Tap Sign In, observe loading indicator followed by error snackbar.
- [ ] **2. Successful Login & Navigation**
  - Tap "Auto Fill" (or type `user@example.com` / `password123`).
  - Tap "Sign In".
  - Observe brief loading state, welcome snackbar, and automated navigation to the Product Listing screen.
- [ ] **3. Product Listing & Badge Count**
  - Scroll through the clothing catalog (at least 6 products visible with images, ratings, categories, and prices).
  - Tap "Add" on a product: Observe success feedback and top-right cart badge count update to `1`.
  - Tap "Add" on the same product again: Observe badge count increase to `2` and button label show `(2)`.
  - Add two different items to the cart: Observe cart badge update to `4`.
- [ ] **4. Navigation & Cart State Preservation**
  - Tap the Cart icon in the AppBar to navigate to the Cart Screen.
  - Verify that all selected products and quantities are preserved.
- [ ] **5. Cart Quantity Updates & Auto-Removal**
  - Tap `+` on an item: Observe quantity and subtotal increase immediately; total price updates.
  - Tap `-` on an item with quantity > 1: Observe quantity decrease.
  - Tap `-` on an item with quantity 1: Verify that the item is **automatically removed** from the cart.
- [ ] **6. Direct Removal & Calculations**
  - Tap the Trash icon on an item: Verify immediate removal and recalculated grand total.
- [ ] **7. Empty Cart State**
  - Remove all remaining items or tap "Clear": Verify the `EmptyCartView` appears with "Your cart is empty".
  - Tap "Start Shopping": Verify navigation returns to the Product Listing screen.
- [ ] **8. Re-entry Verification & Checkout**
  - Add an item again, open the cart, and tap "Proceed to Checkout".
  - Verify confirmation dialog showing total items and amount paid, then confirm.

---

## 🚀 GitHub Submission Preparation Instructions

Follow these steps to submit your project to GitHub:

1. **Check Git Status**
   ```bash
   git status
   ```

2. **Add All Modified and Created Files**
   ```bash
   git add .
   ```

3. **Commit with a Clean, Professional Message**
   ```bash
   git commit -m "feat: complete e-commerce app using Clean Architecture and Cubit"
   ```

4. **Add Your GitHub Remote (if not already set)**
   ```bash
   git remote add origin https://github.com/<your-username>/<your-repo-name>.git
   ```

5. **Push to Your Main Branch**
   ```bash
   git branch -M main
   git push -u origin main
   ```
