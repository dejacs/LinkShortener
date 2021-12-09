protocol URLShortenerViewModeling {
    func fetchShortURL(for urlText: String?)
    func copyShortURL(for item: URLShortenerResponse)
    func fetchShortenedURLList()
}

final class URLShortenerViewModel {
    private let coordinator: URLShortenerCoordinating
    private let service: URLShortenerServicing
    weak var viewController: URLShortenerDisplaying?
    
    init(coordinator: URLShortenerCoordinating, service: URLShortenerServicing) {
        self.coordinator = coordinator
        self.service = service
    }
}

extension URLShortenerViewModel: URLShortenerViewModeling {
    func fetchShortURL(for urlText: String?) {
        guard let urlText = urlText else { return }
        service.postAlias(text: urlText) { result in
            switch result {
            case .success(let response):
                self.handleURLShortened(for: response)
            case .failure:
                self.viewController?.displayShortURLError()
            }
        }
    }
    
    func copyShortURL(for item: URLShortenerResponse) {
        viewController?.copy(shortURL: item.shortURL)
        viewController?.displayCopyMessage()
    }
    
    func fetchShortenedURLList() {
        do {
            let urlList = try service.fetchRecentlyURLList()
            viewController?.updateTable(with: urlList)
        } catch {
            viewController?.displayTableError()
        }
    }
}

private extension URLShortenerViewModel {
    func handleURLShortened(for response: URLShortenerResponse) {
        updateStoredURLList(with: response)
        viewController?.updateTable(with: response)
        viewController?.copy(shortURL: response.shortURL)
        viewController?.displayCopyMessage()
    }
    
    func updateStoredURLList(with response: URLShortenerResponse) {
        do {
            var urlList = try service.fetchRecentlyURLList()
            urlList.append(response)
            try service.storeRecentlyURLList(response: urlList)
        } catch {
            viewController?.displayUnsavedURLError()
        }
    }
}
