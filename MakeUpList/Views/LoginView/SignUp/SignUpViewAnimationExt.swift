import UIKit

extension SignUpViewController {
  
  func animateForm() {
    let move = CASpringAnimation(keyPath: AnimationKeyPath.positionX)
    
    move.damping = 22.1
    move.mass = 5.7
    move.stiffness = 73.6
    move.initialVelocity = 1.0
    
    move.duration = move.settlingDuration
    
    move.fromValue = -view.bounds.size.width * 0.7
    move.toValue = view.bounds.size.width * 0.5
    
    move.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    move.fillMode = .backwards
    
    move.setValue(nameTextField.layer, forKey: "layer")
    nameTextField.layer.add(move, forKey: "nil")
    
    move.setValue(surnameTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.6
    surnameTextField.layer.add(move, forKey: "nil")
    
    move.setValue(usernameTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.3
    usernameTextField.layer.add(move, forKey: "nil")
    
    move.setValue(mailTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.2
    mailTextField.layer.add(move, forKey: "nil")
    
    move.setValue(passwordTextField.layer, forKey: "layer")
    move.beginTime = CACurrentMediaTime() + 0.4
    passwordTextField.layer.add(move, forKey: "nil")
  }
  
  func animateButtonLabel() {
    let groupAnimation = CAAnimationGroup()
    groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    groupAnimation.beginTime = CACurrentMediaTime() + 0.18
    groupAnimation.duration = 0.93
    groupAnimation.fillMode = .backwards
    
    let scale = CABasicAnimation(keyPath: AnimationKeyPath.transformScale)
    scale.fromValue = 2.3
    scale.toValue = 1.0
    
    let rotate = CABasicAnimation(keyPath: AnimationKeyPath.transformRotation)
    rotate.fromValue = CGFloat.pi * 0.73
    rotate.toValue = 0
    
    let opacity = CABasicAnimation(keyPath: AnimationKeyPath.opacity)
    opacity.fromValue = 0.0
    opacity.toValue = 1.0
    
    groupAnimation.animations = [scale, rotate, opacity]
    signUpButton.layer.add(groupAnimation, forKey: "nil")
    signUpLabel.layer.add(groupAnimation, forKey: "nil")
  }
  
  func animateInfo() {
    let group = CAAnimationGroup()
    group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    group.beginTime = CACurrentMediaTime() + 0.66
    group.duration = 9.89
    group.fillMode = .backwards
    
    let fromLeft = CABasicAnimation(keyPath: AnimationKeyPath.positionX)
    fromLeft.fromValue = infoLabel.layer.position.x + view.frame.size.width
    fromLeft.toValue = view.frame.size.width / 2
    
    let alpha = CABasicAnimation(keyPath: AnimationKeyPath.opacity)
    alpha.fromValue = 0.1
    alpha.toValue = 1.0
    
    group.animations = [fromLeft, alpha]
    infoLabel.layer.add(group, forKey: "nil")
  }
}
