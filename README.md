# 💬 Swift Chat

A feature-rich, production-ready instant messaging application engineered for high speed, ultra-low latency, and real-time communication. Built completely from scratch using robust software engineering practices.

---

## 🚀 Key Features

* **Real-time Messaging:** Instantaneous, low-latency text communication using reactive streaming.
* **Group Chats:** Scalable channels for multi-user conversations, optimized for synchronized data delivery.
* **Real-time Stories:** Temporary visual and text status updates driven by real-time backend reactive streams.
* **Responsive & Pixel-Perfect UI:** Fully custom, reusable chat widgets and layouts optimized for smooth rendering.

---

## 🏗️ Architecture & Engineering Standards

This project strictly adheres to enterprise-grade standards to ensure maintainability, scalability, and ease of testing:

* **Clean Architecture:** Organized into 3 strictly decoupled layers:
  * `Data Layer`: Handles remote data sources (Supabase), model parsing, and repository implementations.
  * `Domain Layer`: Contains pure business logic, entities, and use cases (independent of any framework).
  * `Presentation Layer`: UI Widgets and State Management.
* **SOLID Principles & OOP:** Written with highly maintainable, single-responsibility components and clean abstractions.
* **State Management:** Powered entirely by **BLoC / Cubit** for predictable state tracking, robust event-to-state mapping, and efficient UI rebuilding.

---

## 🛠️ Tech Stack & Tools

* **Frontend:** Flutter SDK & Dart Language.
* **State Management:** BLoC & Cubit.
* **Backend & Database:** **Supabase** (PostgreSQL, Real-time WebSockets, Streams, and Authentication Management).
* **Networking:** **Dio** for advanced HTTP networking, interceptors, and seamless payload tracking.
* **DevOps / CI-CD:** Integrated **GitHub Actions** automation pipeline to execute code linting and verify builds on every push/pull request.

---

## 📂 Project Structure Overview

```text
lib/
│
├── features/               # Feature-driven modules (Auth, Chat, Groups, Stories)
│   └── chat/
│       ├── data/           # Models, Data Sources, Repositories Implementation
│       ├── domain/         # Use Cases, Entities, Repository Abstractions
│       └── presentation/   # BLoCs, Cubits, Screens, and Custom Widgets
│
├── core/                   # Shared utilities, themes, networks, and constants
│
└── main.dart               # Application entry point
