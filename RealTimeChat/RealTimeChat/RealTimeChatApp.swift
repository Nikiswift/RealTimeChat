//
//  RealTimeChatApp.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import SwiftUI

@main
struct RealTimeChatApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = ChatListViewModel(webSocketService: WebServices(), queueService: MessageQueueServices())
    var body: some Scene {
        WindowGroup {
            ChatListView().environmentObject(viewModel)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.clearAllChats()
            }
        }
    }
}
