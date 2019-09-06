import UIKit
import RxSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  static var interval1 = Date.timeIntervalSinceReferenceDate
  private var coordinator: AppCoordinator!
  private let disposeBag = DisposeBag()
  
  override init() {
    FirebaseApp.configure()
    Helper.defaultValues()
    Helper.shops()
  }
  
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    coordinator = AppCoordinator(window: window!)
    coordinator.start()
      .subscribe()
      .disposed(by: disposeBag)
    
    return true
  }
}

