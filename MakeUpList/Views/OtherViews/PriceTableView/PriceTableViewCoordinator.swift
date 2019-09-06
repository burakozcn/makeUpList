import UIKit
import RxSwift

class PriceTableViewCoordinator: BaseCoordinator<Void> {
  let rootViewController: UINavigationController
  var viewController: PriceTableViewController!
  var viewModel: PriceTableViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = PriceTableViewController()
    viewModel = PriceTableViewModel()
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
}
