import XCTest
import Firebase

@testable import MakeUpList

class LoginViewModelTest: XCTestCase {
  var loginVM: LoginViewModel!
  
  override func setUp() {
    loginVM = LoginViewModel()
    FirebaseApp.configure()
  }
  
  override func tearDown() {
    loginVM = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
//  MARK: Helper Methods
  
  func testLoginInvalid() {
    let email = "mocknotuser"
    let pass = "nomh88"
    let exp = expectation(description: "Login Invalid")
    loginVM.login(email: email, password: pass) { (result, error) in
      if let _error = error {
        XCTAssertEqual(_error._code, 17008)
        exp.fulfill()
      } else {
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testLoginWrongPass() {
    
    let email = "mockuserim@gmail.com"
    let pass = "nomh99"
    let exp = expectation(description: "Login Wrong Pass")
    loginVM.login(email: email, password: pass) { (result, error) in
      if let _error = error {
        XCTAssertEqual(_error._code, 17009)
        exp.fulfill()
      } else {
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testLoginSuccess() {
    var logRes = false
    
    let email = "mockuserim@gmail.com"
    let pass = "nomh1234"
    let exp = expectation(description: "Login Successful")
    loginVM.login(email: email, password: pass) { (result, error) in
      logRes = result
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 10) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
      XCTAssertTrue(logRes)
    }
  }
}
