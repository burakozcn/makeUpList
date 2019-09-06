import UIKit

class SummaryView: UIView {
  var totalItem: Float!
  var activeGroups: [Group]!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let chartColors = [
    UIColor(red: 1.0, green: 107/255, blue: 107/255, alpha: 1.0),
    UIColor(red: 155/255, green: 224/255, blue: 172/255, alpha: 1.0),
    UIColor(red: 136/255, green: 161/255, blue: 212/255, alpha: 1.0),
    UIColor(red: 1.0, green: 172/255, blue: 99/255, alpha: 1.0),
    UIColor(red: 135/255, green: 218/255, blue: 230/255, alpha: 1.0),
    UIColor(red: 250/255, green: 250/255, blue: 147/255, alpha: 1.0)]
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    let diameter = min(bounds.width, bounds.height)
    let margin:CGFloat = 20
    
    let circle = UIBezierPath(ovalIn:
      CGRect(x:0, y:0,
             width:diameter,
             height:diameter
        ).insetBy(dx: margin, dy: margin))
    
    let transform = CGAffineTransform(translationX: bounds.width/2 - diameter/2 ,y: 0)
    
    circle.apply(transform)
    
    context!.saveGState()
    
    context!.scaleBy(x: 1, y: 0.6)
    context!.translateBy(x: -20, y: -100)
    
    let shadowColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
    context!.setShadow(offset: CGSize(width: 10, height: 10), blur: 1, color: shadowColor.cgColor)
    
    context!.beginTransparencyLayer(auxiliaryInfo: nil)
    
    for (index, _) in activeGroups.enumerated() {
      
      let percent = CGFloat(Float(activeGroups[index].brandCount) / totalItem!)
      let angle = percent * 2 * .pi
      
      let slice = UIBezierPath()
      
      let radius = diameter / 2 - margin
      let centerPoint = center
      
      slice.move(to: centerPoint)
      slice.addLine(to: CGPoint(x:centerPoint.x + radius, y:centerPoint.y))
      slice.addArc(withCenter: centerPoint, radius:radius, startAngle: 0, endAngle: angle, clockwise: true)
      slice.close()
      
      chartColors[index].setFill()
      slice.fill()
      
      drawText(name: activeGroups[index].name, centerPoint: centerPoint, radius:radius, angle:angle)
      
      context!.translateBy(x: centerPoint.x, y: centerPoint.y)
      context!.rotate(by: angle)
      context!.translateBy(x: -centerPoint.x, y: -centerPoint.y)
    }
    circle.apply(CGAffineTransform(translationX: 22.5, y: 312.5))
    circle.stroke()
    
    context!.endTransparencyLayer()
    context!.restoreGState()
  }
  
  func drawText(name: String, centerPoint:CGPoint, radius:CGFloat, angle:CGFloat) {
    
    let context = UIGraphicsGetCurrentContext()
    
    context!.saveGState()
    
    context!.translateBy(x: centerPoint.x, y: centerPoint.y)
    context!.rotate(by: angle / 2)
    context!.translateBy(x: -centerPoint.x, y: -centerPoint.y)
    
    let font = UIFont(name: "HelveticaNeue-Bold", size: 18)!
    let attributes = [NSAttributedString.Key.font: font,
                      NSAttributedString.Key.foregroundColor: UIColor.black]
    
    
    let transform = context!.ctm
    let radians = atan2(transform.b, transform.a)
    if abs(radians) > CGFloat.pi / 2 && abs(radians) < 3 / 2 * CGFloat.pi {
      
      let textBounds = name.size(withAttributes: attributes)
      
      context!.saveGState()
      context!.rotate(by: CGFloat.pi)
      
      name.draw(at: CGPoint(x:-centerPoint.x - radius - textBounds.width - 10, y:-centerPoint.y), withAttributes:attributes)
      
      context!.restoreGState()
      
    } else {
      name.draw(at: CGPoint(x:centerPoint.x + radius + 10, y:centerPoint.y), withAttributes:attributes)
    }
    context!.restoreGState()
  }
}
