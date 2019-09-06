import UIKit
import RxSwift

class OrientationViewCoordinator: BaseCoordinator<Void> {
  let rootViewController: UINavigationController
  var viewController: OrientationViewController!
  var viewModel: OrientationViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = OrientationViewController()
    viewModel = OrientationViewModel()
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
  
  @discardableResult
  func goToGroupView(on rootViewController: UINavigationController) -> Observable<Void> {
    let groupCoordinator = GroupCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: groupCoordinator)
  }
}
