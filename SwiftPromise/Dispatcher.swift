//
//  Dispatcher.swift
//  Playground
//
//  Created by Dhanu on 15/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//

import Foundation

public enum Dispatcher {
    case main, userInteractive, userInitiated, utility, background
    var queue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

public extension Dispatcher{
    public func delay(by seconds: Double, closure: @escaping () -> Void) {
        queue.asyncAfter(deadline: DispatchTime.now() + seconds, execute: closure)
    }
}
