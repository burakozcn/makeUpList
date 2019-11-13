import UIKit
import RxSwift
import RxCocoa
import Firebase

class GroupViewController: UICollectionViewController {
  
  var viewModel: GroupViewModel!
  let disposeBag = DisposeBag()
  let reference = Database.database().reference(withPath: "groups")
  var menuIsOpen = false
  var leadConstraint: NSLayoutConstraint!
  var sideTable: SideBarTableViewController!
  
  let sideBarView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .purple
    return view
  }()
  
  let toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    return toolBar
  }()
  
  let leftBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
  let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  let toolBarButtonRight = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
  
  let flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.24)
    flowLayout.minimumInteritemSpacing = 2
    flowLayout.minimumLineSpacing = 5
    flowLayout.scrollDirection = .vertical
    flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    flowLayout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width,
                                     height: (UIScreen.main.bounds.height) * 0.1)
    return flowLayout
  }()
  
  init() {
    super.init(collectionViewLayout: flowLayout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    self.view.backgroundColor = .clear
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = leftBarButton
    navigationItem.rightBarButtonItem = rightBarButton
    
    self.title = "MakeUp Groups"
    
    setupView()
    self.collectionView.register(UINib(nibName:"GroupCollectionViewCell", bundle:Bundle.main), forCellWithReuseIdentifier: collectionIdentifier)
    self.collectionView.register(UINib(nibName: "GroupCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterId")
    self.collectionView.reloadData()
    self.collectionView.backgroundColor = .lightGray
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(flexSpace)
    items.append(toolBarButtonRight)
    toolBar.setItems(items, animated: true)
    
    viewModel = GroupViewModel()
    
    viewModel.sections { sections in
      self.collectionView.delegate = nil
      self.collectionView.dataSource = nil
      Observable.just(sections)
        .bind(to: self.collectionView.rx.items(dataSource: self.viewModel.source(self.collectionView)))
        .disposed(by: self.disposeBag)
    }
    
    leftBarButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.sideBarViewSetup()
      }).disposed(by: disposeBag)
    
    toolBarButtonRight.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.signOut{ _,_ in
        }
      }).disposed(by: disposeBag)
    
    rightBarButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.openGroupAdd()
        self?.navigationFadeOut()
      }).disposed(by: disposeBag)
    
    self.collectionView.rx.itemSelected
      .asObservable()
      .subscribe(onNext: { [weak self] (index) in
        let cell = self?.collectionView.cellForItem(at: index) as? GroupCollectionViewCell
        let group = cell?.group
        self?.viewModel.openBrand(group: group!)
      }).disposed(by: disposeBag)
  }
  
  func setupView() {
    view.addSubview(sideBarView)
    view.addSubview(toolBar)
    
    let safeGuide = view.safeAreaLayoutGuide
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    sideBarView.heightAnchor.constraint(equalTo: safeGuide.heightAnchor, multiplier: 0.94).isActive = true
    sideBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: height * 0.09).isActive = true
    sideBarView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
    sideBarView.widthAnchor.constraint(equalToConstant: width * 0.45).isActive = true
    leadConstraint = sideBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -(width * 0.45))
    leadConstraint.isActive = true
    
    sideTableSetup()
        
    toolBar.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor).isActive = true
    toolBar.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
    toolBar.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
  }
  
  func sideBarViewSetup() {
    let width = UIScreen.main.bounds.width
    menuIsOpen = !menuIsOpen
    
    if (menuIsOpen) {
      self.title = ""
    }
    view.layoutIfNeeded()
    
    UIView.animate(
      withDuration: 0.57,
      delay: 0.1,
      options: .curveEaseIn,
      animations: {
        self.leadConstraint.constant = self.menuIsOpen ? 0 : -(width * 0.45)
        self.view.layoutIfNeeded()
    },
      completion: { [weak self] _ in
        if !(self?.menuIsOpen)! {
          self?.title = "MakeUp Groups"
        }
      }
    )
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
  
  func sideTableSetup() {
    sideTable = SideBarTableViewController()
    let sideTableView = sideTable.tableView!
    sideTableView.translatesAutoresizingMaskIntoConstraints = false
    sideBarView.addSubview(sideTableView)
    
    sideTableView.widthAnchor.constraint(equalTo: sideBarView.widthAnchor, multiplier: 1).isActive = true
    sideTableView.heightAnchor.constraint(equalTo: sideBarView.heightAnchor, multiplier: 1).isActive = true
    sideTableView.topAnchor.constraint(equalTo: sideBarView.topAnchor).isActive = true
    sideTableView.bottomAnchor.constraint(equalTo: sideBarView.bottomAnchor).isActive = true
    sideTableView.leadingAnchor.constraint(equalTo: sideBarView.leadingAnchor).isActive = true
    sideTableView.trailingAnchor.constraint(equalTo: sideBarView.trailingAnchor).isActive = true
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: NSLocalizedString("error", comment: "Error"), message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK"), style: UIAlertAction.Style.default, handler: nil))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}


