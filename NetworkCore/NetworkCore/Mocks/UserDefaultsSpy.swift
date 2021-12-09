//
//  UserDefaultsSpy.swift
//  NetworkCore
//
//  Created by Jade Silveira on 09/12/21.
//

import Foundation

public final class UserDefaultsSpy: UserDefaultsProtocol {
    private(set) var setCallsCount = 0
    private(set) var objectCallsCount = 0
    private(set) var removeObjectCallsCount = 0
    
    public init() { }
    
    public func set(_ value: Any?, forKey defaultName: String) {
        setCallsCount += 1
    }
    
    public func object(forKey defaultName: String) -> Any? {
        objectCallsCount += 1
    }
    
    public func removeObject(forKey defaultName: String) {
        removeObjectCallsCount += 1
    }
}
