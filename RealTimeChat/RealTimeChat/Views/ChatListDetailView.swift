//
//  ChatListDetailView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI
struct ChatDetailView: View {
    @EnvironmentObject private var viewModel: ChatListViewModel
    @State private var messageText = ""
    var chat: Chat

    @State private var scrollToBottomTrigger = UUID()

    var body: some View {
        VStack(spacing: 0) {
            messageScrollView
            ChatInputView(messageText: $messageText, onSend: handleSendMessage)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
        }
        .modifier(ChatDetailLifecycleModifier(chat: chat, viewModel: viewModel))
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }

    // MARK: - ScrollView with Messages

    private var messageScrollView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(chat.messages) { message in
                        MessageRow(message: message)
                            .id(message.id)
                    }
                    // Dummy spacer to scroll to
                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
                .id(scrollToBottomTrigger) // force re-render after message sent
                .padding(.top, 12)
                .padding(.bottom, 60) // leave space for input view
            }
            .onChange(of: chat.messages.count) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        scrollProxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }
            .onChange(of: scrollToBottomTrigger) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        scrollProxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        scrollProxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - Send Message Logic

    private func handleSendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        viewModel.sendMessage(with: chat, for: trimmed)
        messageText = ""

        // Trigger scroll after message is appended
        scrollToBottomTrigger = UUID()
    }
}






// MARK: - Message Row View

struct MessageRow: View {
    let message: Messages

    var body: some View {
        HStack {
            if message.isSentByUser {
                Spacer()
                MessageBubble(text: message.content, isUser: true)
                    .transition(.trailingTransition)
            } else {
                MessageBubble(text: message.content, isUser: false)
                    .transition(.leadingTransition)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Lifecycle Modifier

struct ChatDetailLifecycleModifier: ViewModifier {
    let chat: Chat
    let viewModel: ChatListViewModel

    func body(content: Content) -> some View {
        content
            .onAppear {
                viewModel.activeChatID = chat.id
                viewModel.markMessagesAsRead(for: chat.id)
            }
            .onDisappear {
                viewModel.activeChatID = nil
            }
    }
}

// MARK: - Custom Transitions

extension AnyTransition {
    static var leadingTransition: AnyTransition {
        .move(edge: .leading).combined(with: .opacity)
    }

    static var trailingTransition: AnyTransition {
        .move(edge: .trailing).combined(with: .opacity)
    }
}
