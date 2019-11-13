import UIKit
import Firebase

class LoginViewModel {
  var coordinator: LoginCoordinator!
  var viewController: LoginViewController!
  
  func openSignUp() {
    let window = UIApplication.shared.windows.first
    let vc = window?.rootViewController as! UINavigationController
    coordinator = LoginCoordinator(window: window!)
    coordinator.openSignUp(on: vc)
  }
  
  func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
      if error != nil {
        self?.loginError(error: error)
        completion(false, error)
      } else {
        self?.loginSuccess()
        completion(true, nil)
      }
    }
  }
  
  private func loginError(error: Error?) {
    viewController = LoginViewController()
    if let error = AuthErrorCode(rawValue: error!._code) {
      switch error {
      case .invalidEmail:
        viewController.showAlert(message: NSLocalizedString("invaliderror", comment: "You entered an invalid email."))
      case .wrongPassword:
        viewController.showAlert(message: NSLocalizedString("wrongpasserror", comment: "You entered a wrong password."))
      default:
        viewController.showAlert(message: NSLocalizedString("generalerror", comment: "There is a problem with your login, please check."))
      }
    }
  }
  
  private func loginSuccess() {
    let window = UIApplication.shared.windows.first
    let vc = window?.rootViewController as! UINavigationController
    let coordinator = LoginCoordinator(window: window!)
    loginFirstCheck(value: { bool in
      if bool {
        coordinator.openOrientationView(on: vc)
      } else {
        coordinator.openGroupView(on: vc)
      }
    })
  }
  
  private func loginFirstCheck(value: @escaping (Bool) -> Void){
    let uid = Auth.auth().currentUser?.uid
    Database.database().reference(withPath: "UserProfile").child(uid!).observe(.value) { snapshot in
      let bool = snapshot.childSnapshot(forPath: "firstTime").value as? Bool
      if let bool = bool {
        value(bool)
      } else {
        value(false)
      }
    }
  }
  
  func deleteUser(completion: @escaping (Error?) -> Void) {
    Database.database().reference().child("Usernames").child("signUpMockUser").removeValue()
    Database.database().reference().child("UserProfile").child((Auth.auth().currentUser?.uid)!).removeValue()
    Auth.auth().currentUser?.delete(completion: { error in
      if let _error = error {
        print("Mock User Delete Error = \(_error.localizedDescription)")
        completion(error)
      } else {
        completion(nil)
      }
    })
  }
}
