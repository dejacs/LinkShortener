import UIKit

protocol Coordinating {
    var childCoordinators: [Coordinating] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
