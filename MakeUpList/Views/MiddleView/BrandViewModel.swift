import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfBrands: SectionModelType {
  typealias Item = Brand
  
  var header: String
  var items: [Item]
  
  init(original: SectionOfBrands, items: [Item]) {
    self = original
    self.items = items
  }
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}
