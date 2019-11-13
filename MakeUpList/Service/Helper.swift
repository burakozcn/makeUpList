import Firebase
import UIKit

struct Helper {
  static func defaultValues() {
    let child = Database.database().reference(withPath: "groups").child("system-default-value")
    
    var constantValues = [[String : Any]]()
    
    constantValues.append(["id": 0, "name": "Eyes", "image": "Eyes", "isEditable": false, "brandCount": 0, "system": true])
    constantValues.append(["id": 1, "name": "Nails", "image": "Nails", "isEditable": false, "brandCount": 0, "system": true])
    constantValues.append(["id": 2, "name": "Lips", "image": "Lips", "isEditable": false, "brandCount": 0, "system": true])
    constantValues.append(["id": 3, "name": "Skin", "image": "Skin", "isEditable": false, "brandCount": 0, "system": true])
    constantValues.append(["id": 4, "name": "Health & Hygiene", "image": "Health-Hygiene", "isEditable": false, "brandCount": 0, "system": true])
    constantValues.append(["id": 5, "name": "Personal Care", "image": "PersonalCare", "isEditable": false, "brandCount": 0, "system": true])
    
    child.observe(.value, with: { snapshot in
      if !snapshot.exists() {
        child.setValue(constantValues)
      } else {
        print("Default values have already written")
      }
    })
  }
  
  static func shops() {
    let child = Database.database().reference(withPath: "shops")
    child.observe(.value) { snapshot in
      if !snapshot.exists() {
        var values = [[String : Any]]()
        
        let shop1 = ["shops": ["Istanbul", "London", "New York", "Seattle", "Los Angeles", "Berlin", "Kiev"]]
        let shop2 = ["shops": ["Istanbul", "New York", "Berlin", "Frankfurt", "Paris", "Baku", "Moscow"]]
        let shop3 = ["shops": ["London", "New York", "Los Angeles", "Milano", "Rome", "Madrid", "Stockholm", "Moscow", "Hong Kong", "St. Petersburg"]]
        let shop4 = ["shops": ["Istanbul", "London", "Tokyo", "Sydney", "Los Angeles", "Hamburg", "Kiev", "Rio de Janerio", "Seul", "St. Petersburg"]]
        let shop5 = ["shops": ["Istanbul", "Frankfurt", "Sydney", "Seattle", "Stockholm", "Barcelona", "Prague"]]
        let shop6 = ["shops": ["New York", "Los Angeles", "Seattle", "Rome", "Barcelona", "Prague", "Kiev", "Rio de Janerio", "Hong Kong", "Tokyo", "Berlin", "Moscow"]]
        let shop7 = ["shops": ["Istanbul", "New York", "Berlin", "Paris", "Baku", "Madrid", "Barcelona", "Sydney", "Hamburg", "Seul", "Frankfurt"]]
        
        values.append(shop1)
        values.append(shop2)
        values.append(shop3)
        values.append(shop4)
        values.append(shop5)
        values.append(shop6)
        values.append(shop7)
        
        child.setValue(values)
      }
    }
  }
  
  func checkUser() {
    print("USER ID === \(String(describing: Auth.auth().currentUser?.uid))")
  }
  
  func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
  }
}
