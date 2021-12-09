import UIKit
import NetworkCore

protocol URLShortenerCoordinating: Coordinating {
    
}

final class URLShortenerCoordinator: URLShortenerCoordinating {
    var childCoordinators: [Coordinating] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service: URLShortenerServicing = CommandLine.arguments.contains("--uitesting") ? URLShortenerServiceMock() : URLShortenerService(network: Network(), storage: Storage())
        let viewModel = URLShortenerViewModel(coordinator: self, service: service)
        let viewController = URLShortenerViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
