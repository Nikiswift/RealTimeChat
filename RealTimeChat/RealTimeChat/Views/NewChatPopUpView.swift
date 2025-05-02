//
//  NewChatPopUpView.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI

struct NewChatPopup: View {
    @Binding var chatTitle: String
    var onCreate: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Chat Title")
                    .font(.headline)

                TextField("Chat name", text: $chatTitle)
                    .chatTextFieldStyle()

                Spacer()

                HStack {
                    Button("Cancel", action: onCancel)
                        .buttonPadding()
                    Spacer()
                    Button("Create", action: onCreate)
                        .disabled(chatTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                        .buttonPadding()
                }
                .horizontalPadding()
            }
            .padding()
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Modifier for text field styling
struct ChatTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
}

// Modifier for consistent button padding
struct ButtonPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding()
    }
}

// Modifier for horizontal padding on containers
struct HorizontalPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.horizontal)
    }
}

// Extensions for cleaner syntax
extension View {
    func chatTextFieldStyle() -> some View {
        self.modifier(ChatTextFieldStyle())
    }

    func buttonPadding() -> some View {
        self.modifier(ButtonPadding())
    }

    func horizontalPadding() -> some View {
        self.modifier(HorizontalPadding())
    }
}



