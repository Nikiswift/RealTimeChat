//
//  WebServices.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation
import Combine

enum WebSocketError: String, Error {
    case invalidURL = "Invalid URL"
    case connectionError = "Connection error"
    case receiverError = "Receiver error"
    case sendingError = "Sending error"
    case unexpectedMessageFormat = "Unexpected message format"
    case pingError = "Ping failed"
}

final class WebServices: WebServiceProtocol {
    
    // MARK: - Constants and Properties
    private let apiKey = "ydm0NnRNVKRMYkOaw89HMVIiJEYctiDciIslelMZ"
    private var socketURL: URL? {
        URL(string: "wss://s14580.blr1.piesocket.com/v3/1?api_key=\(apiKey)&notify_self=0")
    }
    
    private var task: URLSessionWebSocketTask?
    private var subject = PassthroughSubject<Messages, Never>()
    
    var incomingMessage: AnyPublisher<Messages, Never> {
        subject.eraseToAnyPublisher()
    }
    
    // MARK: - WebSocket Methods
    
    /// Establishes WebSocket connection
    func connect() {
        guard let webUrl = socketURL else {
            print(WebSocketError.invalidURL.rawValue)
            return
        }
        
        print(" Connecting to WebSocket: \(webUrl)")
        
        task = URLSession(configuration: .default).webSocketTask(with: webUrl)
        task?.resume()
        sendPing()
        recieve()
    }
    
    /// Sends a message via WebSocket
    func send(with message: String) {
        guard let task = task else {
            print(WebSocketError.sendingError.rawValue)
            return
        }

        print("Attempting to send message: \(message)")
        
        task.send(.string(message)) { error in
            if let error = error {
                print("Send failed: \(error.localizedDescription)")
            } else {
                print("Message sent: \(message)")
            }
        }
    }
    
    /// Disconnects from the WebSocket
    func disconnect() {
        print("Disconnecting from WebSocket")
        task?.cancel(with: .goingAway, reason: nil)
    }
    
    // MARK: - Private Helper Methods
    
    /// Sends a ping to keep the connection alive
    private func sendPing() {
        task?.sendPing { error in
            if let error = error {
                print("\(WebSocketError.pingError.rawValue): \(error.localizedDescription)")
            } else {
                print("Ping successful")
            }
        }
    }

    /// Receives incoming messages from the WebSocket
     func recieve() {
        task?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.handleReceivedMessage(message)
                self?.recieve() // Continue listening
            case .failure(let error):
                print("Receive failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// Handles received WebSocket message
    private func handleReceivedMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            print("Received message: \(text)")
            let message = Messages(
                id: UUID(),
                content: "🤖\(text)",
                isSentByUser: false,
                timestamp: Date(),
                isDelivered: true,
                isRead: false
            )
            subject.send(message)
        default:
            print(WebSocketError.unexpectedMessageFormat.rawValue)
        }
    }
}


