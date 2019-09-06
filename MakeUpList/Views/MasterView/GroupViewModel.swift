import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfGroups: SectionModelType {
  typealias Item = Group
  
  var header: String
  var items: [Item]
  
  init(original: SectionOfGroups, items: [Item]) {
    self = original
    self.items = items
  }
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}
