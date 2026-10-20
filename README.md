# AuraWear Fashion — Clean Architecture & Cubit E-Commerce App

A production-grade, highly structured Flutter e-commerce application built with **Clean Architecture** and **`flutter_bloc` with Cubit exclusively** for state management.

---

## 🌟 Architecture Overview

This project strictly adheres to **Clean Architecture** and separation of concerns across feature modules:

```text
lib/
├── core/                               # Cross-cutting concerns & shared components
│   ├── constants/                      # AppConstants, AppColors, AppDimensions
│   ├── errors/                         # Typed Failures (Equatable) & Exceptions
│   ├── providers/                      # AppProviders (MultiBlocProvider wrapper)
│   ├── routes/                         # AppRouteNames, AppRouter (clean separated routing)
│   ├── theme/                          # AppColors, AppTheme, AppTextStyles
│   ├── utils/                          # InputValidators & functional Result types
│   └── widgets/                        # AppButton, AppTextField, PriceText, Reusable UI
│
├── features/
│   ├── auth/                           # Authentication Feature
│   │   ├── data/                       # Local data source with demo credentials, UserModel, AuthRepositoryImpl
│   │   ├── domain/                     # UserEntity, AuthRepository contract, LoginUseCase
│   │   └── presentation/               # AuthCubit, AuthState, LoginPage, LoginForm
│   │
│   ├── products/                       # Products Feature
│   │   ├── data/                       # ProductLocalDataSource (8 static clothing items), ProductModel, ProductRepositoryImpl
│   │   ├── domain/                     # ProductEntity, ProductRepository contract, GetProductsUseCase
│   │   └── presentation/               # ProductCubit, ProductState, ProductListingPage, ProductCard, CartBadgeIcon
│   │
│   └── cart/                           # Cart Feature
│       ├── domain/                     # CartItemEntity, CalculateCartTotalUseCase
│       └── presentation/               # CartCubit, CartState, CartPage, CartItemCard, CartSummaryBottomBar, EmptyCartView
│
├── injection_container.dart             # Dependency injection container via get_it
├── app.dart                            # Root MaterialApp & provider/router coordination
└── main.dart                           # App initialization & bootstrapping

test/
└── widget_test.dart                    # App smoke test verifying startup and injection
```

### Layer Responsibilities

1. **Domain Layer (Core Business Logic)**
   - **Entities**: Pure Dart objects representing domain models (`UserEntity`, `ProductEntity`, `CartItemEntity`). Contains zero dependencies on Flutter widgets or data storage.
   - **Repositories (Contracts)**: Abstract interfaces defining operations without knowledge of where data comes from (`AuthRepository`, `ProductRepository`).
   - **Use Cases**: Encapsulate single executable business actions (`LoginUseCase`, `GetProductsUseCase`, `CalculateCartTotalUseCase`).

2. **Data Layer (Data Retrieval & Mapping)**
   - **Data Sources**: Concrete implementations querying local/static storage (`AuthLocalDataSource`, `ProductLocalDataSource`).
   - **Models**: Data transfer objects extending Domain Entities with JSON serialization (`UserModel`, `ProductModel`).
   - **Repository Implementations**: Implement domain repository contracts and handle mapping exceptions into typed `Failure` objects (`AuthRepositoryImpl`, `ProductRepositoryImpl`).

3. **Presentation Layer (UI & State Management)**
   - **Cubits**: Manage state transitions by extending `Cubit<State>`. Pure business logic without any UI widget dependency (`AuthCubit`, `ProductCubit`, `CartCubit`).
   - **States**: Immutable, value-equal classes extending `Equatable`.
   - **Pages & Widgets**: Declarative UI responding to states via `BlocProvider`, `BlocBuilder`, `BlocConsumer`, and `BlocListener`. Local widget state is restricted strictly to transient UI concerns (e.g. password visibility toggle and form dynamic validation).

4. **Dependency Injection & Shared State**
   - Configured in `injection_container.dart` using `get_it`.
   - `CartCubit` is registered as a **LazySingleton** and provided at the root of `MaterialApp` in `app.dart`. This guarantees a single, persistent cart state across navigation between product listing and cart screens.

---

## 🔑 State Management Rules Followed

