import UIKit
import RxSwift
import Firebase

class LoginCoordinator: BaseCoordinator<Void> {
  private let window: UIWindow
  private var loginVC: LoginViewController!
  private var viewModel: LoginViewModel!
  
  init(window: UIWindow) {
    self.window = window
    super.init()
  }
  
  override func start() -> Observable<Void> {
    loginVC = LoginViewController()
    viewModel = LoginViewModel()
    
    loginVC.viewModel = viewModel
    
    window.rootViewController = UINavigationController(rootViewController: loginVC)
    window.makeKeyAndVisible()
    
    return Observable.never()
  }
  
  @discardableResult
  func openSignUp(on rootViewController: UINavigationController) -> Observable<Void> {
    let signUpCoordinator = SignUpCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: signUpCoordinator)
  }
  
  @discardableResult
  func openGroupView(on rootViewController: UINavigationController) -> Observable<Void> {
    let groupCoordinator = GroupCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: groupCoordinator)
  }
  
  @discardableResult
  func openOrientationView(on rootViewController: UINavigationController) -> Observable<Void> {
    let orientCoordinator = OrientationViewCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: orientCoordinator)
  }
}
