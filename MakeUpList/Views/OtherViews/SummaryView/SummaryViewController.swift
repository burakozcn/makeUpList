import UIKit

class SummaryViewController: UIViewController {
  var viewModel: SummaryViewModel!
  var summaryView: SummaryView!
  
  override func viewDidLoad() {
    view.backgroundColor = .blue
    super.viewDidLoad()
    viewModel = SummaryViewModel()
    viewModel.groups { group in
      self.summaryView = SummaryView()
      self.summaryView.totalItem = Float(group.reduce(0, { $0 + $1.brandCount }))
      self.summaryView.activeGroups = group.filter { $0.brandCount > 0 }
      self.setupUI()
    }
  }
  
  func setupUI() {
    summaryView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(summaryView)
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    
    summaryView.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
    summaryView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
    summaryView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    summaryView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
  }
}
