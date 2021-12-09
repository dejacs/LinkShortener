//
//  URLShortenerServiceMock.swift
//  LinkShortener
//
//  Created by Jade Silveira on 09/12/21.
//

import Foundation
import UIKit
import NetworkCore

final class URLShortenerServiceMock: URLShortenerServicing {
    func postAlias(text: String, completion: @escaping (Result<URLShortenerResponse, ApiError>) -> Void) {
        getStub(fileName: "json_url_recent_list", resultType: [URLShortenerResponse].self) { result in
            switch result {
            case .success(let urlList):
                guard let firstUrl = urlList.first else {
                    completion(.failure(.generic))
                    return
                }
                completion(.success(firstUrl))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func storeRecentlyURLList(response: [URLShortenerResponse]) throws { }
    
    func fetchRecentlyURLList() throws -> [URLShortenerResponse] {
        let result = getStorageStub(fileName: "json_url_recent_list", resultType: [URLShortenerResponse].self)
        switch result {
        case .success(let urlList):
            return urlList
        case .failure:
            return []
        }
    }
}

private extension URLShortenerServiceMock {
    func getStorageStub<T: Decodable>(fileName: String, resultType: T.Type) -> Result<T, ApiError> {
        guard let asset = NSDataAsset(name: fileName, bundle: Bundle.main) else {
            return .failure(.generic)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(T.self, from: asset.data)
            return .success(response)
        } catch {
            return .failure(.generic)
        }
    }
    
    func getStub<T: Decodable>(fileName: String, resultType: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let asset = NSDataAsset(name: fileName, bundle: Bundle.main) else {
            completion(.failure(.generic))
            return
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(T.self, from: asset.data)
            completion(.success(response))
        } catch { completion(.failure(.generic)) }
    }
}
