
# 📱 Real-Time Chat Interface

A single-screen mobile chat application built to support real-time communication via WebSockets (PieSocket) and robust offline functionality. This project demonstrates message syncing, queuing, error handling, and clean UI flow for chat interfaces.

---

## 🚀 Features

- **Single Screen Interface** with chat list and message previews
- **Real-Time Updates** using WebSocket (PieSocket)
- **Offline Message Queueing** and automatic resending
- **Error Handling** for API/network failures
- **Empty State Management**
- **Chatbot Integration**
- **Unread Message Previews**
- *(Optional)* Multi-conversation support

---

## 🔌 WebSocket Configuration

- **Provider**: [PieSocket](https://www.piesocket.com/)
- **Main WebSocket URL**:  
  ```
  wss://s14580.blr1.piesocket.com/v3/1?api_key=ydm0NnRNVKRMYkOaw89HMVIiJEYctiDciIslelMZ&notify_self=0
  ```
- **API Key**:  
  ```
  ydm0NnRNVKRMYkOaw89HMVIiJEYctiDciIslelMZ
  ```

---

## 📦 Deliverables

- ✅ GitHub Repository (code)
- ✅ APK File for Android Testing (if applicable)
- ✅ Demo Recording (online & offline flow)

---

## 📲 How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/realtime-chat-interface.git
   cd realtime-chat-interface
   ```

2. Install dependencies:
   ```bash
   npm install # or yarn install
   ```

3. Start the project:
   ```bash
   npm run start # or use Xcode/Android Studio for native platforms
   ```

---

## 📶 Offline Strategy

- Messages that fail due to no network are **queued locally**.
- On reconnection, the app **auto-retries sending** those messages.
- User feedback via toast/snackbar.

---

## ⚠️ Error & Edge Case Handling

- 🚫 No Internet → Proper alert shown.
- 🚫 No Chats Available → UI shows empty state.
- ❌ WebSocket/API Failure → Handled with fallback logic and alerts.

---

## 📹 Demo

> 📽 A screen recording is included showing both **online** and **offline** functionality.

---

## 🧪 Testing

- Real-time: Try chatting from two clients and verify instant updates.
- Offline: Kill network and send messages, observe retry when online.
- Restart: All chats clear on app close as expected.

---

## 📎 Resources

- [PieSocket Tester](https://piehost.com/websocket-tester)
- [PieSocket Docs](https://www.piesocket.com/docs/3.0)

---

## 🛠 Tech Stack

- React Native / SwiftUI / Kotlin (your stack here)
- WebSockets (PieSocket)
- Async Storage / CoreData for offline queueing
- State Management: Redux / Context API / Swift Combine
