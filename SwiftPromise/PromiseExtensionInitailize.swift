//
//  PromiseExtensionInitailize.swift
//  Playground
//
//  Created by Dhanu on 16/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//

import Foundation

extension Promise {
    convenience public init(resolve value:ReturnType) {
        self.init { (rs, _) in rs(value) }
    }
    
    convenience public init(reject error:Error) {
        self.init { (_, rj) in rj(error) }
    }
    
    convenience public init(delay:Double, resolve value:ReturnType, queue:Dispatcher = .utility) {
        self.init { (rs, _)  in
            queue.delay(by: delay) { rs(value) }
        }
    }
    
    convenience public init(race set:[Promise<ReturnType>])  {
        self.init { (rs, rj)  in
            var flag = false
            set.enumerated().forEach { (index, promise) in
                promise
                    .then {
                        guard !flag else { return }
                        flag = true
                        rs($0)
                    }.catchs {
                        guard !flag else { return }
                        flag = true
                        rj($0)
                }
            }
        }
    }
    
    convenience public init(race set:Promise<ReturnType>...)  {
        self.init(race:set)
    }
    
    convenience public init(resolve promise:Promise<ReturnType>) {
        self.init { (rs, rj) in
            promise.then (
                resolve: { rs($0) },
                reject: { rj($0) }
            )
        }
    }
    
    convenience public init(delay:Double, resolve promise:Promise<ReturnType>, queue:Dispatcher = .utility)  {
        self.init { (rs, rj) in
            queue.delay(by: delay) {
                promise.then (
                    resolve: { rs($0) },
                    reject: { rj($0) }
                )
            }
        }
    }
}

public class PromiseAll<T> : Promise <[T]> {
    convenience public init(_ set:Promise<T>...) {
        self.init(set)
    }
    convenience public init(_ set:[Promise<T>])  {
        //map results
        self.init { (rs, rj) in
            var results = set.map { _->T? in return nil}
            var flag = false
            set.enumerated().forEach { (index, promise) in
                promise
                    .then {
                        guard !flag else { return }
                        results[index] = $0
                        if !results.contains(where: { return $0==nil }) {
                            flag = true
                            rs(results.compactMap { return $0 } )
                        }
                    }.catchs {
                        guard !flag else { return }
                        flag = true
                        rj($0)
                }
            }
        }
    }
}
