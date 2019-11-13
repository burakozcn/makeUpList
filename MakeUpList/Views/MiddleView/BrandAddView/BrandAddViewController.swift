import UIKit
import RxSwift

class BrandAddViewController: UIViewController {
  var viewModel: BrandAddViewModel!
  let disposeBag = DisposeBag()
  let group: Group
  let new: Bool
  let brand: Brand?
  
  init(group: Group, brand: Brand?, new: Bool) {
    self.group = group
    self.brand = brand
    self.new = new
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("name", comment: "Name")
    textField.textAlignment = .center
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  let priceTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = NSLocalizedString("price", comment: "Price")
    textField.textAlignment = .center
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  let featureTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 16)
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1
    textView.text = NSLocalizedString("description", comment: "Description")
    textView.textColor = .lightGray
    return textView
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString("submit", comment: "Submit"), for: .normal)
    button.backgroundColor = .white
    button.setTitleColor(.blue, for: .normal)
    button.isEnabled = false
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(NSLocalizedString("cancel", comment: "Cancel"), for: .normal)
    button.backgroundColor = .white
    button.setTitleColor(.red, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupUI()
    viewModel = BrandAddViewModel(group: group, new: new)
    
    if let brand = brand {
      nameTextField.text = brand.name
      priceTextField.text = String(format: "%.2f", brand.price)
      featureTextView.text = brand.feature
    }
    
    nameTextField.rx.text
      .orEmpty
      .map { $0.count > 0 }
      .share(replay: 1)
      .bind(to: submitButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    submitButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        if (self?.new)! {
          self?.viewModel.saveBrand(name: (self?.nameTextField.text)!, price: Double(self?.priceTextField.text ?? "0")!, feature: (self?.featureTextView.text)!, brand: (self?.brand)) { _ in }
        } else {
          self?.viewModel.editBrand(name: (self?.nameTextField.text)!, price: Double(self?.priceTextField.text ?? "0")!, feature: (self?.featureTextView.text)!, brand: (self?.brand)) { _ in }
        }
      }).disposed(by: disposeBag)
    
    cancelButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.backToBrand()
        self?.navigationFadeIn()
      }).disposed(by: disposeBag)
  }
  
  func setupUI() {
    view.addSubview(nameTextField)
    view.addSubview(priceTextField)
    view.addSubview(featureTextView)
    view.addSubview(submitButton)
    view.addSubview(cancelButton)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    nameTextField.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.2).isActive = true
    nameTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    nameTextField.heightAnchor.constraint(equalToConstant: height * 0.06).isActive = true
    
    priceTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: height * 0.02).isActive = true
    priceTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.25).isActive = true
    priceTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.25)).isActive = true
    priceTextField.heightAnchor.constraint(equalToConstant: height * 0.06).isActive = true
    
    featureTextView.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: height * 0.02).isActive = true
    featureTextView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    featureTextView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    featureTextView.heightAnchor.constraint(equalToConstant: height * 0.25).isActive = true
    
    submitButton.topAnchor.constraint(equalTo: featureTextView.bottomAnchor, constant: height * 0.04).isActive = true
    submitButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.25).isActive = true
    submitButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.25)).isActive = true
    submitButton.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    
    cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: height * 0.02).isActive = true
    cancelButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.25).isActive = true
    cancelButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.25)).isActive = true
    cancelButton.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    
    featureTextView.rx.didBeginEditing
      .subscribe(onNext: { [weak self] _ in
        self?.featureTextView.text = nil
        self?.featureTextView.textColor = .black
      }).disposed(by: disposeBag)
    
    featureTextView.rx.didEndEditing
      .subscribe(onNext: { [weak self] _ in
        self?.featureTextView.text = NSLocalizedString("description", comment: "Description")
        self?.featureTextView.textColor = .lightGray
      }).disposed(by: disposeBag)
  }
  
  func showAlert(new: Bool) {
    let message: String
    viewModel = BrandAddViewModel(group: group, new: new)
    if new {
      message = NSLocalizedString("successbrand", comment: "Brand has been saved successfully!")
    } else {
      message = NSLocalizedString("update", comment: "Brand has been updated successfully!")
    }
    let alert = UIAlertController(title: NSLocalizedString("success", comment: "Success"), message: message, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) in
      self.viewModel.backToBrand()
    }))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  func navigationFadeIn() {
    UIView.animate(withDuration: 0.51,
                   delay: 0.11,
                   options: .curveEaseIn,
                   animations: {
                    self.navigationController?.navigationBar.alpha = 1.0
    },
                   completion: nil)
  }
}
