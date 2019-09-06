import UIKit

class TeamTableViewController: UITableViewController {
  
  let bunnies = ["Bunny-1", "Bunny-2", "Bunny-3", "Bunny-4"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UINib(nibName: "TeamTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: tableCellIdentifier)
    self.tableView.rowHeight = 84
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bunnies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! TeamTableViewCell
    cell.label.text = bunnies[indexPath.row]
    cell.cellImage.image = UIImage(named: "\(bunnies[indexPath.row]).png")
    return cell
  }
}
