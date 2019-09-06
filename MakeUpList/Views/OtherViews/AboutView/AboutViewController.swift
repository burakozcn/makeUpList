import UIKit
import RxSwift

class AboutViewController: UIViewController {
  let disposeBag = DisposeBag()
  var viewModel: AboutViewModel!
  var teamTableView: TeamTableViewController!
  var helper: Helper!
  
  let aboutCompanyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "About Our Company"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let aboutCompanyTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 18)
    textView.textAlignment = .left
    textView.isUserInteractionEnabled = false
    textView.text = "Our company founded in 2017, we are working hardly for making much more better mobile applications. \n We have made a lot of application."
    return textView
  }()
  
  let ourTeamLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Our Team"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.isUserInteractionEnabled = false
    return label
  }()
  
  let contactLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Contact Information"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()
  
  let contactTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 18)
    textView.textAlignment = .left
    textView.isUserInteractionEnabled = false
    textView.text = "Istanbul Technical University Ayazağa Campus, \n Technopark Maslak, \n Sarıyer - Istanbul"
    return textView
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  override func viewDidLoad() {
    view.backgroundColor = .yellow
    super.viewDidLoad()
    teamTableView = TeamTableViewController()
    setupUI()
    
    teamTableView.tableView.rx.itemSelected
      .asObservable()
      .subscribe(onNext: { [weak self] index in
        self?.showItem(image: UIImage(named: "Bunny-\(index.row + 1).png"))
      }).disposed(by: disposeBag)
  }
  
  func setupUI() {
    let tableView = teamTableView.tableView!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    view.addSubview(aboutCompanyLabel)
    view.addSubview(aboutCompanyTextView)
    view.addSubview(ourTeamLabel)
    view.addSubview(contactLabel)
    view.addSubview(contactTextView)
    
    let width = view.bounds.width
    let height = view.bounds.height
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    
    aboutCompanyLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.05).isActive = true
    aboutCompanyLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.2).isActive = true
    aboutCompanyLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.2)).isActive = true
    aboutCompanyLabel.heightAnchor.constraint(equalToConstant: height * 0.03).isActive = true
    
    aboutCompanyTextView.topAnchor.constraint(equalTo: aboutCompanyLabel.bottomAnchor, constant: height * 0.01).isActive = true
    aboutCompanyTextView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    aboutCompanyTextView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    aboutCompanyTextView.heightAnchor.constraint(equalToConstant: height * 0.15).isActive = true
    
    ourTeamLabel.topAnchor.constraint(equalTo: aboutCompanyTextView.bottomAnchor, constant: height * 0.02).isActive = true
    ourTeamLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.2).isActive = true
    ourTeamLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.2)).isActive = true
    ourTeamLabel.heightAnchor.constraint(equalToConstant: height * 0.03).isActive = true
    
    tableView.topAnchor.constraint(equalTo: ourTeamLabel.bottomAnchor, constant: height * 0.02).isActive = true
    tableView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    tableView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    tableView.heightAnchor.constraint(equalToConstant: height * 0.25).isActive = true
    
    contactLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: height * 0.02).isActive = true
    contactLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.2).isActive = true
    contactLabel.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.2)).isActive = true
    contactLabel.heightAnchor.constraint(equalToConstant: height * 0.03).isActive = true
    
    contactTextView.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: height * 0.01).isActive = true
    contactTextView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    contactTextView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -(width * 0.1)).isActive = true
    contactTextView.heightAnchor.constraint(equalToConstant: height * 0.12).isActive = true
  }
  
  func showItem(image: UIImage?) {
    helper = Helper()
    view.addSubview(imageView)
    imageView.image = image
    let width = view.bounds.size.width
    let height = view.bounds.size.height
    
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: width * 0.5).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: height * 0.4).isActive = true
    
    UIView.animate(withDuration: 0.71,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    self.imageView.alpha = 1.0
    },
                   completion: nil)
    
    Helper().delay(seconds: 1.8) {
      UIView.transition(with: self.imageView,
                        duration: 1.89,
                        options: .curveLinear,
                        animations: {
                          self.imageView.alpha = 0.0
      },
                        completion: { _ in
                          self.imageView.removeFromSuperview()
      })
    }
  }
}
