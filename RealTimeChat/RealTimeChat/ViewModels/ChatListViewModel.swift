//
//  ChatListViewModel.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation
import Combine

final class ChatListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var chats: [Chat] = []
    @Published var errorMessages: WebSocketError?
    @Published var activeChatID: UUID?
    
    // MARK: - Private Properties
    private let webSocketService: WebServiceProtocol
    private let queueService: MessageQueueProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(webSocketService: WebServiceProtocol, queueService: MessageQueueProtocol) {
        self.webSocketService = webSocketService
        self.queueService = queueService
        self.connect()
    }
    
    // MARK: - Public Methods
    
    /// Creates a new chat with the specified title.
    func createNewChat(title: String) {
        let newChat = Chat(id: UUID(), title: title, messages: [])
        chats.insert(newChat, at: 0)
    }
    
    /// Connects the WebSocket service and starts observing messages and the queue.
    func connect() {
        webSocketService.connect()
        observeMessages()
        observeQueue()
    }
    
    /// Observes changes in network reachability and retries queued messages if network is available.
    private func observeQueue() {
        NetworkMonitor.shared.$isReachable
            .removeDuplicates()
            .sink { [weak self] isConnected in
                guard isConnected else { return }
                
                self?.retryQueuedMessages()
            }
            .store(in: &cancellables)
    }
    
    /// Sends all queued messages.
    private func retryQueuedMessages() {
        queueService.retryAll { [weak self] message in
            self?.webSocketService.send(with: message.content)
        }
    }
    
    /// Observes incoming WebSocket messages.
    private func observeMessages() {
        webSocketService.incomingMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleIncomingMessage(message)
            }
            .store(in: &cancellables)
    }
    
    /// Handles an incoming message.
    private func handleIncomingMessage(_ message: Messages) {
        
        let targetChatID = self.activeChatID ?? self.chats.first?.id
        
        if let chatID = targetChatID {
            self.appendMessage(message, toChatID: chatID)
        } else {
            self.createNewChatAndAppendMessage(message)
        }
    }

    
    func markMessagesAsRead(for chatID: UUID) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            for messageIndex in 0..<chats[index].messages.count {
                chats[index].messages[messageIndex].isRead = true
            }
        }
    }


    
    /// Appends a message to the specified chat.
    private func appendMessage(_ message: Messages, toChatID chatID: UUID) {
        DispatchQueue.main.async {
            if let index = self.chats.firstIndex(where: { $0.id == chatID }) {
                var updatedMessage = message
                updatedMessage.isRead = (self.activeChatID == chatID)
                self.chats[index].messages.append(updatedMessage)
            }
        }
    }
    
    /// Creates a new chat and appends the incoming message.
    private func createNewChatAndAppendMessage(_ message: Messages) {
        let newChat = Chat(id: UUID(), title: "🤖 Bot", messages: [
            Messages(
                id: message.id,
                content: message.content,
                isSentByUser: false,
                timestamp: message.timestamp,
                isDelivered: true,
                isRead: false
            )
        ])
        self.chats.insert(newChat, at: 0)
    }
    
    /// Clears all chats from the list.
    func clearAllChats() {
        chats.removeAll()
    }
    
    /// Sends a message for a specific chat.
    func sendMessage(with chatMessage: Chat, for message: String) {
        guard let chatIndex = chats.firstIndex(where: { $0.id == chatMessage.id }) else { return }
        
        let finalMessage = Messages(id: UUID(), content: message, isSentByUser: true, timestamp: Date(), isDelivered: true, isRead: true)
        self.chats[chatIndex].messages.append(finalMessage)
        
        if NetworkMonitor.shared.isReachable {
            webSocketService.send(with: message)
        } else {
            queueService.queue(for: finalMessage)
        }
    }
}

