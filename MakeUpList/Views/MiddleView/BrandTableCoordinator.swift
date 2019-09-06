import UIKit
import RxSwift

class BrandTableCoordinator: BaseCoordinator<Void> {
  private let rootViewController: UINavigationController
  private let group: Group
  var viewController: BrandViewController!
  var viewModel: BrandViewModel!
  
  init(rootViewController: UINavigationController, group: Group) {
    self.rootViewController = rootViewController
    self.group = group
    super.init()
  }

  override func start() -> Observable<Void> {
    viewController = BrandViewController(group: group)
    viewModel = BrandViewModel(group: group)
    
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
  
  @discardableResult
  func backToGroupView(on rootViewController: UINavigationController) -> Observable<Void> {
    let groupCoordinator = GroupCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: groupCoordinator)
  }
  
  @discardableResult
  func goToBrandAdd(on rootViewController: UINavigationController, brand: Brand?) -> Observable<Void> {
    let brandAddCoordinator = BrandAddViewCoordinator(rootViewController: rootViewController, group: group, brand: brand)
    return coordinate(coordinator: brandAddCoordinator)
  }
  
  @discardableResult
  func goToDetail(on rootViewController: UINavigationController, brand: Brand) -> Observable<Void> {
    let detailCoordinator = DetailViewCoordinator(rootViewController: rootViewController, brand: brand)
    return coordinate(coordinator: detailCoordinator)
  }
}

