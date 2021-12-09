//
//  DispatchQueueSpy.swift
//  NetworkCore
//
//  Created by Jade Silveira on 09/12/21.
//

import Foundation

public final class DispatchQueueSpy: DispatchQueueProtocol {
    public private(set) var callAsyncCallsCount = 0
    
    public init() { }
    
    public func callAsync(group: DispatchGroup?,
                   qos: DispatchQoS,
                   flags: DispatchWorkItemFlags,
                   execute work: @escaping () -> Void) {
        callAsyncCallsCount += 1
        work()
    }
}
