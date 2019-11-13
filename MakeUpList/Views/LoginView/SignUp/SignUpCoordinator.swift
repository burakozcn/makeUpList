import UIKit
import RxSwift

class SignUpCoordinator: BaseCoordinator<Void> {
  private let rootViewController: UINavigationController
  private var viewController: SignUpViewController!
  private var viewModel: SignUpViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = SignUpViewController()
    
    viewModel = SignUpViewModel()
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
  
  func backtoLogin() {
    let window = UIApplication.shared.windows.first!
    let loginCoordinator = LoginCoordinator(window: window)
    coordinate(coordinator: loginCoordinator)
  }
}
