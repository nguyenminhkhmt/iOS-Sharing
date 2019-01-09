//
//  UIView+Blink.swift
//  TestMapper
//
//  Created by Minh Nguyen on 1/9/19.
//  Copyright © 2019 SlideIn Inc. All rights reserved.
//

import UIKit

extension UIView {
  private struct AssociatedKeys {
    static var weakAnimation = "AssociatedKeys.animation"
  }
  
  fileprivate var weakAnimation: UIViewPropertyAnimator? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.weakAnimation) as? UIViewPropertyAnimator
    }
    set(newValue) {
      let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
      objc_setAssociatedObject(self, &AssociatedKeys.weakAnimation, newValue, policy)
    }
  }
  
  func blink() {
    weakAnimation = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: [.allowUserInteraction, .curveEaseInOut], animations: { [weak self] in
      self?.alpha = 0.1
    }) { [weak self] (_) in
      self?.alpha = 1.0
      if UIApplication.shared.applicationState == .active {
        self?.blink()
      }
    }
  }
  
  func unblink() {
    weakAnimation?.stopAnimation(false)
  }
  
  func pause() {
    weakAnimation?.pauseAnimation()
  }
  
  func resume() {
    if let weakAnimation = weakAnimation, weakAnimation.state == .active {
      weakAnimation.startAnimation(afterDelay: 0.1)
    } else {
      blink()
    }
  }
}
