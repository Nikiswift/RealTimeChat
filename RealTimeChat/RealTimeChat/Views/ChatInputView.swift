//
//  ChatInputView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI
struct ChatInputView: View {
    @Binding var messageText: String
    var onSend: () -> Void

    private var inputHeight: CGFloat {
        messageText.isEmpty ? 40 : 100
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $messageText)
                    .modifier(ChatTextEditorStyle(height: inputHeight, text: messageText))

                if messageText.isEmpty {
                    Text("your message")
                        .modifier(PlaceholderTextStyle())
                }
            }

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(
                        messageText.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue
                    )
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(Color(UIColor.systemBackground).ignoresSafeArea(edges: .bottom))
    }
}

// MARK: - Custom View Modifiers

struct ChatTextEditorStyle: ViewModifier {
    var height: CGFloat
    var text: String

    func body(content: Content) -> some View {
        content
            .frame(height: height)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .animation(.smooth, value: text)
    }
}

struct PlaceholderTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray.opacity(0.4))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
    }
}
