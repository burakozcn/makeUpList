import UIKit
import Firebase

class LoginViewModel {
  var coordinator: LoginCoordinator!
  var viewController: LoginViewController!
  
  func openSignUp() {
    let window = UIApplication.shared.keyWindow
    let vc = window?.rootViewController as! UINavigationController
    coordinator = LoginCoordinator(window: window!)
    coordinator.openSignUp(on: vc)
  }
  
  func login(email: String, password: String) {
    viewController = LoginViewController()
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
      if error != nil {
        if let error = AuthErrorCode(rawValue: error!._code) {
          switch error {
          case .invalidEmail:
            self?.viewController.showAlert(message: "You entered an invalid email.")
          case .wrongPassword:
            self?.viewController.showAlert(message: "You entered a wrong password.")
          default:
            self?.viewController.showAlert(message: "There is problem on your login, please check.")
          }
        }
      } else {
        let window = UIApplication.shared.keyWindow
        let vc = window?.rootViewController as! UINavigationController
        let coordinator = LoginCoordinator(window: window!)
        coordinator.openGroupView(on: vc)
      }
    }
  }
}
