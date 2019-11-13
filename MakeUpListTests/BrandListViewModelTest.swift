import XCTest
import Firebase

@testable import MakeUpList
class BrandListViewModelTest: XCTestCase {
  var brandVM: BrandViewModel!
  var loginVM: LoginViewModel!
  var ref: DatabaseReference!
  
  override func setUp() {
    FirebaseApp.configure()
    login()
    ref = Database.database().reference()
  }
  
  override func tearDown() {
    brandVM = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
  //  MARK: Tests
  
  func testBrandSections() {
    let exp = expectation(description: "Brand Sections Test") 
    
    let brands = ["First Bunny Brand", "Mock Brand"]
    
    getGroup { group in
      self.brandVM = BrandViewModel(group: group)
      
      self.brandVM.sections { sections in
        for i in 0...1 {
          if !(sections[i].items[0].name == brands[i]) {
            XCTFail()
          }
        }
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 20) { error in
      if let _error = error {
        XCTFail(_error.localizedDescription)
      }
    }
  }
  
  //  MARK: Helper Methods
  
  private func getGroup(completion: @escaping (Group) -> Void) {
    let exp = expectation(description: "Get Group")
    let userId = Auth.auth().currentUser?.uid
    
    ref.child("groups").child(userId!).child("0").observe(.value) { snapshot in
      let id = snapshot.childSnapshot(forPath: "id").value as! Int
      let name = snapshot.childSnapshot(forPath: "name").value as! String
      let image = snapshot.childSnapshot(forPath: "image").value as! String
      let isEditable = snapshot.childSnapshot(forPath: "isEditable").value as! Bool
      let brandCount = snapshot.childSnapshot(forPath: "brandCount").value as! Int
      let system = snapshot.childSnapshot(forPath: "system").value as! Bool
      
      let group = Group(id: id, name: name, image: image, isEditable: isEditable, brandCount: brandCount, system: system)
      completion(group)
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 30) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
  private func login() {
    loginVM = LoginViewModel()
    let exp = expectation(description: "Login Successful")
    
    loginVM.login(email: "mockuserim@gmail.com", password: "nomh1234") { (result, error) in
      if error == nil {
        XCTAssert(true)
      } else {
        XCTFail()
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 35) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
  private func getBrand(completion: @escaping (Bool, Brand) -> Void) {
    let userId = Auth.auth().currentUser?.uid
    getGroup { group in
      self.brandVM = BrandViewModel(group: group)
      self.ref.child("brands").child(userId!).child("MyDefault").child("0").observe(.value) { snapshot in
        let id = snapshot.childSnapshot(forPath: "id").value as! Int
        let name = snapshot.childSnapshot(forPath: "name").value as! String
        let price = snapshot.childSnapshot(forPath: "price").value as! Double
        let feature = snapshot.childSnapshot(forPath: "feature").value as! String
        let available = snapshot.childSnapshot(forPath: "available").value as! Bool
        let brand = Brand(id: id, name: name, price: price, feature: feature, available: available)
        completion(available, brand)
      }
    }
  }
}
