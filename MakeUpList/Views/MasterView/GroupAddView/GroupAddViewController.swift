import UIKit
import RxSwift

class GroupAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  let disposeBag = DisposeBag()
  var viewModel: GroupAddViewModel!
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .gray
    imageView.image = #imageLiteral(resourceName: "Bunny1")
    return imageView
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.borderStyle = .roundedRect
    textField.placeholder = "Group Name"
    return textField
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.setTitle("Submit", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.isEnabled = false
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.red, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
    setupView()
    
    imageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
    imageView.addGestureRecognizer(gestureRecognizer)
    
    nameTextField.rx.text
      .orEmpty
      .map { $0.count > 0}
      .share(replay: 1)
      .bind(to: submitButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    submitButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.saveGroup(groupName: (self?.nameTextField.text)!, imageView: self?.imageView)
      }).disposed(by: disposeBag)
    
    cancelButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.openGroupView()
        self?.navigationFadeIn()
      }).disposed(by: disposeBag)
  }
  
  func setupView() {
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    view.addSubview(imageView)
    view.addSubview(nameTextField)
    view.addSubview(submitButton)
    view.addSubview(cancelButton)
    
    imageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.2).isActive = true
    imageView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.3).isActive = true
    imageView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.3)).isActive = true
    imageView.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.25).isActive = true
    
    nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: height * 0.1).isActive = true
    nameTextField.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    nameTextField.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.08).isActive = true
    
    submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: height * 0.05).isActive = true
    submitButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.15).isActive = true
    submitButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.15)).isActive = true
    submitButton.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
    
    cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: height * 0.05).isActive = true
    cancelButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.15).isActive = true
    cancelButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.15)).isActive = true
    cancelButton.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.06).isActive = true
  }
  
  func showAlert() {
    viewModel = GroupAddViewModel()
    let alert = UIAlertController(title: "Success", message: "Saved successfully.", preferredStyle: .actionSheet)
    let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      self?.viewModel.openGroupView()
    }
    alert.addAction(action)
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  func navigationFadeIn() {
    UIView.animate(withDuration: 0.59,
                   delay: 0.08,
                   options: .curveEaseIn,
                   animations: {
                    self.navigationController?.navigationBar.alpha = 1.0
    },
                   completion: nil)
  }
  
  @objc func tapGesture(_ sender: UITapGestureRecognizer) {
    viewModel = GroupAddViewModel()
    viewModel.openGallery(viewController: self)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imageView.image = image
    } else {
      print("Error")
    }
    self.dismiss(animated: true, completion: nil)
  }
}
