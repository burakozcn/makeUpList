import UIKit
import RxSwift

class SecondViewController: UIViewController, UIViewControllerTransitioningDelegate {
  let disposeBag = DisposeBag()
  var viewModel: OrientationViewModel!
  var transition: Animator!
  var back = true
  
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
    textView.text = "So we decided to make an application about make-up things. You can add your groups, brands, took record of it."
    textView.isUserInteractionEnabled = false
    return textView
  }()
  
  let backLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 25)
    label.text = " <= BACK "
    return label
  }()
  
  let nextLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 25)
    label.text = " NEXT =>"
    return label
  }()
  
  let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  let nextImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  let startButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .red
    button.setTitle("Get Started", for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    view.backgroundColor = .blue
    super.viewDidLoad()
    setupUI()
    backImageView.image = #imageLiteral(resourceName: "First")
    nextImageView.image = #imageLiteral(resourceName: "Third")
    viewModel = OrientationViewModel()
    
    backImageView.isUserInteractionEnabled = true
    let backGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backTapGesture(_:)))
    backImageView.addGestureRecognizer(backGestureRecognizer)
    
    nextImageView.isUserInteractionEnabled = true
    let nextGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextTapGesture(_:)))
    nextImageView.addGestureRecognizer(nextGestureRecognizer)
    
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
    view.addSubview(backImageView)
    view.addSubview(nextImageView)
    view.addSubview(nextLabel)
    view.addSubview(startButton)
    
    let safeGuide = view.safeAreaLayoutGuide
    let readGuide = view.readableContentGuide
    let width = view.bounds.size.width
    let height = view.bounds.size.height
    
    label.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: height * 0.04).isActive = true
    label.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    label.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.1).isActive = true
    label.heightAnchor.constraint(equalToConstant: height * 0.05).isActive = true
    
    textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: height * 0.03).isActive = true
    textView.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    textView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    textView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    backLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: height * 0.02).isActive = true
    backLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    backLabel.trailingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    backLabel.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    backImageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: height * 0.02).isActive = true
    backImageView.leadingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    backImageView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    backImageView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    nextLabel.topAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: height * 0.02).isActive = true
    nextLabel.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor).isActive = true
    nextLabel.trailingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    nextLabel.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    nextImageView.topAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: height * 0.02).isActive = true
    nextImageView.leadingAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    nextImageView.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor).isActive = true
    nextImageView.heightAnchor.constraint(equalToConstant: height * 0.2).isActive = true
    
    startButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
    startButton.leadingAnchor.constraint(equalTo: readGuide.leadingAnchor, constant: width * 0.1).isActive = true
    startButton.trailingAnchor.constraint(equalTo: readGuide.trailingAnchor, constant: -width * 0.1).isActive = true
    startButton.centerXAnchor.constraint(equalTo: readGuide.centerXAnchor).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: height * 0.03).isActive = true
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = Animator(toViewController: presenting)
    transition.present = true
    if back {
      transition.originFrame = backImageView.convert(backImageView.frame, to: nil)
      backImageView.isHidden = true
    }
    transition.originFrame = nextImageView.convert(nextImageView.frame, to: nil)
    nextImageView.isHidden = true
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = Animator(toViewController: dismissed)
    transition.present = false
    return transition
  }
  
  @objc
  func backTapGesture(_ sender: UITapGestureRecognizer) {
    back = true
    viewModel = OrientationViewModel()
    viewModel.goToFirst(viewController: self)
  }
  
  @objc
  func nextTapGesture(_ sender: UITapGestureRecognizer) {
    back = false
    viewModel = OrientationViewModel()
    viewModel.goToThird(viewController: self)
  }
}
