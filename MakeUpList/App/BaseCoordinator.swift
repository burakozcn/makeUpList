import RxSwift

class BaseCoordinator<ResultType> {
  
  typealias CoordinatorType = ResultType
  let disposeBag = DisposeBag()
  
  private let identifier = UUID()
  private var childCoordinators = [UUID : Any]()
  
  private func store<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = coordinator
  }
  
  private func free<T>(coordinator: BaseCoordinator<T>) {
    childCoordinators[coordinator.identifier] = nil
  }
  
  @discardableResult
  func coordinate<T>(coordinator: BaseCoordinator<T>) -> Observable<T> {
    store(coordinator: coordinator)
    return coordinator.start()
      .do(onNext: { [weak self] _ in
        self?.free(coordinator: coordinator)
      })
  }
  
  func start() -> Observable<ResultType> {
    fatalError("Start method should be implemented.")
  }
}
