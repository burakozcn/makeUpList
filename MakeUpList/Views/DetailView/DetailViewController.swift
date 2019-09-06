import UIKit

class DetailViewController: UIViewController {
  var viewModel: DetailViewModel!
  let brand: Brand
  var tableViewController: ShopTableViewController!
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Name"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = UIFont.systemFont(ofSize: 18)
    textField.textAlignment = .center
    textField.isUserInteractionEnabled = false
    return textField
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Price"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let priceTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = UIFont.systemFont(ofSize: 18)
    textField.textAlignment = .center
    textField.isUserInteractionEnabled = false
    return textField
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Description"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 18)
    textView.textAlignment = .center
    textView.isUserInteractionEnabled = false
    return textView
  }()
  
  let tableLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Available Shops"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  init(brand: Brand) {
    self.brand = brand
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .lightGray
    super.viewDidLoad()
    setupUI()
    
    nameTextField.text = brand.name
    priceTextField.text = String(format: "%.2f", brand.price)
    descriptionTextView.text = brand.feature
  }
  
  func setupUI() {
    tableViewController = ShopTableViewController()
    let tableView = tableViewController.tableView!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nameLabel)
    view.addSubview(nameTextField)
    view.addSubview(priceLabel)
    view.addSubview(priceTextField)
    view.addSubview(descriptionLabel)
    view.addSubview(descriptionTextView)
    view.addSubview(tableLabel)
    view.addSubview(tableView)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    nameLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.06).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: width * 0.05).isActive = true
    
    nameTextField.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.06).isActive = true
    nameTextField.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: height * 0.02).isActive = true
    priceLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    priceLabel.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    priceLabel.trailingAnchor.constraint(equalTo: priceTextField.leadingAnchor, constant: width * 0.05).isActive = true
    
    priceTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: height * 0.02).isActive = true
    priceTextField.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    priceTextField.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    
    descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: height * 0.02).isActive = true
    descriptionLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    descriptionLabel.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true

    descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: height * 0.01).isActive = true
    descriptionTextView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    descriptionTextView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    descriptionTextView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    tableLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: height * 0.02).isActive = true
    tableLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    tableLabel.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    
    tableView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor, constant: height * 0.01).isActive = true
    tableView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    tableView.heightAnchor.constraint(equalToConstant: height * 0.3).isActive = true
  }
}
