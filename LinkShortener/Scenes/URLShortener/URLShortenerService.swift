import Foundation
import NetworkCore

protocol URLShortenerServicing {
    func postAlias(text: String, completion: @escaping (Result<URLShortenerResponse, ApiError>) -> Void)
    func storeRecentlyURLList(response: [URLShortenerResponse]) throws
    func fetchRecentlyURLList() throws -> [URLShortenerResponse]
}

private enum StorageKey: String {
    case shortenedURL
}

final class URLShortenerService {
    private let network: Networking
    private let storage: Storaging
    
    init(network: Networking, storage: Storaging) {
        self.network = network
        self.storage = storage
    }
}

extension URLShortenerService: URLShortenerServicing {
    func postAlias(text: String, completion: @escaping (Result<URLShortenerResponse, ApiError>) -> Void) {
        network.fetchData(
            endpoint: URLShortenerEndpoint.postAlias(text: text),
            resultType: URLShortenerResponse.self,
            decodingStrategy: .useDefaultKeys,
            completion: completion)
    }
    
    func storeRecentlyURLList(response: [URLShortenerResponse]) throws {
        try storage.create(object: response, key: StorageKey.shortenedURL.rawValue)
    }
    
    func fetchRecentlyURLList() throws -> [URLShortenerResponse] {
        try storage.read(objectType: [URLShortenerResponse].self, key: StorageKey.shortenedURL.rawValue)
    }
}
