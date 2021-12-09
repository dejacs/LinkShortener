import UIKit

final class MainCoordinator: Coordinating {
    var childCoordinators = [Coordinating]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coordinator = URLShortenerCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
