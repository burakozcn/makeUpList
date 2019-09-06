import UIKit
import RxSwift

class DetailViewCoordinator: BaseCoordinator<Void> {
  let rootViewController: UINavigationController
  let brand: Brand
  var viewController: DetailViewController!
  var viewModel: DetailViewModel!
  
  init(rootViewController: UINavigationController, brand: Brand) {
    self.rootViewController = rootViewController
    self.brand = brand
    super.init()
  }
  
  override func start() -> Observable<Void> {
    viewController = DetailViewController(brand: brand)
    viewModel = DetailViewModel(brand: brand)
    viewController.viewModel = viewModel
    
    rootViewController.pushViewController(viewController, animated: true)
    
    return Observable.never()
  }
}
