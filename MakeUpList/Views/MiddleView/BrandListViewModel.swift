import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Firebase

class BrandViewModel {
  var viewController: BrandViewController!
  let reference = Database.database().reference(withPath: "brands")
  let group: Group
  var coordinator: BrandTableCoordinator!
  typealias BrandSections = (_ sections: [SectionOfBrands]) -> Void
  
  init(group: Group) {
    self.group = group
  }
  
  func sections(handler: @escaping BrandSections) {
    var sectionsUpdate = [SectionOfBrands]()
    
    reference.observe(.value) { snapshot in
      var snap: DataSnapshot
      if (self.group.system) {
        snap = snapshot.childSnapshot(forPath: "system-default-value").childSnapshot(forPath: self.group.name)
      } else {
        let userId = Auth.auth().currentUser?.uid
        snap = snapshot.childSnapshot(forPath: userId!).childSnapshot(forPath: self.group.name)
      }
      if snap.exists() {
        let brand = snap.value as! NSArray
        
        let id = brand.mutableArrayValue(forKeyPath: "id") as! [Int]
        let name = brand.mutableArrayValue(forKeyPath: "name") as! [String]
        let price = brand.mutableArrayValue(forKeyPath: "price") as! [Double]
        let feature = brand.mutableArrayValue(forKeyPath: "feature") as! [String]
        let available = brand.mutableArrayValue(forKeyPath: "available") as! [Bool]
        
        for i in 0 ..< brand.count {
          let sectBrand = SectionOfBrands(header: "Brands", items: [Brand(id: id[i], name: name[i], price: price[i], feature: feature[i], available: available[i])])
          sectionsUpdate.append(sectBrand)
        }
      }
      handler(sectionsUpdate)
    }
  }
  
  func source(_ tableView: UITableView) -> RxTableViewSectionedReloadDataSource<SectionOfBrands> {
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfBrands> (configureCell: {
      dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! BrandTableViewCell
      cell.label.text = item.name
      cell.brand = item
      
      if cell.brand.available {
        cell.label.textColor = .black
      } else {
        cell.label.textColor = .lightGray
      }
      
      return cell
    })
    return dataSource
  }
  
  func changeAvailable(brand: Brand, completion: @escaping (Bool?) -> Void) {
    let path: DatabaseReference
    if (group.system) {
      path = reference.child("system-default-value").child("\(group.name)").child("\(brand.id)")
    } else {
      let current = Auth.auth().currentUser?.uid
      path = reference.child(current!).child("\(group.name)").child("\(brand.id)")
    }

    if brand.available {
      path.updateChildValues(["available" : false])
      completion(false)
    } else {
      path.updateChildValues(["available" : true])
      completion(true)
    }
    viewController = BrandViewController(group: group)
    self.viewController.tableView.reloadData()
  }
  
  func backToGroupView() {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = BrandTableCoordinator(rootViewController: vc, group: group)
    coordinator.backToGroupView(on: vc)
  }
  
  func goToBrandAdd(brand: Brand?, new: Bool) {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = BrandTableCoordinator(rootViewController: vc, group: group)
    coordinator.goToBrandAdd(on: vc, brand: brand, new: new)
  }
  
  func goToDetail(brand: Brand) {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = BrandTableCoordinator(rootViewController: vc, group: group)
    coordinator.goToDetail(on: vc, brand: brand)
  }
}


