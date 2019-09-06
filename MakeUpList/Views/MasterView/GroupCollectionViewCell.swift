import UIKit

let collectionIdentifier = "CollectionCell"

class GroupCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var label: UILabel!
  var group: Group!
  
  override func awakeFromNib() {
    self.backgroundColor = .white
    super.awakeFromNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame:frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
