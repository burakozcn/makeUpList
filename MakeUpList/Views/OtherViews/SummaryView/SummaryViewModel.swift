import UIKit
import RxSwift
import Firebase

class SummaryViewModel {
  let reference = Database.database().reference(withPath: "groups")
  typealias Groups = (_ sections: [Group]) -> Void
  
  func groups(handler: @escaping Groups) {
    var groupUpdate = [Group]()
    
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
            let group = Group(id: id[i], name: name[i], image: image[i], isEditable: isEditable[i], brandCount: brandCount[i], system: system[i])
            groupUpdate.append(group)
          }
        }
        handler(groupUpdate)
      }
    }
  }
  
  func totalCount(completion: @escaping (Int) -> ()) {
    var i = 0
    groups { group in
      i = group.reduce(0, { $0 + $1.brandCount })
      completion(i)
    }
  }
  
  func activeCount() -> [Group] {
    var array = [Group]()
    groups { group in
      array = group.filter { $0.brandCount > 0}
    }
    return array
  }
}
