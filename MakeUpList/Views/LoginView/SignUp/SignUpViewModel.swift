import UIKit
import Firebase

class SignUpViewModel {
  let childRef = Database.database().reference()
  var viewController: SignUpViewController!
  var coordinator: SignUpCoordinator!
  
  func signUp(name: String, surname: String, username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    userExistsCheck(username: username) { [weak self] result in
      if !(result) {
        completion(result, nil)
      } else {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
          if error != nil {
            self?.signUpFail(error: error)
            completion(false, error)
          } else {
            self?.signUpSuccess(name: name, surname: surname, username: username, email: email, password: password, user: user)
            completion(true, nil)
          }
        }
      }
    }
  }
  
  private func userExistsCheck(username: String, check: @escaping (Bool)-> Void) {
    viewController = SignUpViewController()
    childRef.child("Usernames").observeSingleEvent(of: .value) { [weak self] snapshot in
      if snapshot.hasChild(username) {
        self?.viewController.showAlert(success: false, message: NSLocalizedString("userexisterror", comment: "Username already exists, please choose another."))
        check(false)
      } else {
        check(true)
      }
    }
  }
  
  private func signUpSuccess(name: String, surname: String, username: String, email: String, password: String, user: AuthDataResult?) {
    viewController = SignUpViewController()
    childRef.child("Usernames").child(username).setValue(["username": username])
    childRef.child("UserProfile").child(user!.user.uid).setValue([
      "name": name,
      "surname": surname,
      "username": username,
      "groupCount": 0,
      "email" : email,
      "firstTime" : true
    ])
    viewController.showAlert(success: true, message: NSLocalizedString("signinsuccess", comment: "Sign in is successful, you can login with this mail and password."))
  }
  
  private func signUpFail(error: Error?) {
    viewController = SignUpViewController()
    if let errorCode = AuthErrorCode(rawValue: error!._code) {
      switch errorCode {
      case .emailAlreadyInUse:
        viewController.showAlert(success: false, message: NSLocalizedString("alreadyuseerror", comment: "This email is already in use, please choose another."))
      case .weakPassword:
        viewController.showAlert(success: false, message: NSLocalizedString("strongerror", comment: "Please choose stronger password for your security."))
      case .invalidEmail:
        viewController.showAlert(success: false, message: "This email is invalid, please provide a proper email address.")
      default:
        print("There is something else problem.")
      }
    }
  }
  
  func backtoLogin() {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = SignUpCoordinator(rootViewController: vc)
    coordinator.backtoLogin()
  }
}
