import UIKit
import RxSwift

class BrandAddViewCoordinator: BaseCoordinator<Void> {
  let group: Group
  let brand: Brand?
  let new: Bool
  let rootViewController: UINavigationController
  var viewController: BrandAddViewController!
  var viewModel: BrandAddViewModel!
  
  init(rootViewController: UINavigationController, group: Group, brand: Brand?, new: Bool) {
    self.rootViewController = rootViewController
    self.group = group
    self.brand = brand
    self.new = new
    super.init()
  }
  
  override func start() -> Observable<Void> {
    viewController = BrandAddViewController(group: group, brand: brand, new: new)
    viewModel = BrandAddViewModel(group: group, new: new)
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
