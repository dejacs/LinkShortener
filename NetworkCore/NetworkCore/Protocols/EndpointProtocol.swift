//
//  EndpointProtocol.swift
//  Moov
//
//  Created by Jade Silveira on 01/12/21.
//

import Foundation

public protocol EndpointProtocol {
    var host: String { get }
    var path: String { get }
    var headers: (value: String, field: String) { get }
    var params: [String: Any] { get }
    var method: EndpointMethod { get }
}

public extension EndpointProtocol {
    var url: String {
        host.appending(path)
    }
}

public enum EndpointMethod: String {
    case post
    case get
    case put
    case delete
    case head
    case connect
    case options
    case trace
}
