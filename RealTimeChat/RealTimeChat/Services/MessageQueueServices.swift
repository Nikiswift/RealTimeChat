//
//  MessageServices.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation
final class MessageQueueServices: MessageQueueProtocol {
    // MARK: - Private Properties
    private var queue: [Messages] = []
    private let queueAccessQueue = DispatchQueue(label: "com.chatApp.messageQueue", attributes: .concurrent)

    // MARK: - Public API

    /// Queues a failed message for retry
    func queue(for message: Messages) {
        queueAccessQueue.async(flags: .barrier) {
            self.queue.append(message)
            print("Queued message: \(message.content)")
        }
    }

    /// Retries all queued messages using the provided sender
    func retryAll(with sender: @escaping (Messages) -> Void) {
        queueAccessQueue.async(flags: .barrier) {
            print("Retrying \(self.queue.count) messages")
            self.queue.forEach(sender)
            self.queue.removeAll()
        }
    }

    /// Returns a snapshot of all queued messages
    func getQueuedMessages() -> [Messages] {
        queueAccessQueue.sync {
            return queue
        }
    }

    /// Checks if there are any pending messages
    var hasPendingMessages: Bool {
        queueAccessQueue.sync {
            !queue.isEmpty
        }
    }
}


