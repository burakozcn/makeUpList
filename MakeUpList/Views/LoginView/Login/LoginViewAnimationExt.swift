import UIKit

extension LoginViewController {
  
  func animateForm() {
    let move = CABasicAnimation(keyPath: AnimationKeyPath.positionX)
    
    move.duration = 1.3
    
    move.fromValue = -view.bounds.size.width * 0.5
    move.toValue = view.bounds.size.width * 0.5
    
    move.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    move.fillMode = CAMediaTimingFillMode.backwards
    
    move.setValue(titleLabel.layer, forKey: "layer")
    titleLabel.layer.add(move, forKey: nil)
    
    move.setValue(emailTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.5
    emailTextField.layer.add(move, forKey: nil)
    
    move.setValue(passwordTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.3
    passwordTextField.layer.add(move, forKey: nil)
  }
  
  func animateButtons() {
    let groupAnimation = CAAnimationGroup()
    groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    groupAnimation.beginTime = CACurrentMediaTime() + 0.1
    groupAnimation.duration = 0.7
    groupAnimation.fillMode = .backwards
    
    let scale = CABasicAnimation(keyPath: AnimationKeyPath.transformScale)
    scale.fromValue = 2.8
    scale.toValue = 1.0
    
    let rotate = CABasicAnimation(keyPath: AnimationKeyPath.transformRotation)
    rotate.fromValue = CGFloat.pi / 3
    rotate.toValue = 0
    
    let alpha = CABasicAnimation(keyPath: AnimationKeyPath.opacity)
    alpha.fromValue = 0.3
    alpha.toValue = 1.0
    
    groupAnimation.animations = [scale, rotate, alpha]
    loginButton.layer.add(groupAnimation, forKey: "nil")
    signUpButton.layer.add(groupAnimation, forKey: "nil")
  }
}