- **Strictly Cubit**: Uses `flutter_bloc`'s `Cubit` exclusively (no event classes or `Bloc` base classes).
- **Immutable States**: All state classes extend `Equatable` with value equality.
- **Zero Business Logic in UI**: Form validation, authentication checks, cart computations, and product fetching live exclusively in Cubits and Use Cases.
- **No `setState` for App State**: `setState()` is only used for transient local UI states (such as toggling password obfuscation and inline validation updates).
- **Shared Cart Lifecycle**: `CartCubit` persists across routes; items, badge counts, and totals remain intact when switching screens.

---

## 🔐 Configurable Demo Login Credentials

Configured in `AppConstants`:

| Field | Demo Value | Alternative Dummy Value |
|---|---|---|
| **Email** | `demo@example.com` | `user@example.com` |
| **Password** | `Demo@123` | `password123` |
| **User Name** | Demo Shopper | Alex Morgan |

> 💡 **Tip**: The login screen includes an **"Auto Fill"** shortcut button that automatically populates the demo credentials with a single tap for effortless testing!

---

## 📱 Implemented Screens & Features

### 1. Login Screen (`LoginPage`)
- Application brand mark with shopping bag badge.
- App name ("AuraWear Fashion") and welcoming subtitle.
- Balanced outer padding giving email/password fields and Login button full usable width on mobile.
- Email input field with trimming and regex format validation.
- Password input field (hidden by default) with working eye icon visibility toggle (preserves value).
- **Dynamic Submit Button**: Disabled until both fields contain valid input; updates enabled state as user types.
- **Subtle Demo Credentials Section**: Compact, non-intrusive container with secondary styling and a 1-tap "Auto Fill" button.
- Animated loading indicator on button during authentication.
- Navigation to Product Listing screen upon successful authentication via `BlocListener`.
- Error snackbar feedback for invalid credentials.

### 2. Product Listing Screen (`ProductListingPage`)
- Header with branding, "Exclusive Collection" badge, live cart badge, and polished logout action.
- Displays **8 realistic static clothing products** formatted with **INR (`₹`)** currency:
  1. **Classic Cotton T-Shirt** — ₹799
  2. **Oversized Graphic T-Shirt** — ₹999
  3. **Casual Denim Jacket** — ₹2,499
  4. **Slim Fit Jeans** — ₹1,799
  5. **Premium Hoodie** — ₹1,999
  6. **Casual Linen Shirt** — ₹1,299
  7. **Sports Sneakers** — ₹2,999
  8. **Everyday Backpack** — ₹1,499
- Reusable `ProductCard` with image loading fallback, category badge, rating star, and price.
- **Reusable Product Details Bottom Sheet (`ProductDetailsBottomSheet`)**:
  - Tapping a product card opens a modal bottom sheet with drag handle, close affordance, large image, category, rating, full description, price, and fixed Add to Cart CTA.
  - Adding from the sheet updates the cart immediately and preserves synchronized state.
- **Direct Card Add to Cart**: Tapping "Add" on a card adds directly to the cart without opening the bottom sheet.
- **Contextual Floating Cart Button (`FloatingCartButton`)**:
  - Automatically animates into view when the cart contains $\ge 1$ item.
  - Hides smoothly when the cart is emptied.
  - Displays live item count, total price, and navigates directly to the Cart Screen.
  - Padded list viewport ensures the last product is never obstructed by the floating CTA.
- **Polished Logout Confirmation Dialog (`LogoutConfirmationDialog`)**:
  - Native confirmation dialog with styled logout icon, clear confirmation copy, and balanced Cancel/Log Out actions.

### 3. Shopping Cart Screen (`CartPage`)
- Header with live item count subtitle and "Clear" action.
- Lists all items added to cart using refined `CartItemCard` with thumbnails, unit prices, quantity controls, line subtotals (`Product price × quantity`), and trash action.
- **Quantity Controls**: `+` (increment) and `-` (decrement).
- **Auto-Removal**: Decrementing an item at quantity 1 automatically removes it from the cart.
- **Direct Removal**: Trash button removes item completely.
- **Duplicate Prevention**: Adding an already existing item increases its quantity instead of adding a duplicate row.
- **Derived Order Summary Bar**:
  - Distinct Products Count (`distinctProductCount`)
  - Total Items Quantity (`totalItemCount`)
  - Grand Total Cart Amount in INR integer arithmetic (`₹${totalPrice.toInt()}`)
  - No artificial charges; all figures honestly derived from cart state.
