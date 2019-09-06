import UIKit
import RxSwift
import Firebase

class GroupCoordinator: BaseCoordinator<Void> {
  private let rootViewController: UINavigationController
  private var groupVC: GroupViewController!
  private var viewModel: GroupViewModel!
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
    super.init()
  }
  
  override func start() -> Observable<Void> {
    groupVC = GroupViewController()
    viewModel = GroupViewModel()
    
    groupVC.viewModel = viewModel
    
    rootViewController.pushViewController(groupVC, animated: true)
    
    return Observable.never()
  }
  
  @discardableResult
  func goToGroupAdd(on rootViewController: UINavigationController) -> Observable<Void> {
    let groupAddCoordinator = GroupAddCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: groupAddCoordinator)
  }
  
  @discardableResult
  func backToLogin(on window: UIWindow) -> Observable<Void> {
    let loginCoordinator = LoginCoordinator(window: window)
    return coordinate(coordinator: loginCoordinator)
  }
  
  @discardableResult
  func openBrand(on rootViewController: UINavigationController, group: Group) -> Observable<Void> {
    let brandCoordinator = BrandTableCoordinator(rootViewController: rootViewController, group: group)
    return coordinate(coordinator: brandCoordinator)
  }
  
  @discardableResult
  func openOrientation(on rootViewController: UINavigationController) -> Observable<Void> {
    let orientationCoordinator = OrientationViewCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: orientationCoordinator)
  }
  
  @discardableResult
  func openAbout(on rootViewController: UINavigationController) -> Observable<Void> {
    let aboutCoordinator = AboutViewCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: aboutCoordinator)
  }
  
  @discardableResult
  func openSummary(on rootViewController: UINavigationController) -> Observable<Void> {
    let summaryCoordinator = SummaryViewCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: summaryCoordinator)
  }
  
  @discardableResult
  func openPriceTable(on rootViewController: UINavigationController) -> Observable<Void> {
    let priceTableCoordinator = PriceTableViewCoordinator(rootViewController: rootViewController)
    return coordinate(coordinator: priceTableCoordinator)
  }
}
