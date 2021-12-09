//
//  UserDefaultsProtocol.swift
//  NetworkCore
//
//  Created by Jade Silveira on 08/12/21.
//

import Foundation

public protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
    func removeObject(forKey defaultName: String)
}
