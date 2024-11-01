//
//  LiveActivityMonitor.swift
//  Typhur
//
//  Created by Liu on 2024/8/1.
//

import Foundation
import ActivityKit

@available(iOS 17.2, *)
struct LiveActivityMonitor {
    static func start() {
        // observePushToStartToken
        observePushToStartToken()
        // observePushTokenUpdates
        observePushTokenUpdates()
    }
    
    // MARK: - Private
    private static func observePushToStartToken() {
        _ = _Concurrency.Task {
            for await pushToken in Activity<DeviceAttributes>.pushToStartTokenUpdates {
                let token = pushToken.toHexString
                // Moya/RxSwift upload token to our server
            }
        }
    }
    private static func observePushTokenUpdates() {        
        _ = Task {
            for await activity in Activity<DeviceAttributes>.activityUpdates {
                _ = Task {
                    for try await tokenData in activity.pushTokenUpdates {
                        let token = tokenData.toHexString
                        // Moya/RxSwift upload token to our server
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct DeviceAttributes: ActivityAttributes {
    struct ContentState: Codable & Hashable {
        let curTemperature: Int
        let curAmbientTemperature: Int
    }
    let device: DeviceData
}
struct DeviceData: Hashable, Codable, Identifiable {
    let deviceId: Int
    
    // MARK: - Identifiable
    var id: String {
        String(deviceId)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Data {
    /// 16 hex Data to String。
    var toHexString: String {
        return reduce("") { $0 + $1.toHexString }
    }
}

public extension Data.Element {
    var toHexString: String {
        String(format: "%02x", self)
    }
}
