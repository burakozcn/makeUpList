import XCTest
import Firebase

@testable import MakeUpList
class GroupAddViewModelTest: XCTestCase {
  var groupAddVM: GroupAddViewModel!
  var loginVM: LoginViewModel!
  var ref: DatabaseReference!
  var storageRef: Storage!
  
  override func setUp() {
    groupAddVM = GroupAddViewModel()
    FirebaseApp.configure()
    login()
    ref = Database.database().reference(withPath: "groups")
    storageRef = Storage.storage()
    groupAdd()
  }
  
  override func tearDown() {
    groupDelete()
    groupAddVM = nil
    ref = nil
    storageRef = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
//  MARK: Tests
  
  func testNameSave() {
    let name = "MockData"
    let userId = "5kBbU1cSKVRZM9waJX9Q1kAAwiD2"
    
    let exp = expectation(description: "Name Save Setting")
    ref.child(userId).observe(.value) { snapshot in
      let count = snapshot.childrenCount
      let snap = snapshot.childSnapshot(forPath: "\(count - 1)")
      let group = snap.value as! NSDictionary
      let checkname = group.value(forKey: "name") as! String
      if (checkname == name) {
        XCTAssertTrue(true)
      } else {
        XCTFail()
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 20) {error in
      if let _error = error {
        XCTFail("Failed due to error == \(_error.localizedDescription)")
      }
      XCTAssertTrue(true)
    }
  }
  
  func testImageSave() {
    let name = "MockData"
    let userId = "5kBbU1cSKVRZM9waJX9Q1kAAwiD2"
    let imageName = userId + name
    
    let exp = expectation(description: "Image Save Setting")
    let imageRef = storageRef.reference(forURL: "gs://makeuplist-62209.appspot.com/images/\(imageName).jpg")
    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
      if error != nil {
        XCTFail()
      } else {
        XCTAssert(true)
      }
      exp.fulfill()
    }
    waitForExpectations(timeout: 20) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
//   MARK: Helper Methods
  
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
  
  private func groupAdd() {
    let exp = expectation(description: "Save Group")
    
    groupAddVM.saveGroup(groupName: "MockData", imageView: UIImageView(image: #imageLiteral(resourceName: "Bunny-4"))) { error in
      if error == nil {
        XCTAssert(true)
      } else {
        XCTFail()
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 40) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
  private func groupDelete() {
    let exp = expectation(description: "Delete Mock Group")
    
    groupAddVM.deleteGroup { error in
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
}
