import UIKit
import RxSwift

class SignUpViewController: UIViewController {
  var viewModel: SignUpViewModel!
  let disposeBag = DisposeBag()
  
  let signUpLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .red
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    label.text = NSLocalizedString("signup", comment: "Sign Up")
    return label
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("name", comment: "Name")
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    return textField
  }()
  
  let surnameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("surname", comment: "Surname")
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    return textField
  }()
  
  let usernameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("username", comment: "Username")
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.autocapitalizationType = UITextAutocapitalizationType.none
    return textField
  }()
  
  let mailTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Email"
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.autocapitalizationType = UITextAutocapitalizationType.none
    return textField
  }()
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("pass", comment: "Password")
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .red
    button.setTitle(NSLocalizedString("signup", comment: "Sign Up"), for: .normal)
    button.isEnabled = false
    return button
  }()
  
  let infoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.italicSystemFont(ofSize: 14)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.text = NSLocalizedString("fill", comment: "Please fill all fields.")
    return label
  }()
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white
    super.viewDidLoad()
    
    setupView()
    animateForm()
    animateButtonLabel()
    animateInfo()
    
    let nameValid = nameTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let surnameValid = surnameTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let usernameValid = usernameTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0}
      .share(replay: 1)
    
    let mailValid = mailTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let passwordValid = passwordTextField.rx
      .text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
    
    let enableButton = Observable.combineLatest(nameValid, surnameValid, usernameValid, mailValid, passwordValid) { (name, surname, username, mail, password) in
      return name && surname && username && mail && password
    }
    
    enableButton
      .bind(to: signUpButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    signUpButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] in
        self?.viewModel.signUp(name: (self?.nameTextField.text)!, surname: (self?.surnameTextField.text)!, username: (self?.usernameTextField.text)!, email: (self?.mailTextField.text)!, password: (self?.passwordTextField.text)!, completion: {_,_ in
        })
      }).disposed(by: disposeBag)
  }
  
  func setupView() {
    view.addSubview(signUpLabel)
    view.addSubview(nameTextField)
    view.addSubview(surnameTextField)
    view.addSubview(usernameTextField)
    view.addSubview(mailTextField)
    view.addSubview(passwordTextField)
    view.addSubview(signUpButton)
    view.addSubview(infoLabel)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    signUpLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.1).isActive = true
    signUpLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    signUpLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    signUpLabel.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    signUpLabel.heightAnchor.constraint(equalToConstant: height * 0.09).isActive = true
    
    nameTextField.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: height * 0.08).isActive = true
    nameTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    nameTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    nameTextField.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: height * 0.05).isActive = true
    surnameTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    surnameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    surnameTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    surnameTextField.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    usernameTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: height * 0.05).isActive = true
    usernameTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    usernameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    usernameTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    usernameTextField.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    mailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: height * 0.05).isActive = true
    mailTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    mailTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    mailTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    mailTextField.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: height * 0.05).isActive = true
    passwordTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    passwordTextField.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    passwordTextField.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: height * 0.06).isActive = true
    signUpButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    signUpButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    signUpButton.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    signUpButton.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
    
    infoLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: height * 0.01).isActive = true
    infoLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.2).isActive = true
    infoLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.2)).isActive = true
    infoLabel.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
  }
  
  func showAlert(success: Bool, message: String) {
    viewModel = SignUpViewModel()
    let alert = UIAlertController(title: success ? NSLocalizedString("success", comment: "Success") : NSLocalizedString("error", comment: "Error"), message: message, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
      if success {
        self.viewModel.backtoLogin()
      }
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
