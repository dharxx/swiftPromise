//
//  PromiseExtensionShortcut.swift
//  Playground
//
//  Created by Dhanu on 16/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//

import Foundation

extension Promise {
    static public func resolve(_ value:ReturnType)->Promise<ReturnType> {
        return Promise(resolve: value)
    }
    static public func reject(_ error:Error)->Promise<ReturnType> {
        return Promise(reject: error)
    }
    static public func race(_ set:[Promise<ReturnType>])->Promise<ReturnType> {
        return Promise(race: set)
    }
    static public func race(_ set:Promise<ReturnType>...)->Promise<ReturnType> {
        return .race(set)
    }
    static public func delay(_ by:Double, _ value:ReturnType)->Promise<ReturnType> {
        return Promise(delay: by, resolve: value)
    }
}

extension Promise where ReturnType : Collection {
    static public func all(_ set:[Promise<ReturnType.Element>])->Promise<[ReturnType.Element]> {
        return PromiseAll(set)
    }
    static public func all(_ set:Promise<ReturnType.Element>...)->Promise<[ReturnType.Element]> {
        return .all(set)
    }
}
