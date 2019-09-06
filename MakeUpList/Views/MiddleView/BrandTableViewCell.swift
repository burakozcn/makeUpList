import UIKit

let tableCellIdentifier = "BrandTableCell"
class BrandTableViewCell: UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  var brand: Brand!
  
  override func awakeFromNib() {
    self.backgroundColor = .white
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
