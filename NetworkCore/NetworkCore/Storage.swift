//
//  Storage.swift
//  Moov
//
//  Created by Jade Silveira on 01/12/21.
//

import Foundation

public protocol Storaging {
    func create<T: Encodable>(object: T, key: String) throws
    func read<T: Decodable>(objectType: T.Type, key: String) throws -> T
    func update<T: Encodable>(object: T, key: String) throws
    func delete(key: String)
}

public final class Storage: Storaging {
    private let defaults: UserDefaultsProtocol
    
    public init(defaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    public func create<T: Encodable>(object: T, key: String) throws {
        let data = try JSONEncoder().encode(object)
        defaults.set(data, forKey: key)
    }
    
    public func read<T: Decodable>(objectType: T.Type, key: String) throws -> T {
        guard let data = defaults.object(forKey: key) as? Data else { throw ApiError.nilData }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func update<T: Encodable>(object: T, key: String) throws {
        try create(object: object, key: key)
    }
    
    public func delete(key: String) {
        defaults.removeObject(forKey: key)
    }
}
