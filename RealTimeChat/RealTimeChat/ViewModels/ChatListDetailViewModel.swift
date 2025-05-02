//
//  ChatListDetailViewModel.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation

final class ChatListDetailViewModel: ObservableObject {
    @Published var chats: Chat
    private let webServices: WebServiceProtocol
    private let queueService: MessageQueueProtocol
    
    init(chats: Chat, webServices: WebServiceProtocol, queueService: MessageQueueServices) {
        self.chats = chats
        self.webServices = WebServices()
        self.queueService = MessageQueueServices()
    }
    
    func sendMessage(with chatMessage: String) {
        let message = Messages(id: UUID(), content: "🧑🏻‍💻\(chatMessage)", isSentByUser: true, timestamp: Date(), isDelivered: true, isRead: true)
        chats.messages.append(message)
        self.webServices.send(with: chatMessage)
    }
}
