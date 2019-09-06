import UIKit

let teamTableIdentifier = "TeamTable"

class TeamTableViewCell: UITableViewCell {
  
  @IBOutlet var cellImage: UIImageView!
  @IBOutlet weak var label: UILabel!
  
  override func awakeFromNib() {
    self.backgroundColor = .white
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
