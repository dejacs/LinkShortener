//
//  SessionMock.swift
//  NetworkCore
//
//  Created by Jade Silveira on 09/12/21.
//

import Foundation

public final class SessionMock: SessionProtocol {
    public init() { }
    
    public var makeRequestUrlCompletionExpectedResult: (data: Data?, response: URLResponse?, error: Error?)?
    public var makeRequestUrlRequestCompletionExpectedResult: (data: Data?, response: URLResponse?, error: Error?)?
    
    public func makeRequest(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let expectedResult = makeRequestUrlCompletionExpectedResult else {
            return
        }
        completionHandler(expectedResult.data, expectedResult.response, expectedResult.error)
    }
    
    public func makeRequest(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let expectedResult = makeRequestUrlRequestCompletionExpectedResult else {
            return
        }
        completionHandler(expectedResult.data, expectedResult.response, expectedResult.error)
    }
}
