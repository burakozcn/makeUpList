import UIKit
import RxSwift

class LoginViewController: UIViewController {
  var viewModel: LoginViewModel!
  let disposeBag = DisposeBag()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 32)
    label.textColor = .red
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    label.text = "Make UP List!"
    return label
  }()
  
  let emailTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Email"
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.textContentType = UITextContentType.emailAddress
    textField.autocapitalizationType = UITextAutocapitalizationType.none
    return textField
  }()
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Password"
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.textContentType = UITextContentType.password
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .blue
    button.setTitle("Login", for: .normal)
    button.isEnabled = false
    return button
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .red
    button.setTitle("Sign Up!", for: .normal)
    return button
  }()
  
  init() {
    let interval2 = Date.timeIntervalSinceReferenceDate
    let f: Double = interval2 - AppDelegate.interval1
    let s = String(format: "%.7f", f)
    print("TIME = \(s)")
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    super.viewDidLoad()
    
    setupView()
    animateForm()
    animateButtons()
    
    let emailValid = emailTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let passValid = passwordTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let enableButton = Observable.combineLatest(emailValid, passValid) { (login, name) in
      return login && name
    }
    
    enableButton
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    loginButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.login(email: (self?.emailTextField.text)!, password: (self?.passwordTextField.text)!)
      }).disposed(by: disposeBag)
    
    signUpButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.openSignUp()
      }).disposed(by: disposeBag)
  }
  
  func setupView() {
    view.addSubview(titleLabel)
    view.addSubview(emailTextField)
    view.addSubview(passwordTextField)
    view.addSubview(loginButton)
    view.addSubview(signUpButton)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    titleLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: safeGuide.topAnchor, constant: (height * 0.21)).isActive = true
    
    emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: height * 0.09).isActive = true
    emailTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    emailTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: height * 0.04).isActive = true
    passwordTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    passwordTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    
    loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: height * 0.04).isActive = true
    loginButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    loginButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    loginButton.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    
    signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: height * 0.03).isActive = true
    signUpButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    signUpButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    signUpButton.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
  }
  
  func showAlert(message: String) {
    viewModel = LoginViewModel()
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
