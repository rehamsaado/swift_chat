# 💬 Swift Chat

A full-featured instant messenger and social platform built for extreme speed, ultra-low latency, and real-time interaction. Engineered from scratch using robust software development practices.

---

## 🚀 Key Features

* **Real-time Messaging:** Instantaneous text communication driven entirely by reactive data streams.
* **Group Chats:** Scalable channels for multi-user conversations with real-time syncing.
* **Stories:** Temporary visual or text updates that disappear, powered by dynamic real-time updates.
* **Posts Feed:** A dedicated space for users to share updates, interact, and browse content dynamically.
* **Pixel-Perfect UI:** Fully custom, responsive, and reusable chat and social UI components.

---

## 🏗️ Architecture & Engineering Standards

This project strictly adheres to enterprise-grade standards to ensure maintainability and scalability:

* **Clean Architecture:** Organized into 3 strictly decoupled layers:
  * `Data Layer`: Handles remote data sources (Supabase), model parsing, and repository implementations.
  * `Domain Layer`: Contains pure business logic, entities, and use cases (independent of any framework).
  * `Presentation Layer`: UI Widgets and State Management.
* **SOLID Principles & OOP:** Highly maintainable components with strict adherence to single-responsibility and clean abstractions.
* **State Management:** Powered entirely by **BLoC / Cubit** for predictable state tracking and efficient UI rebuilding.

---

## 🛠️ Tech Stack & Tools

* **Frontend:** Flutter SDK & Dart Language.
* **State Management:** BLoC & Cubit.
* **Backend & Database:** **Supabase** (PostgreSQL, Real-time WebSockets, Streams, and Authentication).
* **DevOps / CI-CD:** Integrated **GitHub Actions** automation pipeline to execute code linting and verify builds on every push/pull request.

---

## 📂 Project Structure Overview

```text
lib/
│
├── features/               # Feature-driven modules (Auth, Chat, Groups, Stories, Posts)
│   └── chat/
│       ├── data/           # Models, Data Sources (Supabase Streams), Repositories
│       ├── domain/         # Use Cases, Entities, Repository Abstractions
│       └── presentation/   # BLoCs, Cubits, Screens, and Custom Widgets
│
├── core/                   # Shared utilities, themes, and constants
│
└── main.dart               # Application entry point
