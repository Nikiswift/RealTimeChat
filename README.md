
# 📱 Real-Time Chat Interface (iOS - SwiftUI)

An iOS single-screen mobile chat application built with SwiftUI and Combine, supporting real-time communication via WebSockets (PieSocket) and robust offline functionality. This project demonstrates message syncing, queuing, error handling, and clean UI flow for chat interfaces.

---

## 🚀 Features

- **Single Screen Interface** using SwiftUI
- **Real-Time WebSocket Updates** with PieSocket
- **Offline Message Queueing** using local state/cache
- **Error Handling** for API/network failures
- **Empty State Management**
- **Chatbot Conversation View**
- **Unread Message Previews**
- *(Optional)* Individual chat switching

---

## 🔌 WebSocket Configuration

- **Provider**: [PieSocket](https://www.piesocket.com/)
- **WebSocket URL**:
  ```
  wss://s14580.blr1.piesocket.com/v3/1?api_key=ydm0NnRNVKRMYkOaw89HMVIiJEYctiDciIslelMZ&notify_self=0
  ```
- **API Key**:
  ```
  ydm0NnRNVKRMYkOaw89HMVIiJEYctiDciIslelMZ
  ```

---

## 📦 Deliverables

- ✅ GitHub Repository with Swift code
- ✅ TestFlight/IPA or Xcode build for testing
- ✅ Demo recording of online & offline behavior

---

## 🧑‍💻 How to Run (iOS)

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/realtime-chat-ios.git
   cd realtime-chat-ios
   ```

2. Open `RealTimeChat.xcodeproj` or `RealTimeChat.xcworkspace` in **Xcode 14+**

3. Select your simulator or device and hit **Run ▶️**

---

## 🧵 Offline Strategy

- Failed messages are **stored locally** (e.g., `@State`, `@AppStorage`, or `FileManager`)
- Once network is restored, the app **auto-retries** those messages.
- Network reachability can be tracked via NWPathMonitor or Reachability.swift.

---

## ⚠️ Error & Edge Case Handling

- 📴 No Internet → SwiftUI alert/snackbar
- 📭 No Chats Available → Empty state UI
- 🔌 WebSocket Failure → Retry or show error

---

## 📹 Demo

> 🎥 A screen recording is provided showing online and offline messaging.

---

## 🧪 Testing

- Real-time test: Two devices/simulators see synced messages
- Offline test: Kill Wi-Fi, send messages → observe resend after reconnection
- Restart test: Conversations clear on relaunch as expected

---

## 📚 Resources

- [PieSocket Tester](https://piehost.com/websocket-tester)
- [Combine Documentation](https://developer.apple.com/documentation/combine)
- [SwiftUI Documentation](https://developer.apple.com/xcode/swiftui/)

---

## 🛠 Tech Stack

- **Swift 5.9+**
- **SwiftUI**
- **Combine**
- **URLSession** & **WebSocketTask**
- **NWPathMonitor** (for offline detection)
- **MVVM Architecture**

---

Happy Coding! 🎉
