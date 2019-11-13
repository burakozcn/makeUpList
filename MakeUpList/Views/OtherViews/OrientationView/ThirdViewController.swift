import UIKit
import RxSwift

class ThirdViewController: UIViewController {
  let disposeBag = DisposeBag()
  var viewModel: OrientationViewModel!
  var transition: Animator!
  
  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 26)
    label.text = "MakeUP List"
    label.textColor = .red
    label.textAlignment = .center
    return label
  }()
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.systemFont(ofSize: 18)
    textView.text = NSLocalizedString("thirdInfo", comment: "It is easy to use, you can understand easily. So, we don't explain too much. Enjoy!")
    textView.isUserInteractionEnabled = false
    return textView
  }()
  
  let backLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 25)
    label.text = NSLocalizedString("back", comment: " <= BACK ")
    return label
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = #imageLiteral(resourceName: "Third")
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  let startButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .blue
    button.setTitle(NSLocalizedString("start", comment: "Get Started"), for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    setupUI()
    imageView.image = #imageLiteral(resourceName: "Second")
    viewModel = OrientationViewModel()
    
    imageView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
    imageView.addGestureRecognizer(gestureRecognizer)
    
    startButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [unowned self] _ in
        self.viewModel.goToGroupView()
      }).disposed(by: disposeBag)
  }
  
  func setupUI() {
    view.addSubview(label)
    view.addSubview(textView)
    view.addSubview(backLabel)
    view.addSubview(imageView)
    view.addSubview(startButton)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = view.bounds.size.width
    let height = view.bounds.size.height
    
    label.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.1).isActive = true
    label.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    label.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.1).isActive = true
    label.heightAnchor.constraint(equalToConstant: height * 0.07).isActive = true
    
    textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: height * 0.05).isActive = true
    textView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    textView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    textView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    backLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: height * 0.04).isActive = true
    backLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    backLabel.trailingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    backLabel.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: height * 0.04).isActive = true
    imageView.leadingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    startButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
    startButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.2).isActive = true
    startButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.2).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: height * 0.04).isActive = true
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = Animator(toViewController: presenting)
    transition.originFrame = imageView.convert(imageView.frame, to: nil)
    transition.present = true
    imageView.isHidden = true
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = Animator(toViewController: dismissed)
    transition.present = false
    return transition
  }
  
  @objc
  func tapGesture(_ sender: UITapGestureRecognizer) {
    viewModel = OrientationViewModel()
    viewModel.goToSecond(viewController: self)
  }
}
