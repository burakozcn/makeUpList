import XCTest
import Firebase

@testable import MakeUpList
class GroupListViewModelTest: XCTestCase {
  var groupVM: GroupViewModel!
  var loginVM: LoginViewModel!
  
  override func setUp() {
    groupVM = GroupViewModel()
    FirebaseApp.configure()
    login()
  }
  
  override func tearDown() {
    signOut()
    groupVM = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
//  MARK: Tests
  
  func testSystemSections() {
    let exp = expectation(description: "System Sections Test")
    
    let systemArray = ["Eyes", "Nails", "Lips", "Skin", "Health & Hygiene", "Personal Care"]
    
    groupVM.sections { sections in
      for i in 0...5 {
        if !(sections[0].items[i].name == systemArray[i]) {
          XCTFail()
        }
      }
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 15) { (error) in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
      XCTAssertTrue(true)
    }
  }
  
  func testUserSections() {
    let exp = expectation(description: "User Sections Test")
    let systemArray = ["MyDefault", "Flower13"]
    groupVM.sections { sections in
      for i in 6...7 {
        if !(sections[0].items[i].name == systemArray[i - 6]) {
          XCTFail()
        }
      }
      exp.fulfill()
    }
    waitForExpectations(timeout: 30) { (error) in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
      XCTAssertTrue(true)
    }
  }
  
  func testSignout() {
    var res = false
    let exp = expectation(description: "Sign Out Test")
    
    groupVM.signOut { (result, error) in
      res = result
      exp.fulfill()
    }
    waitForExpectations(timeout: 20) { (error) in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
      XCTAssertTrue(res)
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
    
    waitForExpectations(timeout: 20) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
  
  private func signOut() {
    let exp = expectation(description: "Sign Out Test")
    
    groupVM.signOut { (result, error) in
      if Auth.auth().currentUser?.uid != nil {
        XCTFail()
      } else {
        XCTAssert(true)
      }
      exp.fulfill()
    }
    waitForExpectations(timeout: 20, handler: nil)
  }
}
