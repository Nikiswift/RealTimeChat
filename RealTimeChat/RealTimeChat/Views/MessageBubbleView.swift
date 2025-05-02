//
//  MessageBubbleView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI

import SwiftUI

struct MessageBubble: View {
    var text: String
    var isUser: Bool

    var body: some View {
        Text(text)
            .bubbleStyle(isUser: isUser)
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.7,
                alignment: isUser ? .trailing : .leading
            )
    }
}

struct BubbleStyle: ViewModifier {
    let isUser: Bool

    func body(content: Content) -> some View {
        content
            .padding(12)
            .foregroundColor(isUser ? .white : .black)
            .background(isUser ? Color.blue : Color(UIColor.systemGray5))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

extension View {
    func bubbleStyle(isUser: Bool) -> some View {
        self.modifier(BubbleStyle(isUser: isUser))
    }
}
