import UIKit
import RxSwift

let sideCellIdentifier = "SideBarCell"

class SideBarTableViewController: UITableViewController {
  let disposeBag = DisposeBag()
  let rows = ["Orientation", "Summary", "Price Table", "About"]
  var viewModel: GroupViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.frame.size.width = UIScreen.main.bounds.width * 0.45
    
    self.tableView.rowHeight = 90
    self.tableView.register(UINib(nibName: "SideBarTableViewCell", bundle: nil), forCellReuseIdentifier: sideCellIdentifier)
    
    self.tableView.rx.itemSelected.asObservable()
      .subscribe(onNext: { index in
        self.viewModel = GroupViewModel()
        let name = self.rows[index.row]
        self.viewModel.openSideDetail(name: name)
      }).disposed(by: disposeBag)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SideBarTableViewCell = tableView.dequeueReusableCell(withIdentifier: sideCellIdentifier, for: indexPath) as! SideBarTableViewCell
    cell.label.text = NSLocalizedString(rows[indexPath.row].lowercased(), comment: rows[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = SideBarTableViewHeaderCell()
    return header
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }
}
