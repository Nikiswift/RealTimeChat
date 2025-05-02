//
//  ChatListView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.

import SwiftUI
struct ChatListView: View {
    @EnvironmentObject private var viewModel: ChatListViewModel
    @State private var showNewChatSheet = false
    @State private var newChatTitle = ""

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                contentView
                newChatButton
            }
            .navigationTitle("Chats")
        }
        .sheet(isPresented: $showNewChatSheet) {
            NewChatPopup(
                chatTitle: $newChatTitle,
                onCreate: {
                    viewModel.createNewChat(title: newChatTitle)
                    showNewChatSheet = false
                },
                onCancel: {
                    showNewChatSheet = false
                }
            )
        }
    }

    @ViewBuilder
    private var contentView: some View {
        VStack {
            if viewModel.chats.isEmpty {
                EmptyChatStateView()
            } else {
                ChatListSection(chats: viewModel.chats)
            }
        }
    }

    private var newChatButton: some View {
        Button(action: {
            newChatTitle = ""
            showNewChatSheet = true
        }) {
            Image(systemName: "plus")
                .modifier(FloatingActionButtonStyle())
        }
        .padding(.trailing, 20)
        .padding(.bottom, 30)
    }
}

// MARK: - Empty State View

struct EmptyChatStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.3))
            Text("No Chats Available")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Chat List Section

struct ChatListSection: View {
    let chats: [Chat]

    var body: some View {
        List {
            ForEach(chats) { chat in
                NavigationLink(destination: ChatDetailView(chat: chat)) {
                    ChatRowView(chat: chat)
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Floating Action Button Modifier

struct FloatingActionButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 56, height: 56)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
}
