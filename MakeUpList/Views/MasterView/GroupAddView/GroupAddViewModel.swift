import UIKit
import RxSwift
import Firebase
import Photos

class GroupAddViewModel {
  var viewController: GroupAddViewController!
  var coordinator: GroupAddCoordinator!
  let reference = Database.database().reference()
  let storageRef = Storage.storage().reference()
  
  func saveGroup(groupName: String, imageView: UIImageView?, completion:@escaping (Error?) -> Void) {
    viewController = GroupAddViewController()
    let current = Auth.auth().currentUser?.uid
    if current != nil {
      self.nameWrite(groupName: groupName, userId: current!) { [weak self] nameError in
        self?.imageWrite(groupName: groupName, imageView: imageView, userId: current!) { imageError in
          if (nameError != nil || imageError != nil) {
            completion(imageError)
          } else {
            self?.viewController.showAlert()
            completion(nil)
          }
        }
      }
    }
  }
  
  func nameWrite(groupName:String, userId: String, completion:@escaping (Error?) -> Void) {
    let userPath = reference.child("UserProfile").child(userId)
    userPath.observeSingleEvent(of: .value) { [weak self] snapshot in
      let groupCount = snapshot.childSnapshot(forPath: "groupCount").value as! Int
      let writePath = self?.reference.child("groups").child(userId).child(String(groupCount))
      let value: [String : Any] = ["name": groupName, "id": groupCount, "image": "\((userId) + (groupName))", "isEditable": true, "brandCount": 0, "system": false]
      writePath!.setValue(value)
      userPath.updateChildValues(["groupCount": groupCount + 1])
    }
    completion(nil)
  }
  
  func imageWrite(groupName: String, imageView: UIImageView?, userId: String, completion:@escaping (Error?) -> Void) {
    let imageRef = storageRef.child("images/\((userId) + (groupName)).jpg")
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    if let image = imageView?.image {
      let data = image.jpegData(compressionQuality: 0.2)
      
      let uploadTask = imageRef.putData(data!, metadata: metadata)
      
      uploadTask.observe(.success) { snapshot in
        completion(nil)
        print("Upload task succeed.")
      }
      
      uploadTask.observe(.failure) { [weak self] snapshot in
        self?.uploadError(error: snapshot.error)
        completion(snapshot.error)
      }
    }
  }
  
  private func uploadError(error: Error?) {
    if let _error = error {
      if let errorCode = StorageErrorCode(rawValue: _error._code) {
        switch errorCode {
        case .objectNotFound:
          break
        case .unauthorized:
          break
        case .cancelled:
          break
        default:
          break
        }
      }
    }
  }
  
  func openGroupView() {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = GroupAddCoordinator(rootViewController: vc)
    coordinator.backToGroupView(on: vc)
  }
  
  func openGallery(viewController: UIViewController) {
    checkPermission()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      viewController.present(imagePicker, animated: true, completion: nil)
    }
    else
    {
      let alert  = UIAlertController(title: NSLocalizedString("warning", comment: "Warning"), message: NSLocalizedString("permissionmessage", comment: "You don't have permission to access gallery."), preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      viewController.present(alert, animated: true, completion: nil)
    }
  }
  
  func checkPermission() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized:
      print("Access is granted by user")
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({
        (newStatus) in
        print("status is \(newStatus)")
        if newStatus ==  PHAuthorizationStatus.authorized {
          print("success")
        }
      })
      print("It is not determined until now")
    case .restricted:
      print("User do not have access to photo album.")
    case .denied:
      print("User has denied the permission.")
    @unknown default:
      print("Unknown Error")
    }
  }
  
  //  MARK: DELETE PART
  
  func deleteGroup(completion:@escaping (Error?) -> Void) {
    let userId = Auth.auth().currentUser?.uid
    if userId != nil {
      getCount(user: userId!) { count in
        self.nameDelete(userId: userId!, count: count) { [weak self] nameError in
          self?.imageDelete(userId: userId!, completion: { imageError in
            if (imageError != nil) {
              completion(imageError)
            } else if (nameError != nil) {
              completion(nameError)
            } else {
              completion(nil)
            }
          })
        }
      }
    }
  }
  
  private func getCount(user: String, completion: @escaping (UInt) -> Void) {
    reference.child("groups").child("\(user)").observe(.value) { snapshot in
      let count = snapshot.childrenCount
      completion(count)
    }
  }
  
  private func nameDelete(userId: String, count: UInt, completion:@escaping (Error?) -> Void) {
    reference.child("groups").child(userId).child("\(count)").setValue(["name" : nil]) { (error1, reference) in
      self.reference.child("UserProfile").child(userId).updateChildValues(["groupCount" : count - 1]) { (error2, reference) in
        if let error = error1 {
          completion(error)
        } else if let error = error2 {
          completion(error)
        } else {
          completion(nil)
        }
      }
    }
  }
  
  private func imageDelete(userId: String, completion: @escaping (Error?) -> Void) {
    storageRef.child("images").child("\(userId)MockData.jpg").delete { error in
      if let _error = error {
        print(_error.localizedDescription)
        completion(_error)
      } else {
        completion(nil)
      }
    }
  }
}
