import UIKit

class PriceTableViewController: UIViewController {
  var viewModel: PriceTableViewModel!
  
  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "It is under construction"
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(label)
    
    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.size.height * 0.2).isActive = true
    label.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
  }
}
