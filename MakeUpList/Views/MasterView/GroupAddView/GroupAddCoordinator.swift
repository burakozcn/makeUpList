import UIKit
import RxSwift

class GroupAddCoordinator: BaseCoordinator<Void> {
  private let rootViewController: UINavigationController
  private var viewController: GroupAddViewController!
  private var viewModel: GroupAddViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
    super.init()
  }
  
  override func start() -> Observable<Void> {
    viewController = GroupAddViewController()
    viewModel = GroupAddViewModel()
    
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
  
  @discardableResult
  func backToGroupView(on rootViewController: UINavigationController) -> Observable<Void> {
    let groupCoordinator = GroupCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: groupCoordinator)
  }
}
