//
//  SessionProtocol.swift
//  Moov
//
//  Created by Jade Silveira on 01/12/21.
//

import Foundation

public protocol SessionProtocol {
    func makeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func makeRequest(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
