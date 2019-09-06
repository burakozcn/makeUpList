import UIKit
import RxSwift
import Firebase

class ShopTableViewController: UITableViewController {
  let disposeBag = DisposeBag()
  typealias Rows = (_ rows: [String]) -> Void
  
  func values(handler: @escaping Rows) {
    let number = Int.random(in: 0 ..< 7)
    let reference = Database.database().reference(withPath: "shops")
    var rows = [String]()
    
    reference.observe(.value) { snapshot in
      let array = snapshot.childSnapshot(forPath: "\(number)").childSnapshot(forPath: "shops")
      for i in 0..<Int(array.childrenCount) {
        let row = array.childSnapshot(forPath: "\(i)").value as! String
        rows.append(row)
      }
      handler(rows)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UINib(nibName: "ShopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: shopCellIdentifier)
  
    values { rows in
      self.tableView.delegate = nil
      self.tableView.dataSource = nil
      Observable.of(rows)
        .bind(to: self.tableView.rx.items(cellIdentifier: shopCellIdentifier, cellType: ShopTableViewCell.self)) {
          (row, element, cell) in
          self.setupCell(row: row, element: element, cell: cell)
        }.disposed(by: self.disposeBag)
    }
  }
  
  func setupCell(row: Int, element: String, cell: ShopTableViewCell) {
    
    Observable.of(element)
      .bind(to: cell.label.rx.text)
      .disposed(by: disposeBag)
  }
}
