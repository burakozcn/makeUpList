import XCTest
import Firebase

@testable import MakeUpList
class SignUpViewModelTest: XCTestCase {
  var signUpVM: SignUpViewModel!
  var loginVM: LoginViewModel!
  
  override func setUp() {
    signUpVM = SignUpViewModel()
    FirebaseApp.configure()
  }
  
  override func tearDown() {
    signUpVM = nil
    let app = FirebaseApp.app()
    app?.delete({ _ in
    })
  }
  
//  MARK: Tests
  
  func testSignUpInvalid() {
    let name = "Mr Mock"
    let surname = "User"
    let username = "mrmockuser"
    let email = "mockuserim"
    let pass = "mock88"
    
    let exp = expectation(description: "Sign Up Invalid")
    signUpVM.signUp(name: name, surname: surname, username: username, email: email, password: pass) { (result, error) in
      if let _error = error {
        XCTAssertEqual(_error._code, 17008)
        exp.fulfill()
      } else {
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testSignUpWeak() {
    let name = "Mr Mock"
    let surname = "User"
    let username = "mrmockuser"
    let email = "mockuser@gmail.com"
    let pass = "1234"
    
    let exp = expectation(description: "Sign Up Weak Password")
    signUpVM.signUp(name: name, surname: surname, username: username, email: email, password: pass) { (result, error) in
      if let _error = error {
        XCTAssertEqual(_error._code, 17026)
        exp.fulfill()
      } else {
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testSignUpInUse() {
    let name = "Mr Mock"
    let surname = "User"
    let username = "mrmockuser"
    let email = "mockuserim@gmail.com"
    let pass = "nomh1234"
    
    let exp = expectation(description: "Sign Up Email In Use")
    signUpVM.signUp(name: name, surname: surname, username: username, email: email, password: pass) { (result, error) in
      if let _error = error {
        XCTAssertEqual(_error._code, 17007)
        exp.fulfill()
      } else {
        XCTFail()
      }
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testSignUpUsernameExists() {
    let name = "Mr Mock"
    let surname = "User"
    let username = "mockUser"
    let email = "mockuserim@gmail.com"
    let pass = "nomh1234"
    
    let exp = expectation(description: "Sign Up Username Exists")
    signUpVM.signUp(name: name, surname: surname, username: username, email: email, password: pass) { (result, error) in
      XCTAssertEqual(result, false)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 10)
  }
  
  func testSignUpSuccess() {
    var logRes = false
    
    let name = "Mr Mock"
    let surname = "User"
    let username = "signUpMockUser"
    let email = "mockusersignup@gmail.com"
    let pass = "nomh9787"
    
    let exp = expectation(description: "Sign Up Username Exists")
    signUpVM.signUp(name: name, surname: surname, username: username, email: email, password: pass) { (result, error) in
      logRes = result
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 20) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
      XCTAssertTrue(logRes)
    }
    deleteMockUser()
  }
  
//  MARK: Helper Methods
  
  private func deleteMockUser() {
    login()
    let exp = expectation(description: "Delete User")
    loginVM = LoginViewModel()
    
    loginVM.deleteUser { error in
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
      XCTAssert(true)
    }
  }
  
  private func login() {
    loginVM = LoginViewModel()
    let exp = expectation(description: "Login Successful")
    
    loginVM.login(email: "mockusersignup@gmail.com", password: "nomh9787") { (result, error) in
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
}
