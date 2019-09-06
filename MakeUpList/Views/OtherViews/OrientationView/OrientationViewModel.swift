import UIKit
import RxSwift

class OrientationViewModel {
  var coordinator: OrientationViewCoordinator!
  var firstViewController: OrientationViewController!
  var secondViewController: SecondViewController!
  var thirdViewController: ThirdViewController!
  
  func goToGroupView() {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = OrientationViewCoordinator(rootViewController: vc)
    coordinator.goToGroupView(on: vc)
  }
  
  func goToFirst(viewController: UIViewController) {
    let navVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    firstViewController = OrientationViewController()
    firstViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(firstViewController, animated: true)
  }
  
  func goToSecond(viewController: UIViewController) {
    let navVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    secondViewController = SecondViewController()
    secondViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(secondViewController, animated: true)
  }
  
  func goToThird(viewController: UIViewController) {
    let navVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    thirdViewController = ThirdViewController()
    thirdViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(thirdViewController, animated: true)
  }
}
