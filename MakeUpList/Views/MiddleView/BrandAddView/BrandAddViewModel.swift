import UIKit
import RxSwift
import Firebase

class BrandAddViewModel {
  let group: Group
  let new: Bool
  var viewController: BrandAddViewController!
  var coordinator: BrandAddViewCoordinator!
  let reference = Database.database().reference()
  
  init(group: Group, new: Bool) {
    self.group = group
    self.new = new
  }
  
  func saveBrand(name: String, price: Double, feature: String, brand: Brand?, completion: (Error?) -> Void) {
    viewController = BrandAddViewController(group: group, brand: brand, new: new)
    let mainPath: DatabaseReference
    let writePath: DatabaseReference
    
    if (group.system) {
      mainPath = reference.child("groups").child("system-default-value").child("\(group.id)")
      writePath = reference.child("brands").child("system-default-value").child(group.name)
    } else {
      let current = Auth.auth().currentUser?.uid
      mainPath = reference.child("groups").child(current!).child("\(group.id)")
      writePath = reference.child("brands").child(current!).child(group.name)
    }
    
    mainPath.observeSingleEvent(of: .value) { [weak self] snapshot in
      let id = snapshot.childSnapshot(forPath: "brandCount").value as! Int
      let value: [String : Any] = ["id": id, "name": name, "price": price, "feature": feature, "available": false]
      writePath.child("\(id)").setValue(value)
      mainPath.updateChildValues(["brandCount" : id + 1])
      self?.viewController.showAlert(new: (self?.new)!)
    }
    completion(nil)
  }
  
  func editBrand(name: String, price: Double, feature: String, brand: Brand?, completion: (Error?) -> Void) {
    viewController = BrandAddViewController(group: group, brand: brand, new: new)
    let writePath: DatabaseReference
    
    if (group.system) {
      writePath = reference.child("brands").child("system-default-value").child(group.name)
    } else {
      let current = Auth.auth().currentUser?.uid
      writePath = reference.child("brands").child(current!).child(group.name)
    }
    
    writePath.child("\(brand!.id)").observe(.value) { [weak self] snapshot in
      let value: [String : Any] = ["id": brand!.id, "name": name, "price": price, "feature": feature, "available": brand!.available]
      writePath.child("\(brand!.id)").updateChildValues(value)
      self?.viewController.showAlert(new: (self?.new)!)
    }
    completion(nil)
  }
  
  func backToBrand() {
    let vc = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
    coordinator = BrandAddViewCoordinator(rootViewController: vc, group: group, brand: nil, new: new)
    coordinator.backToBrand(on: vc)
  }
  
  private func saveShops() {
    reference.child("shops")
  }
  
  func deleteBrand(completion:@escaping (Error?) -> Void) {
    let userId = Auth.auth().currentUser?.uid
    if userId != nil {
      getCount(user: userId!) { count in
        self.nameDelete(userId: userId!, count: count) { nameError in
          if (nameError != nil) {
            print("There is an error!")
          } else {
            completion(nil)
          }
        }
      }
    }
  }
  
  private func getCount(user: String, completion: @escaping (UInt) -> Void) {
    reference.child("brands").child("\(user)").observe(.value) { snapshot in
      let count = snapshot.childrenCount
      completion(count)
    }
  }
  
  private func getId(user: String, completion: @escaping (Int) -> Void) {
    reference.child("groups").child("\(user)").observe(.value) { snapshot in
      
    }
  }
  
  private func nameDelete(userId: String, count: UInt, completion:@escaping (Error?) -> Void) {
    reference.child("groups").child(userId).child("\(count)").setValue(["name" : nil]) { (error, reference) in
      if let error = error {
        completion(error)
      } else {
        completion(nil)
      }
    }
    reference.child("UserProfile").child(userId).updateChildValues(["groupCount" : count - 1]) { (error, reference) in
      if let error = error {
        completion(error)
      } else {
        completion(nil)
      }
    }
  }
}