- **Empty Cart State (`EmptyCartView`)**: Clean illustration with a "Continue Shopping" button that returns to the Product Listing screen.
- **Checkout Dialog**: Honest placeholder informing the user that checkout is not implemented in this demo.

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

### 4. Build Android Debug APK
Compile the verified debug APK:
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### 5. Run the Application
Launch the app on your connected device, emulator, or simulator:
```bash
flutter run
```

---

## 🧪 Testing Suite Overview

The project features a standard Flutter smoke and widget test verifying app startup, dependency injection, and initial widget tree mounting:

| Test File | Target | What It Verifies |
|---|---|---|
| `widget_test.dart` | Smoke / Widget Test | Initializes dependencies via `initDependencies()`, pumps `EcommerceApp`, and verifies app tree renders without crashing |

Execute test with:
```bash
flutter test
```
All tests pass cleanly with 100% success.

---

## 📹 Demo Video Recording Checklist

Use this checklist when recording your screen demonstration for submission:

- [ ] **1. Login Validation & Error Handling**
  - Verify that "Sign In" button is initially **disabled** when fields are empty.
  - Enter an invalid email format (e.g. `test`): Observe inline validation error and disabled button.
  - Enter invalid credentials: Tap Sign In, observe loading indicator followed by error snackbar.
  - Toggle password visibility: Verify eye icon toggles and entered text is preserved.
- [ ] **2. Successful Login & Navigation**
  - Tap "Auto Fill" (or type `demo@example.com` / `Demo@123`).
  - Observe that "Sign In" button becomes enabled.
  - Tap "Sign In": Observe loading spinner, welcome snackbar, and automated navigation to the Product Listing screen.
- [ ] **3. Product Listing & Live Cart Badge**
  - Scroll through all 8 clothing products (images with fallback, categories, ratings, descriptions, INR prices `₹`).
  - Tap "Add" on a product: Observe button change to `(1)` and top-right cart badge update to `1`.
  - Tap "Add" on the same product again: Badge updates to `2` and button shows `(2)`.
  - Tap "Add" on two different items: Observe badge update to `4`.
- [ ] **4. Navigation & Shared Cart State**
  - Tap the Cart icon in the AppBar to open the Cart Screen.
  - Verify all selected products, quantities, and line subtotals (`Price × Qty`) are preserved.
- [ ] **5. Cart Quantity Updates & Auto-Removal**
  - Tap `+` on an item: Quantity, subtotal, and total price update instantly.
  - Tap `-` on an item with quantity $> 1$: Quantity decrements.
  - Tap `-` on an item with quantity $1$: Observe the item is **automatically removed** from the cart.
- [ ] **6. Direct Removal & Calculations**
  - Tap the Trash icon on an item: Verify immediate removal and updated grand total.
  - Observe distinct products count and total items quantity clearly separated in the summary bar.
- [ ] **7. Empty Cart State**
  - Remove remaining items or tap "Clear": Verify `EmptyCartView` renders with "Your cart is empty".
  - Tap "Continue Shopping": Returns back to the Product Listing screen.
- [ ] **8. Re-entry & Checkout**
  - Add an item, open Cart, and tap "Proceed to Checkout".
  - Verify Checkout Notice dialog explaining that checkout is not implemented in this demo assessment, then confirm.

---

## ⚠️ Known Limitations

1. **No External Backend**: As required by the assessment guidelines, data is served from local/static data sources (`ProductLocalDataSource` and `AuthLocalDataSource`).
2. **Demo Authentication**: Authentication is performed locally using predefined demo credentials. It is designed for demonstration and assessment purposes.
3. **Session Lifetime**: Cart state is maintained throughout the active application runtime using singleton `CartCubit` scoped above navigation routes. Persistent disk storage (e.g. SQLite or SharedPreferences) is intentionally omitted in compliance with assessment constraints.

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
   git commit -m "feat: complete Clean Architecture Flutter e-commerce application with Cubit"
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
