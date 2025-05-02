//
//  ChatListRowView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI
struct ChatRowView: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 12) {
            ChatAvatar(title: chat.title)
            ChatInfo(chat: chat)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Avatar View

struct ChatAvatar: View {
    let title: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 48, height: 48)

            Text(String(title.prefix(1)))
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
}

// MARK: - Chat Info View

struct ChatInfo: View {
    let chat: Chat

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerRow
            messageRow
        }
    }

    private var headerRow: some View {
        HStack {
            Text(chat.title)
                .font(.headline)
                .lineLimit(1)

            Spacer()

            Text(chat.lastMessageTimeFormatted)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var messageRow: some View {
        HStack {
            Text(chat.lastSeenMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)

            Spacer()

            if chat.unreadCount > 0 {
                UnreadBadge(count: chat.unreadCount)
            }
        }
    }
}

// MARK: - Unread Badge

struct UnreadBadge: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.green)
            .clipShape(Capsule())
    }
}
