
# 📋 Flutter To-Do Application

A simple **cross-platform task management mobile application** built using **Flutter**.
The app allows users to create, manage, and organize daily tasks with an intuitive interface.

The project follows the **MVVM architecture** with **Realm database** for offline data storage and **Provider** for state management. It also includes **CI/CD automation using GitHub Actions**.

---

## 👨‍💻 Author

**B. Surya Charan**
Version: **1.0**
Date: **04-03-2026**

---

# 🚀 Features

* Create, update, and delete tasks
* Tag tasks for better organization
* Set task deadlines
* Offline-first data storage
* Reactive UI updates
* Clean and scalable architecture
* Automated CI/CD pipeline

---

# 🛠 Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **Database:** Realm (Local NoSQL Database)
* **Architecture:** MVVM
* **State Management:** Provider
* **Design Pattern:** Repository Pattern
* **CI/CD:** GitHub Actions

---

# 🏗 Architecture

The application follows the **MVVM (Model-View-ViewModel)** pattern.

### Model

Defines application data structures using **Realm schemas** such as `Task` and `Tag`.

### View

Flutter UI components that display data and react to state changes.

### ViewModel

Handles business logic and manages state using `ChangeNotifier`.

### Repository

Acts as a data abstraction layer between ViewModel and Realm database.

---

# 💾 Data Models

### Task

| Field       | Type     | Description        |
| ----------- | -------- | ------------------ |
| id          | ObjectId | Unique identifier  |
| title       | String   | Task title         |
| description | String   | Task details       |
| tags        | List     | Associated tags    |
| deadline    | DateTime | Task deadline      |
| createdAt   | DateTime | Creation timestamp |

### Tag

| Field   | Type     | Description       |
| ------- | -------- | ----------------- |
| tagId   | ObjectId | Unique identifier |
| tagName | String   | Tag name          |

---

# 📁 Project Structure

```
lib/
 ├── database/
 ├── models/
 ├── repository/
 ├── viewmodels/
 ├── views/
 └── main.dart
```

| Folder     | Description                         |
| ---------- | ----------------------------------- |
| database   | Realm database services             |
| models     | Data models and schemas             |
| repository | Data abstraction layer              |
| viewmodels | Business logic and state management |
| views      | UI screens and widgets              |

---

# 📦 Packages Used

* `realm` – Local database
* `provider` – State management
* `intl` – Date formatting
* `flutter_lints` – Code linting

---

# ⚙️ CI/CD

GitHub Actions is used for automated workflows:

* Install dependencies
* Run `flutter analyze`
* Execute tests
* Build APK on push to `main`

---

# ▶️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/flutter-todo-app.git
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

---

# 📄 License

This project is licensed under the **MIT License**.

---
## 📱 App Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/7ce8ad6d-d1ea-49df-a300-57f21e374e52" width="260"/>
  <img src="https://github.com/user-attachments/assets/3f780214-b426-4d12-a6a3-b910a452ef66" width="260"/>
  <img src="https://github.com/user-attachments/assets/d34a0266-3f92-45cb-bf43-0f2a8635cf93" width="260"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/00141378-2d85-4002-8353-dc923ce46de4" width="260"/>
  <img src="https://github.com/user-attachments/assets/184bcb59-d918-4ba2-813c-40249d810bed" width="260"/>
</p>




