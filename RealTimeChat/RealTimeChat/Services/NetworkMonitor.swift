//
//  NetworkMonitor.swift
//  RealTimeChat
//
//  Created by Nikhil1 Desai on 02/05/25.
//

import Foundation
import Combine
import Network

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    @Published var isReachable: Bool = false
    private var monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isReachable = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
