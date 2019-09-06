import RxSwift
import UIKit

class AppCoordinator: BaseCoordinator<Void> {
  private let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() -> Observable<Void> {
    let loginCoordinator = LoginCoordinator(window: window)
    return coordinate(coordinator: loginCoordinator)
  }
}
