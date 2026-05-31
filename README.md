<p align="center">
  <img width="100%" alt="shoply (2)" src="https://github.com/user-attachments/assets/447f3c5b-7ec7-43a1-aff3-139171d10704" />
</p>

<h1 align="center"> Shoply — شوبلي </h1>
<h3 align="center">Modern E-Commerce Client Application with Cached Storage</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter"/>
  <img src="https://img.shields.io/badge/Platzi%20API-Backend-green?logo=http"/>
  <img src="https://img.shields.io/badge/BLoC%20%2F%20Cubit-State%20Management-purple"/>
  <img src="https://img.shields.io/badge/Hive-Local%20Database-orange?logo=hive"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey"/>
  <img src="https://img.shields.io/badge/Architecture-MVVM-orange"/>
</p>

---

## About

**Shoply (شوبلي)** is a premium, modern e-commerce mobile application built with Flutter. It connects shopping enthusiasts with a global catalog of trends and outfits, providing a seamless and highly responsive user experience. 

> "Discover Trends, Express Yourself through Fashion."

The app features a polished, feature-based **MVVM** architecture combined with **BLoC/Cubit** for robust state management. Offline caching and persistence are powered by **Hive** and **SharedPreferences**, while network communications integrate the **Platzi Fake Store API** to fetch live category and product catalogs.

---

## Features

### Onboarding & Welcoming Walkthrough
- Beautiful onboarding sequence introducing the latest fashion trends
- Smooth slide transitions using PageView and dynamic text overlays
- Dot indicators using `SmoothPageIndicator` with expand effects
- Micro-animations for text fade-in and slide-up effects (`Animate Do`)

### Secure Authentication & JWT Flow
- Complete register and login system using secure API integrations
- Client-side input validation (Email, Password, Name) using custom validators
- Toast notifications (`Toastification`) for success, error, and warning events
- Token storage system managing Access Tokens and Refresh Tokens inside `SharedPreferences`

### Interactive Home Dashboard
- Welcome banner introducing the shopping dashboard
- Horizontal category tabs displaying categories dynamic listings
- Skeletons loading states (`Skeletonizer`) showing mock categories and products while loading
- Responsive products display grid featuring image placeholders and pricing details
- Open category items to filter products dynamically per category

### Cart & Checkout Management
- Add and remove items from cart with real-time UI updates
- Adjust item quantities with tap buttons (plus/minus) that automatically recalculate the total price
- Checkout redirection and list empty states with premium illustrations
- Full offline cart preservation utilizing **Hive Database**

### Favorites List
- Toggle product favorite status from lists and details screens
- Clear All option displaying a prompt alert confirmation
- Custom placeholder designs for empty favorite list screen
- Permanent favorites storage utilizing **Hive Database**

### Profile Dashboard
- Automated profile details fetching using JWT Authorization headers
- View and update credentials (Name, Password) securely
- Custom avatar profile picture with Camera and Gallery picking options (`ImagePicker`)
- Local avatar storage and offline caching support
- Secure logout mechanism clearing tokens and local database cache

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Backend API | Platzi Fake Store API (REST JSON) |
| State Management | BLoC & Cubit |
| Local Cache Database | Hive (with custom Adapters) |
| Local Preferences | SharedPreferences |
| Network Client | Http package |
| UI Shimmers | Skeletonizer |
| Toast System | Toastification & Custom App Toast |
| Animations | Animate Do |
| Images Utilities | Cached Network Image & Svg Picture |
| Media Picker | Image Picker |
| Architecture | Feature-based MVVM |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point & setup
├── native_splash_screen.dart          # Launch screen configuration
│
├── core/                              # Shared utilities & configurations
│   ├── common/                        # Global shared widgets/screens
│   │   ├── animation/                 # Custom UI animation effects
│   │   ├── screens/                   # Shared screens (e.g. ProductDetailsScreen)
│   │   └── widget/                    # Global reusable UI widgets
│   ├── constants/                     # Globals configuration constants
│   ├── data/                          # Shared data layer
│   │   ├── local_data/                # Hive Local caching database managers
│   │   └── remote_data/               # HTTP client integration services
│   ├── dialogs/                       # Loading dialogues & App toast setups
│   ├── model/                         # Data serialization models (DTOs)
│   │   ├── request/                   # Network requests payload models
│   │   └── response/                  # API server response parsing models
│   ├── storage_helper/                # SharedPreferences helper functions
│   └── utils/                         # Global helpers (JWT, colors, validation)
│
└── feature/                           # Feature modules (MVVM + Cubit)
    ├── app_section/                   # App layout shell with Bottom Navigation Bar
    ├── auth/                          # Onboarding, Login & Register interfaces
    ├── cart/                          # Cart management views & state logic
    ├── favorite/                      # Saved favorite list views & state logic
    ├── home/                          # Categories scroll, product grids, category filtering
    └── profile/                       # Edit credentials, update avatar, logout handler
```

---

## Database & Caching Schema

### Hive Cache Boxes
| Box Name | Model Type | Purpose |
|---|---|---|
| `cart` | `ProductResponse` | Caching items added to the cart along with custom quantities |
| `favorite` | `ProductResponse` | Caching products favorited by the user for offline access |
| `profile` | `String` | Stores the file path to the local custom picked profile avatar |

### SharedPreferences Key Store
| Key | Data Type | Description |
|---|---|---|
| `onboarding_seen` | `bool` | Flag identifying if the user has completed the onboarding screen |
| `accessToken` | `String` | Secure JWT Access Token used for authorized profile calls |
| `refreshToken` | `String` | Secure JWT Refresh Token used for token renewal |

---

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK
- Android Studio or VS Code
- Internet connection (to fetch mock catalogs from Platzi Fake Store API)

### Installation

```bash
# Clone the repository
git clone https://github.com/MARCO-Develper/Shoply.git

# Navigate to the project directory
cd shoply

# Fetch packages and dependencies
flutter pub get

# Generate Hive adapters (if build_runner is needed)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the project
flutter run
```

---

## Developer

| Name | Role | Contact |
|---|---|---|
| **Marco Mina** | Flutter Developer | [GitHub](https://github.com/Marco-Mina-Moris) \| [LinkedIn](https://www.linkedin.com/in/marco-mina-moris/) |

---

<p align="center">Made with ❤️ by Marco Mina — 2025</p>
