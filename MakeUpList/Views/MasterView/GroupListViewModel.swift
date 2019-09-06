import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Firebase

class GroupViewModel {
  var coordinator:  GroupCoordinator!
  var model: Group!
  var viewController: GroupViewController!
  let reference = Database.database().reference(withPath: "groups")
  let storageRef = Storage.storage()
  typealias Sections = (_ sections: [SectionOfGroups]) -> Void
  
  func sections(handler: @escaping Sections) {
    var sectionsUpdate = [SectionOfGroups]()
    
    if let userid = Auth.auth().currentUser?.uid {
      reference.observe(.value) { snapshot in
        var snaps = [DataSnapshot]()
        let snap1 = snapshot.childSnapshot(forPath: "system-default-value")
        snaps.append(snap1)
        if snapshot.childSnapshot(forPath: userid).exists() {
          let snap2 = snapshot.childSnapshot(forPath: userid)
          snaps.append(snap2)
        }
        for snap in snaps {
          let group = snap.value as! NSArray
          let id = group.mutableArrayValue(forKeyPath: "id") as! [Int]
          let name = group.mutableArrayValue(forKeyPath: "name") as! [String]
          let image = group.mutableArrayValue(forKeyPath: "image") as! [String?]
          let isEditable = group.mutableArrayValue(forKeyPath: "isEditable") as! [Bool]
          let brandCount = group.mutableArrayValue(forKeyPath: "brandCount") as! [Int]
          let system = group.mutableArrayValue(forKeyPath: "system") as! [Bool]
          
          for i in 0 ..< group.count {
            let sectGroup = SectionOfGroups(header: "Default Groups", items: [Group(id: id[i], name: name[i], image: image[i], isEditable: isEditable[i], brandCount: brandCount[i], system: system[i])])
            sectionsUpdate.append(sectGroup)
          }
        }
        handler(sectionsUpdate)
      }
    }
  }
  
  func source(_ collectionView: UICollectionView) -> RxCollectionViewSectionedReloadDataSource<SectionOfGroups> {
    viewController = GroupViewController()
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfGroups> (configureCell: {
      dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! GroupCollectionViewCell
      cell.label.text = item.name
      cell.group = item
      
      DispatchQueue.main.async {
        if let image = item.image {
          let imageRef = self.storageRef.reference(forURL: "gs://makeuplist-62209.appspot.com/images/\(image).jpg")
          imageRef.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
            if error != nil {
              if let errorCode = StorageErrorCode(rawValue: error!._code) {
                switch errorCode {
                case .downloadSizeExceeded:
                  self.viewController.showAlert(message: "Download size exceeded!")
                case .objectNotFound:
                  self.viewController.showAlert(message: "\(item.name) photo couldn't be found.")
                case .cancelled:
                  self.viewController.showAlert(message: "User has cancelled the operation")
                case .unauthenticated:
                  self.viewController.showAlert(message: "Unauthenticated download, please check.")
                default:
                  self.viewController.showAlert(message: "Unknown download error.")
                }
              }
            } else {
              let image = UIImage(data: data!)
              cell.imageView.image = image
            }
          })
        }
      }
      return cell
    })
    return dataSource
  }
  
  func openGroupAdd() {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = GroupCoordinator(rootViewController: vc)
    coordinator.goToGroupAdd(on: vc)
  }
  
  func openSideDetail(name: String) {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = GroupCoordinator(rootViewController: vc)
    if name == "Orientation" {
      coordinator.openOrientation(on: vc)
    } else if name == "About" {
      coordinator.openAbout(on: vc)
    } else if name == "Summary" {
      coordinator.openSummary(on: vc)
    } else if name == "Price Table" {
      coordinator.openPriceTable(on: vc)
    }
  }
  
  func openBrand(group: Group) {
    let vc = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    coordinator = GroupCoordinator(rootViewController: vc)
    coordinator.openBrand(on: vc, group: group)
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      let window = UIApplication.shared.keyWindow
      let vc = window?.rootViewController as! UINavigationController
      coordinator = GroupCoordinator(rootViewController: vc)
      coordinator.backToLogin(on: window!)
    } catch  {
      print("there is an error.")
    }
  }
}
