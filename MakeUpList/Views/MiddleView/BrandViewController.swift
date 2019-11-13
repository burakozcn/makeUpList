import UIKit
import RxSwift

class BrandViewController: UITableViewController {
  let disposeBag = DisposeBag()
  var viewModel: BrandViewModel!
  let group: Group
  
  let leftBarButton = UIBarButtonItem(title: "<", style: .done, target: nil, action: nil)
  let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  
  init(group: Group) {
    self.group = group
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = leftBarButton
    navigationItem.rightBarButtonItem = rightBarButton
    
    self.title = NSLocalizedString("brandtitle", comment: "Brands")
    self.tableView.register(UINib(nibName: "BrandTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: tableCellIdentifier)
    
    viewModel = BrandViewModel(group: group)
    viewModel.sections { sections in
      self.tableView.delegate = nil
      self.tableView.dataSource = nil
      Observable.just(sections)
        .bind(to: self.tableView.rx.items(dataSource: self.viewModel.source(self.tableView)))
        .disposed(by: self.disposeBag)
      }
    
    leftBarButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.backToGroupView()
      }).disposed(by: disposeBag)
    
    rightBarButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.goToBrandAdd(brand: nil, new: true)
        self?.navigationFadeOut()
      }).disposed(by: disposeBag)
    
    self.tableView.rx.itemSelected
      .asObservable()
      .subscribe(onNext: { [weak self] index in
        let cell = self?.tableView.cellForRow(at: index) as! BrandTableViewCell
        let available = cell.brand.available
        self?.viewModel = BrandViewModel(group: (self?.group)!)
        let alert = UIAlertController(title: NSLocalizedString("multiple", comment: "Multiple Choice"), message: NSLocalizedString("choose", comment: "Choose One of Action"), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("edit", comment: "Edit"), style: .default, handler: { action in
          self?.viewModel.goToBrandAdd(brand: cell.brand, new: false)
        }))
        alert.addAction(UIAlertAction(title: available ? NSLocalizedString("unavailable", comment: "Make Unavailable") : NSLocalizedString("available", comment: "Make Available"), style: .default, handler: { action in
          self?.viewModel.changeAvailable(brand: cell.brand) {_ in }
        }))
        if available {
          alert.addAction(UIAlertAction(title: NSLocalizedString("detail", comment: "Go to Detail"), style: .default, handler: { action in
            self?.viewModel.goToDetail(brand: cell.brand)
          }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .destructive, handler: { action in
          alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    }
  
  func navigationFadeOut() {
    UIView.animate(withDuration: 0.61,
                   delay: 0.05,
                   options: .curveLinear,
                   animations: {
                    self.navigationController?.navigationBar.alpha = 0.0
    },
                   completion: nil)
  }
}
