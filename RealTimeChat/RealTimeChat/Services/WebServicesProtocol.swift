//
//  ServicesProtocol.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation
import Combine

protocol WebServiceProtocol: AnyObject {
    var incomingMessage: AnyPublisher<Messages, Never> { get }
    func connect() 
    func send(with message: String)
    func disconnect()
    func recieve()
}
