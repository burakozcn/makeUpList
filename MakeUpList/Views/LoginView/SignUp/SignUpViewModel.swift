import UIKit
import Firebase

class SignUpViewModel {
  let childRef = Database.database().reference()
  var viewController: SignUpViewController!
  var coordinator: SignUpCoordinator!
  
  func signUp(name: String, surname: String, username: String, email: String, password: String) {
    viewController = SignUpViewController()
    
    childRef.child("Usernames").observeSingleEvent(of: .value) { [weak self] snapshot in
      if snapshot.hasChild(username) {
        self?.viewController.showAlert(success: false, message: "Username already exists, please choose another.")
      } else {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
          if error != nil {
            if let errorCode = AuthErrorCode(rawValue: error!._code) {
              switch errorCode {
              case .emailAlreadyInUse:
                self?.viewController.showAlert(success: false, message: "This email is already in use, please choose another.")
              case .weakPassword:
                self?.viewController.showAlert(success: false, message: "Please choose stronger password for your security.")
              case .invalidEmail:
                self?.viewController.showAlert(success: false, message: "This email is invalid, please provide a proper email address.")
              default:
                print("There is something else problem.")
              }
            }
          } else {
            self?.childRef.child("Usernames").child(username).setValue(["username": username])
            self?.childRef.child("UserProfile").child(user!.user.uid).setValue([
              "name": name,
              "surname": surname,
              "username": username,
              "groupCount": 0
              ])
            self?.viewController.showAlert(success: true, message: "Sign in is successful, you can login with this mail and password.")
          }
        }
      }
    }
  }
  
  func backtoLogin() {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = SignUpCoordinator(rootViewController: vc)
    coordinator.backtoLogin()
  }
}
