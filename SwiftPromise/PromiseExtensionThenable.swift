//
//  PromiseExtension.swift
//  Playground
//
//  Created by Dhanu on 16/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//

import Foundation

extension Promise : Thenable {
    func instantResolve<T>(
        resolve:@escaping (ReturnType)throws->T,
        reject:@escaping (Error)throws->T
        )throws->T? {
        switch state {
        case .fulfilled(let result): return try resolve(result)
        case .rejected(let error): return try reject(error)
        default: break
        }
        return nil
    }
    
    @discardableResult public func then<T> (
        resolve:@escaping (ReturnType)throws->T,
        reject:@escaping (Error)throws->T
        ) -> Promise<T> {
        return Promise<T> { (rs,rj) in
            self.afterResolve(do:  {
                do {
                    if let resolved = try self.instantResolve(resolve: resolve, reject: reject) {
                        rs(resolved)
                    }
                }
                catch { rj(error) }
            })
        }
    }
    @discardableResult public func then<T> (
        resolve:@escaping (ReturnType)throws->T,
        reject:@escaping (Error)throws->T
        ) -> Promise<T.ReturnType> where T : Thenable {
        return Promise<T.ReturnType> { (rs,rj) in
            self.afterResolve(do:  {
                do {
                    if let resolved = try self.instantResolve(resolve: resolve, reject: reject) {
                        resolved.then(
                            resolve: { rs($0) },
                            reject: { rj($0) }
                        )
                    }
                }
                catch { rj(error) }
            })
        }
    }
}
