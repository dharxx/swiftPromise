//
//  Thenable.swift
//  Playground
//
//  Created by Dhanu on 11/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//
import Foundation

public protocol Thenable {
    associatedtype ReturnType
    @discardableResult func then<T> (
        resolve:@escaping (ReturnType)throws->T,
        reject:@escaping (Error)throws->T
        ) -> Promise<T>
    
    @discardableResult func then<T> (
        resolve:@escaping (ReturnType)throws->T,
        reject:@escaping (Error)throws->T
        ) -> Promise<T.ReturnType> where T : Thenable
}
extension Thenable {
    @discardableResult public func then<T>(resolve:@escaping (ReturnType)throws->T) -> Promise<T> {
        return then(resolve: resolve, reject: { throw $0 })
    }
    @discardableResult public func catchs(reject:@escaping (Error)throws->ReturnType) -> Promise<ReturnType> {
        return then(resolve: { return $0 },reject: reject)
    }
    @discardableResult public func then<T>(resolve:@escaping (ReturnType)throws->T) -> Promise<T.ReturnType> where T : Thenable {
        return then(resolve: resolve, reject: { throw $0 })
    }
}
