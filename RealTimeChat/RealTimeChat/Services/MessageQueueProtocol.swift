//
//  MessageQueueProtocol.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation

protocol MessageQueueProtocol: AnyObject {
    func queue(for message: Messages)
    func retryAll(with sender: @escaping (Messages) -> Void)
}
