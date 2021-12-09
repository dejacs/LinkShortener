//
//  Network.swift
//  Moov
//
//  Created by Jade Silveira on 01/12/21.
//

import Foundation
import UIKit

public protocol Networking {
    func fetchData<T: Decodable>(
        urlText: String,
        resultType: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy,
        completion: @escaping (Result<T, ApiError>) -> Void
    )
    func fetchData<T: Decodable>(
        endpoint: EndpointProtocol,
        resultType: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy,
        completion: @escaping (Result<T, ApiError>) -> Void
    )
}

public final class Network: Networking {
    private let session: SessionProtocol
    private let queue: DispatchQueueProtocol
    
    public init(session: SessionProtocol = URLSession.shared, queue: DispatchQueueProtocol = DispatchQueue.main) {
        self.session = session
        self.queue = queue
    }
    
    public func fetchData<T: Decodable>(
        urlText: String,
        resultType: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        guard let url = URL(string: urlText) else {
            completion(.failure(.urlParse))
            return
        }
        session.makeRequest(with: url) { data, response, error in
            self.queue.callAsync {
                if let hasError = self.verifyError(data: data, response: response, error: error) {
                    completion(.failure(hasError))
                    return
                }
                guard let jsonData = data else {
                    completion(.failure(.nilData))
                    return
                }
                let decodedData: T? = self.decodeData(data: jsonData, decodingStrategy: decodingStrategy)
                guard let unwrappedDecodedData = decodedData else {
                    completion(.failure(.jsonParse))
                    return
                }
                completion(.success(unwrappedDecodedData))
            }
        }
    }
    
    public func fetchData<T: Decodable>(
        endpoint: EndpointProtocol,
        resultType: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        guard let request = createRequest(endpoint: endpoint) else {
            completion(.failure(.urlParse))
            return
        }
        session.makeRequest(with: request) { data, response, error in
            self.queue.callAsync {
                if let hasError = self.verifyError(data: data, response: response, error: error) {
                    completion(.failure(hasError))
                    return
                }
                guard let jsonData = data else {
                    completion(.failure(.nilData))
                    return
                }
                let decodedData: T? = self.decodeData(data: jsonData, decodingStrategy: decodingStrategy)
                guard let unwrappedDecodedData = decodedData else {
                    completion(.failure(.jsonParse))
                    return
                }
                completion(.success(unwrappedDecodedData))
            }
        }
    }
}
    
private extension Network {
    func createRequest(endpoint: EndpointProtocol) -> URLRequest? {
        guard let url = URL(string: endpoint.url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.params)
        request.addValue(endpoint.headers.value, forHTTPHeaderField: endpoint.headers.field)
        return request
    }
    
    func decodeData<T: Decodable>(data: Data?, decodingStrategy: JSONDecoder.KeyDecodingStrategy) -> T? {
        guard let unwrappedData = data else { return nil }
        return try? JSONDecoder(keyDecodingStrategy: decodingStrategy).decode(T.self, from: unwrappedData)
    }
    
    func verifyError(data: Data?, response: URLResponse?, error: Error?) -> ApiError? {
        if let error = error {
            return .server(error: error)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return .nilResponse
        }
        let statusCode = StatusCode.getType(code: httpResponse.statusCode)
        return statusCode != .success ? .statusCode(code: statusCode) : nil
    }
}
