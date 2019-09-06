import UIKit
import RxSwift
import Firebase
import Photos

class GroupAddViewModel {
  var viewController: GroupAddViewController!
  var coordinator: GroupAddCoordinator!
  let reference = Database.database().reference()
  let storageRef = Storage.storage().reference()
  
  func saveGroup(groupName: String, imageView: UIImageView?) {
    viewController = GroupAddViewController()
    let current = Auth.auth().currentUser?.uid
    if current != nil {
      let userPath = reference.child("UserProfile").child(current!)
      userPath.observeSingleEvent(of: .value) { [weak self] snapshot in
        let groupCount = snapshot.childSnapshot(forPath: "groupCount").value as! Int
        let writePath = self?.reference.child("groups").child(current!).child(String(groupCount))
        let value: [String : Any] = ["name": groupName, "id": groupCount, "image": "\((current!) + (groupName))", "isEditable": true, "brandCount": 0, "system": false]
        writePath!.setValue(value)
        userPath.updateChildValues(["groupCount": groupCount + 1])
      }
      let imageRef = storageRef.child("images/\((current!) + (groupName)).jpg")
      let metadata = StorageMetadata()
      metadata.contentType = "image/jpeg"
      if let image = imageView?.image {
        let data = image.jpegData(compressionQuality: 0.2)
        
        let uploadTask = imageRef.putData(data!, metadata: metadata)
        
        uploadTask.observe(.success) { snapshot in
          print("Upload task succeed.")
        }
        
        uploadTask.observe(.failure) { snapshot in
          if snapshot.error != nil {
            if let errorCode = StorageErrorCode(rawValue: snapshot.error!._code) {
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
      }
    }
    viewController.showAlert()
  }
  
  func openGroupView() {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
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
      let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
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
}
