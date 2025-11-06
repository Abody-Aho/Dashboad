<h1 align="center">🧩 Dashboard2 - Flutter Admin & Supermarket Panel</h1>

<p align="center">
  <strong>🌿 A modern, elegant, and powerful admin dashboard built with Flutter</strong><br>
  Manage supermarkets, orders, products, and analytics — all from one smart dashboard.  
  <br><br>
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/GetX-State%20Management-red?logo=dart">
  <img src="https://img.shields.io/badge/Firebase-Integrated-orange?logo=firebase">
  <img src="https://img.shields.io/badge/Platform-Mobile%20%7C%20Web-green">
</p>

---

## 🚀 Features

- 🔐 **Multi-role login system** – Admin & Supermarket panels  
- 📦 **Smart product & stock management**  
- 📊 **Interactive dashboard** with live charts and sales analytics  
- 🧾 **Order tracking system** with status updates  
- 🔔 **Real-time notifications** via Firebase  
- 🌙 **Dark & Light themes**  
- 🖌️ **Beautiful green-based UI design** inspired by minimal admin dashboards  
- 🌍 **Google Maps integration** to track delivery agents and stores  
- 🧠 **GetX** architecture for fast performance and clean code  

---

## 🛠️ Tech Stack

| Technology | Description |
|-------------|-------------|
| 🐦 **Flutter** | Cross-platform UI framework |
| ⚙️ **GetX** | State management, routing, and dependency injection |
| 🔥 **Firebase** | Authentication, notifications, and storage |
| 🌐 **REST API (PHP/MySQL)** | Backend integration for orders, products, and users |
| 🗺️ **Google Maps API** | Real-time delivery tracking |

---

## 📁 Project Structure

```bash
lib/
│
├── core/
│   ├── constants/         # Colors, fonts, app constants
│   ├── services/          # API & Firebase services
│
├── modules/
│   ├── admin/             # Admin dashboard views
│   ├── store/             # Supermarket dashboard views
│   ├── auth/              # Login, signup, password reset
│   └── dashboard/         # Main dashboard analytics
│
├── widgets/               # Shared reusable components
└── main.dart              # App entry point

# Install dependencies
flutter pub get

# Run the app
flutter run
