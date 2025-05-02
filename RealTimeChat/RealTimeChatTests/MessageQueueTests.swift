//
//  RealTimeChatTests.swift
//  RealTimeChatTests
//
//  Created by Nikhil1 Desai on 02/05/25.
//
@testable import RealTimeChat
import XCTest

final class MessageQueueServicesTests: XCTestCase {

    var queueService: MessageQueueServices!

    override func setUp() {
        super.setUp()
        queueService = MessageQueueServices()
    }

    override func tearDown() {
        queueService = nil
        super.tearDown()
    }

    private func createTestMessage(content: String, isSentByUser: Bool = true, isDelivered: Bool = false, isRead: Bool = false) -> Messages {
        return Messages(
            id: UUID(),
            content: content,
            isSentByUser: isSentByUser,
            timestamp: Date(),
            isDelivered: isDelivered,
            isRead: isRead
        )
    }

    func testQueueAddsMessage() {
        let message = createTestMessage(content: "Hello")

        let expectation = XCTestExpectation(description: "Message should be queued")
        queueService.queue(for: message)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let messages = self.queueService.getQueuedMessages()
            XCTAssertEqual(messages.count, 1)
            XCTAssertEqual(messages.first?.content, "Hello")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testHasPendingMessagesTrueAfterQueueing() {
        let message = createTestMessage(content: "Pending Check")

        let expectation = XCTestExpectation(description: "Should report pending messages")
        queueService.queue(for: message)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.queueService.hasPendingMessages)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testRetryAllCallsSenderAndClearsQueue() {
        let message1 = createTestMessage(content: "First")
        let message2 = createTestMessage(content: "Second")

        let expectation = XCTestExpectation(description: "Retry should send and clear messages")
        queueService.queue(for: message1)
        queueService.queue(for: message2)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            var retriedMessages: [Messages] = []

            self.queueService.retryAll { message in
                retriedMessages.append(message)
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(retriedMessages.count, 2)
                XCTAssertFalse(self.queueService.hasPendingMessages)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testGetQueuedMessagesReturnsSnapshot() {
        let message = createTestMessage(content: "Snapshot")

        let expectation = XCTestExpectation(description: "Should return queued message snapshot")
        queueService.queue(for: message)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let snapshot = self.queueService.getQueuedMessages()
            XCTAssertEqual(snapshot.count, 1)
            XCTAssertEqual(snapshot.first?.content, "Snapshot")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

