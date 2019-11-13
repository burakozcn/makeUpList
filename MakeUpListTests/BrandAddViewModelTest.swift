import XCTest
import Firebase

@testable import MakeUpList
class BrandAddViewModelTest: XCTestCase {
  var brandAddVM: BrandAddViewModel!
  var loginVM: LoginViewModel!
  var ref: DatabaseReference!
  
  override func setUp() {
    FirebaseApp.configure()
    login()
    ref = Database.database().reference()
    brandAdd()
  }
  
  override func tearDown() {
//    brandDelete()
    brandAddVM = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
  //  MARK: Tests
  
  func testBrandSave() {
    let name = "Mock Brand"
    let userId = Auth.auth().currentUser?.uid
    
    let exp = expectation(description: "Brand Save Test")
    ref.child("brands").child(userId!).child("MyDefault").child("1").observe(.value) { snapshot in
      let checkname = snapshot.childSnapshot(forPath: "name").value as! String
      if (checkname == name) {
        XCTAssertTrue(true)
      } else {
        XCTFail()
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 20) { error in
      if let _error = error {
        XCTFail("Failed due to error == \(_error.localizedDescription)")
      } else {
        XCTAssert(true)
      }
    }
  }
  
  //  MARK: Helper Methods
  
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
    
    waitForExpectations(timeout: 30) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
  private func brandAdd() {
    
    getGroup { group in
      self.brandAddVM = BrandAddViewModel(group: group)
      self.brandAddVM.saveBrand(name: "Mock Brand", price: 1.1, feature: "Mock Brand", brand: nil) { error in
        if error == nil {
          XCTAssert(true)
        } else {
          XCTFail()
        }
      }
    }
  }
  
  private func brandDelete() {
    let exp = expectation(description: "Delete Mock Brand Name")
    
    getGroup { group in
      self.brandAddVM = BrandAddViewModel(group: group)
      self.brandAddVM.deleteBrand { error in
        if error == nil {
          XCTAssert(true)
        } else {
          XCTFail()
        }
        exp.fulfill()
      }
    }
    
    waitForExpectations(timeout: 20) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      } else {
        XCTAssert(true)
      }
    }
  }
  
  private func getGroup(completion: @escaping (Group) -> Void) {
    let exp = expectation(description: "Get Group")
    
    ref.child("groups").child("5kBbU1cSKVRZM9waJX9Q1kAAwiD2").child("0").observe(.value) { snapshot in
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
}
