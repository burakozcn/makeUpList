import UIKit
import RxSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  static var interval1 = Date.timeIntervalSinceReferenceDate
  private var coordinator: AppCoordinator!
  private let disposeBag = DisposeBag()
  var helper: Helper!
  
  override init() {
    FirebaseApp.configure()
    Helper.defaultValues()
    Helper.shops()
    helper = Helper()
    helper.checkUser()
    helper = nil
  }
  
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    if #available(iOS 13.0, *) {
      window?.overrideUserInterfaceStyle = .light
    }
    
    coordinator = AppCoordinator(window: window!)
    coordinator.start()
      .subscribe()
      .disposed(by: disposeBag)
    
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    do {
      try Auth.auth().signOut()
    } catch (let error) {
      print (error.localizedDescription)
    }
  }
}

