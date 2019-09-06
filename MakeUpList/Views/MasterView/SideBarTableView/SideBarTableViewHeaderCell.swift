import UIKit

class SideBarTableViewHeaderCell: UIView {
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "MakeUp List"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.adjustsFontForContentSizeCategory = true
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .lightGray
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    self.addSubview(nameLabel)
    
    nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
    nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
  }
}
