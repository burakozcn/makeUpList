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
    var items = [Group]()
    var snaps = [DataSnapshot]()
    
    systemSnaps { [weak self] snap1 in
      snaps.append(snap1)
      self?.userSnaps { snap2 in
        if let snap = snap2 {
          snaps.append(snap)
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
            let item = Group(id: id[i], name: name[i], image: image[i], isEditable: isEditable[i], brandCount: brandCount[i], system: system[i])
            items.append(item)
          }
        }
        let sectionsUpdate = SectionOfGroups(header: "Default Groups", items: items)
        handler([sectionsUpdate])
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
          imageRef.getData(maxSize: 1 * 1024 * 1024, completion: { [weak self] data, error in
            if error != nil {
              self?.showError(error: error)
            } else {
              let image = UIImage(data: data!)
              cell.imageView.image = image
            }
          })
        }
      }
      return cell
    }, configureSupplementaryView: {
      dataSource, collectionView, kind, indexPath in
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterId", for: indexPath) as! GroupCollectionReusableView
      return view
    })
    return dataSource
  }
  
  private func systemSnaps(completion:@escaping (DataSnapshot) -> Void) {
    Database.database().reference(withPath: "groups").observe(.value) { snapshot in
      let snap = snapshot.childSnapshot(forPath: "system-default-value")
      completion(snap)
    }
  }
  
  private func userSnaps(completion:@escaping (DataSnapshot?) -> Void) {
    if let userId = Auth.auth().currentUser?.uid {
      reference.observe(.value) { snapshot in
        if snapshot.childSnapshot(forPath: userId).exists() {
          let snap = snapshot.childSnapshot(forPath: userId)
          completion(snap)
        } else {
          completion(nil)
        }
      }
    }
  }
  
  private func showError(error: Error?) {
    if let errorCode = StorageErrorCode(rawValue: error!._code) {
      switch errorCode {
      case .downloadSizeExceeded:
        self.viewController.showAlert(message: NSLocalizedString("downloadsizeerror", comment: "Download size exceeded!"))
      case .objectNotFound:
        self.viewController.showAlert(message: NSLocalizedString("searchphotoerror", comment: "Searched photo couldn't be found."))
      case .cancelled:
        self.viewController.showAlert(message: NSLocalizedString("operationcancelled", comment: "User has cancelled the operation"))
      case .unauthenticated:
        self.viewController.showAlert(message: NSLocalizedString("unauthenticatederror", comment: "Unauthenticated download, please check."))
      default:
        self.viewController.showAlert(message: "Unknown download error.")
      }
    }
  }
  
  func openGroupAdd() {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = GroupCoordinator(rootViewController: vc)
    coordinator.goToGroupAdd(on: vc)
  }
  
  func openSideDetail(name: String) {
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
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
    let vc = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
    coordinator = GroupCoordinator(rootViewController: vc)
    coordinator.openBrand(on: vc, group: group)
  }
  
  func signOut(completion: @escaping (Bool, Error?) -> Void) {
    do {
      try Auth.auth().signOut()
      let window = UIApplication.shared.windows.first
      let vc = window?.rootViewController as! UINavigationController
      coordinator = GroupCoordinator(rootViewController: vc)
      coordinator.backToLogin(on: window!)
      completion(true, nil)
    } catch (let error) {
      print("there is an error.")
      completion(false, error)
    }
  }
}


