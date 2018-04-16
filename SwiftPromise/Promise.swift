//
//  Promise.swift
//  Playground
//
//  Created by Dhanu on 15/4/2561 BE.
//  Copyright © 2561 20scoops. All rights reserved.
//

import Foundation

public class Promise<ReturnType> {
    enum State {
        case pending([()->Void])
        case fulfilled(ReturnType)
        case rejected(Error)
    }
    var state:State = .pending([]) {
        didSet {
            switch (oldValue, state) {
            case let (.pending(pipeline), .fulfilled(_)),
                 let (.pending(pipeline), .rejected(_)):
                pipeline.forEach { $0() }
                break
            default: break
            }
        }
    }
    
    @discardableResult required public init(_ block:@escaping (@escaping (ReturnType)->Void,@escaping (Error)->Void)->Void) {
        block (
            { result in self.state = .fulfilled(result) },
            { error in self.state = .rejected(error) }
        )
    }
    func afterResolve(do block:@escaping ()->Void) {
        switch state {
        case .pending(let pipeline):
            state = .pending(pipeline+[block])
        default: block()
        }
    }
}

