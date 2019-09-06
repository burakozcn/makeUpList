import UIKit
import RxSwift

class BrandAddViewCoordinator: BaseCoordinator<Void> {
  let group: Group
  let brand: Brand?
  let rootViewController: UINavigationController
  var viewController: BrandAddViewController!
  var viewModel: BrandAddViewModel!
  
  init(rootViewController: UINavigationController, group: Group, brand: Brand?) {
    self.rootViewController = rootViewController
    self.group = group
    self.brand = brand
    super.init()
  }
  
  override func start() -> Observable<Void> {
    viewController = BrandAddViewController(group: group, brand: brand)
    viewModel = BrandAddViewModel(group: group)
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
  
  @discardableResult
  func backToBrand(on rootViewController: UINavigationController) -> Observable<Void> {
    let brandCoordinator = BrandTableCoordinator(rootViewController: rootViewController, group: group)
    return coordinate(coordinator: brandCoordinator)
  }
}
