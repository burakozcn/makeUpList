import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let toViewController: UIViewController
  var originFrame = CGRect.zero
  var present = true
  
  init(toViewController: UIViewController) {
    self.toViewController = toViewController
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    let newView = present ? toView : transitionContext.view(forKey: .from)!
    
    let initial = present ? originFrame : newView.frame
    let final = present ? newView.frame : originFrame
    
    let xScale = present ? initial.width / final.width : final.width / initial.width
    let yScale = present ? initial.height / final.height : final.height / initial.height
    
    let scale = CGAffineTransform(scaleX: xScale, y: yScale)
    
    if present {
      newView.transform = scale
      newView.center = CGPoint(x: initial.midX, y: initial.midY)
    }
    
    newView.layer.cornerRadius = present ? 20.0 / xScale : 0.0
    newView.clipsToBounds = true
    
    container.addSubview(toView)
    container.bringSubviewToFront(newView)

//    let controller = transitionContext.viewController(forKey: present ? .to : .from)
//
//    if present {
//      controller.containerView.alpha = 0.0
//    }
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   options: .transitionCurlDown,
                   animations: {
                    newView.layer.cornerRadius = self.present ? 0.0 : 20.0 / xScale
                    newView.transform = self.present ? .identity : scale
                    newView.center = CGPoint(x: final.midX, y: final.midY)
    },
                   completion: { _ in
                    transitionContext.completeTransition(true)
    })
  }
  
}
