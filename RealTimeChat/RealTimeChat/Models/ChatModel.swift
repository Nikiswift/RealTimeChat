//
//  ChatModel.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation

struct Chat: Codable, Identifiable {
    let id: UUID
    var title: String
    var messages: [Messages]
    var hasUnreadMessages: Bool {
        return messages.last?.isRead == false
    }
    var lastSeenMessage: String {
        return messages.last?.content ?? "No Messages"
    }
    var lastMessageTimeFormatted: String {
        guard let lastDate = messages.last?.timestamp else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: lastDate)
    }

    var unreadCount: Int {
        messages.filter { !$0.isRead && !$0.isSentByUser }.count
    }

}

struct Messages: Codable, Identifiable {
    let id: UUID
    let content: String
    let isSentByUser: Bool
    let timestamp: Date
    var isDelivered: Bool
    var isRead: Bool
}
