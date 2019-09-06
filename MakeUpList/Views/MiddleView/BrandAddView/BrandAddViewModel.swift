import UIKit
import RxSwift
import Firebase

class BrandAddViewModel {
  let group: Group
  var viewController: BrandAddViewController!
  var coordinator: BrandAddViewCoordinator!
  let reference = Database.database().reference()
  
  init(group: Group) {
    self.group = group
  }
  
  func saveBrand(name: String, price: Double, feature: String, brand: Brand?) {
    viewController = BrandAddViewController(group: group, brand: brand)
    let writePath = reference.child("brands").child(group.name)
    let mainPath: DatabaseReference
    
    if (group.system) {
      mainPath = reference.child("groups").child("system-default-value").child("\(group.id)")
    } else {
      let current = Auth.auth().currentUser?.uid
      mainPath = reference.child("groups").child(current!).child("\(group.id)")
    }
    
    mainPath.observeSingleEvent(of: .value) { [weak self] snapshot in
      let id = snapshot.childSnapshot(forPath: "brandCount").value as! Int
      var values = [[String : Any]]()
      let value: [String : Any] = ["id": id, "name": name, "price": price, "feature": feature, "available": false]
      values.append(value)
      writePath.setValue(values)
      mainPath.updateChildValues(["brandCount" : id + 1])
      self?.viewController.showAlert()
    }
  }
  
  func backToBrand() {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = BrandAddViewCoordinator(rootViewController: vc, group: group, brand: nil)
    coordinator.backToBrand(on: vc)
  }
  
  private func saveShops() {
    reference.child("shops")
  }
}
