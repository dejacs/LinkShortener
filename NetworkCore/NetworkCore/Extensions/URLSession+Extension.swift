//
//  URLSession+Extension.swift
//  Moov
//
//  Created by Jade Silveira on 01/12/21.
//

import Foundation

extension URLSession: SessionProtocol {
    public func makeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task: URLSessionDataTask = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
    public func makeRequest(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task: URLSessionDataTask = dataTask(with: urlRequest, completionHandler: completionHandler)
        task.resume()
    }
}
