import UIKit
import RxSwift

class SummaryViewCoordinator: BaseCoordinator<Void> {
  let rootViewController: UINavigationController
  var viewController: SummaryViewController!
  var viewModel: SummaryViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = SummaryViewController()
    viewModel = SummaryViewModel()
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
}
