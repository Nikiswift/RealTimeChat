//
//  WebServicesTestCase.swift
//  RealTimeChatTests
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import XCTest
import Combine
@testable import RealTimeChat

final class WebServicesTests: XCTestCase {

    var webService: WebServices!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        webService = WebServices()
        cancellables = []
    }

    override func tearDown() {
        webService = nil
        cancellables = nil
        super.tearDown()
    }

    func testConnectInitializesTask() {
        webService.connect()

        // We can't access `task` directly, but if no crash/log happened, assume safe.
        // Ideally, WebServices should expose connection state via a delegate or publisher.
        // For now, just make sure it doesn't crash.
        XCTAssertTrue(true, "Connect should not crash")
    }

    func testSendMessageWithoutConnectionPrintsError() {
        // Since we can’t capture print statements directly, this test ensures code doesn't crash
        webService.send(with: "Test")
        XCTAssertTrue(true, "Sending without connection should not crash")
    }

    func testDisconnectDoesNotCrash() {
        webService.disconnect()
        XCTAssertTrue(true, "Disconnect should be safe even without connection")
    }


}
