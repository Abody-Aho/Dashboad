<h1 align="center">🧩 Dashboard2 — Smart Admin Panel for Supermarkets</h1>

<p align="center">
  <strong>🚀 Powerful Flutter dashboard for managing supermarkets, orders, and delivery in real-time</strong>
  <br><br>
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/GetX-Architecture-red?logo=dart">
  <img src="https://img.shields.io/badge/Firebase-Realtime-orange?logo=firebase">
  <img src="https://img.shields.io/badge/Platform-Web%20%7C%20Mobile-green">
</p>

---

## 🧠 Overview

**Dashboard2** is a modern and scalable admin dashboard built using Flutter.
It is designed to manage supermarket systems with **real-time data, multi-role support, and clean architecture**.

🎯 This project simulates a real production system used for:

* Supermarket management
* Order tracking
* Delivery monitoring
* User administration

---

## 👥 User Roles

| Role           | Description                                    |
| -------------- | ---------------------------------------------- |
| 🛠️ Admin      | Full system control (users, orders, analytics) |
| 🏪 Supermarket | Manage products, orders, and store data        |

---

## ✨ Features

### 🔐 Authentication & Security

* Secure login system
* Role-based access control
* Middleware protection (GetX)

### 📦 Product & Inventory

* Add / edit / delete products
* Category management
* Smart stock tracking

### 📊 Dashboard & Analytics

* Real-time charts
* Sales insights
* Order statistics

### 🧾 Orders Management

* Full order lifecycle tracking
* Status updates (pending, accepted, delivered)
* Interactive tables

### 🚚 Delivery Tracking

* Google Maps integration
* Real-time location tracking
* Delivery monitoring system

### 🔔 Notifications

* Firebase Cloud Messaging
* Real-time alerts

### 🎨 UI/UX

* Clean modern design
* Dark / Light mode
* Responsive layout

---

## 📊 Project Insights (Why this project is strong?)

* 🧩 Modular architecture (Feature-based)
* ⚡ High performance using GetX
* 🔄 Real-time ready system
* 🏗️ Scalable structure (easy to expand)
* 🧠 Separation of concerns (Core / Data / Features)

---

## 🏗️ Architecture

```text
Presentation (UI)
     ↓
Controller (GetX)
     ↓
Services / API
     ↓
Data (Models / Repositories)
```

---

## 🛠️ Tech Stack

| Tech                | Usage                      |
| ------------------- | -------------------------- |
| 🐦 Flutter          | UI                         |
| ⚙️ GetX             | State management & routing |
| 🔥 Firebase         | Notifications & auth       |
| 🌐 PHP / MySQL      | Backend                    |
| 🗺️ Google Maps API | Tracking                   |

---

## 📁 Project Structure

```bash id="1yz8s9"
lib/
│
├── core/
│   ├── constants/         # App constants & API links
│   ├── lang/              # Translations
│   ├── services/          # API & services
│   ├── theme/             # Themes
│   └── utils/             # Helpers & validators
│       └── helpers/
│
├── data/
│   ├── models/            # Data models
│   ├── repositories/      # Data handling
│   └── storage/           # Local storage
│
├── features/
│   ├── admin/             # Admin panel
│   ├── supermarket/       # Store panel
│   ├── auth/              # Authentication
│   ├── splash/            # Splash screen
│   └── widgets/           # Shared UI components
│
├── routes/                # Navigation (GetX)
│
└── main.dart
```

---

## 📈 Statistics & Performance

<p align="center">
  <img src="https://github-readme-stats.vercel.app/api?username=Abody-Aho&show_icons=true&theme=radical" height="180">
  <img src="https://github-readme-stats.vercel.app/api/top-langs/?username=Abody-Aho&layout=compact&theme=radical" height="180">
</p>

---

## 🚀 Getting Started

```bash id="l2x8mq"
# Install dependencies
flutter pub get

# Run project
flutter run
```

---

## 📸 Screenshots

🚧 Coming soon...

---

## 🧩 Future Improvements

* 💳 Online payment integration
* 📊 Advanced analytics dashboard
* 🤖 AI-based sales prediction
* ⚡ Performance optimization for large data

---

## 👨‍💻 Developer

**Abdalwaly Samir Ali Maeyad**
Flutter Developer | IT Graduate

📧 Email: [abdalwalysamer6@gmail.com](mailto:abdalwalysamer6@gmail.com)
🔗 LinkedIn: https://www.linkedin.com/in/abdalwaly-samer

---

## 🎯 Vision

To build a **complete smart ecosystem** connecting:

* Users
* Supermarkets
* Delivery drivers

All powered by Flutter 🚀

---

## ⭐ Support

If you like this project, give it a ⭐ on GitHub ❤️
