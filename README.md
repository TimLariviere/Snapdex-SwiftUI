# Snapdex — SwiftUI Edition

**Snapdex** is a modern iOS app built with **SwiftUI** and **Swift 6**, inspired by the idea of a personal Pokédex. Users can snap photos of Pokémon-themed merchandise (like plushes, trading cards, or figurines) and use AI to identify and catalog them in their collection.

While playful in concept, **Snapdex is a serious, production-quality showcase** of mobile architecture, design systems, offline-first strategies, and integration with real-world features like camera, authentication, and analytics.

> ✨ Looking for the Android version? Check out [Snapdex – Compose Edition](https://github.com/TimLariviere/Snapdex-Compose)

## 🎯 Why I Built Snapdex

Snapdex started as a personal project to explore **SwiftUI** and demonstrate how I approach mobile development as a Senior/Staff-level engineer.

It also served as a way to translate my experience from .NET MAUI and Xamarin — where I’ve built production apps using patterns like MVVM and MVU (via Fabulous, which I co-created) — into the Compose ecosystem. The architectural foundations remain the same: clean separation of concerns, unidirectional data flow, and a strong focus on long-term maintainability.

Rather than focus on flashy features, my goal was to create a **well-architected, well-rounded, and production-ready app** — the kind of project that goes beyond what demos well and instead shows the **core engineering work that matters**.

That includes things like:

- A clean, modular architecture
- Offline-first data access
- Navigation and UI structure that scales
- Proper authentication flows (login, register, forgot password)
- Custom UI components
- Dark mode support
- Secure API key handling
- Analytics and crash monitoring
- Maintainable design system
- Business validation and error handling

These aren’t the “shiny” parts of app development — but they’re essential to real-world mobile apps, and I wanted Snapdex to reflect that.

## ✨ Features

- 📸 Snap photos of Pokémon-themed merchandise in the real world
- 🧠 AI-powered recognition using **TensorFlow Lite** (on-device) and **OpenAI API** (cloud)
- 📶 Offline-first with automatic sync to **Firebase Firestore**
- 🧭 Intuitive navigation with persistent tab structure
- 🔐 Full authentication flow: register, login, password reset
- 🌙 System-aware dark mode support
- 🎨 Material 3 design, custom themed to match designer-provided Figma

<p align="center">
  <img src="images/screen1.png" height="480" />
  <img src="images/screen2.png" height="480" />
  <img src="images/screen3.png" height="480" />
  <img src="images/screen4.png" height="480" />
  <img src="images/screen5.png" height="480" />
  <img src="images/screen6.png" height="480" />
  <img src="images/screen7.png" height="480" />
  <img src="images/screen8.png" height="480" />
</p>

> 🎨 **Design by** [Rui Zhang](https://www.linkedin.com/in/ruizhang77)  
> 🧪 Pokémon detail page inspired by [Junior Savaria’s Figma](https://www.figma.com/community/file/1202971127473077147)

## 🧠 Architecture Overview

Snapdex is structured using a modular, scalable architecture inspired by Clean Architecture principles:

- **MVVM Pattern**
- **Separation of Concerns** – Independent `UI`, `Domain`, `Data`, and `App` packages
- **Composable UI** – Pure, testable composables with state managed externally
- **Offline-first** – SwiftData as source of truth, Firestore for cloud sync
- **Custom Design System** – Fully themed using `@Environment`

👉 [Read the full Architecture Guide →](ARCHITECTURE.md)

## 🛠️ Tech Stack

### Core Technologies
- **Swift 6**
- **SwiftUI**
- **Xcode**
- **Combine**
- **@Environment** / **@Observable**

### Data & Networking
- **SwiftData** – Local persistence
- **Firestore** – Cloud synchronization
- **Alamofire** – Networking
- **@AppStorage** – Preferences storage

### AI & Image Processing
- **TensorFlow Lite** – On-device AI
- **OpenAI API** – Cloud-based recognition
- **Kingfisher** – Image loading

### Auth & Security
- **Firebase Authentication**
- **Encrypted local storage** for secure key handling

### Tooling & Distribution
- **Firebase Analytics**
- **Firebase Crashlytics**
- **Firebase App Distribution**

## 📦 Build & Setup

> 🔧 Requirements: Xcode 16.2

TBA

## 🌍 Internationalization

Snapdex is localization-ready. All user-facing strings are externalized in Android resource files, making it easy to support new languages.

## 📄 License

This project is licensed under the Apache 2.0 License – see the [LICENSE](LICENSE.md) file for details.
