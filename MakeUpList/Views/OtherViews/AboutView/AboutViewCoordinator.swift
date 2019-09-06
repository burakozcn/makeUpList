import UIKit
import RxSwift

class AboutViewCoordinator: BaseCoordinator<Void> {
  let rootViewController: UINavigationController
  var viewController: AboutViewController!
  var viewModel: AboutViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() -> Observable<Void> {
    viewController = AboutViewController()
    viewModel = AboutViewModel()
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
}
