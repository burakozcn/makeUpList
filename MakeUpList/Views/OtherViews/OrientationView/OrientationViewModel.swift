import UIKit
import RxSwift
import Firebase

class OrientationViewModel {
  var coordinator: OrientationViewCoordinator!
  var firstViewController: OrientationViewController!
  var secondViewController: SecondViewController!
  var thirdViewController: ThirdViewController!
  
  func goToGroupView() {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = OrientationViewCoordinator(rootViewController: vc)
    coordinator.goToGroupView(on: vc)
  }
  
  func goToFirst(viewController: UIViewController) {
    let navVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    firstViewController = OrientationViewController()
    firstViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(firstViewController, animated: true)
  }
  
  func goToSecond(viewController: UIViewController) {
    let navVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    secondViewController = SecondViewController()
    secondViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(secondViewController, animated: true)
  }
  
  func goToThird(viewController: UIViewController) {
    let navVC = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    thirdViewController = ThirdViewController()
    thirdViewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
    navVC.pushViewController(thirdViewController, animated: true)
  }
  
  func changeFirstTime() {
    loginFirstCheck { bool in
      if bool {
        let uid = Auth.auth().currentUser?.uid
        let value = ["firstTime" : false]
        Database.database().reference(withPath: "UserProfile").child(uid!).updateChildValues(value)
      }
    }
  }
  
  private func loginFirstCheck(value: @escaping (Bool) -> Void){
    let uid = Auth.auth().currentUser?.uid
    Database.database().reference(withPath: "UserProfile").child(uid!).observe(.value) { snapshot in
      let bool = snapshot.childSnapshot(forPath: "firstTime").value as! Bool
      value(bool)
    }
  }
}
