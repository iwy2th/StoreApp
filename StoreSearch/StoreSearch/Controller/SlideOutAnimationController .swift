//
//  SlideOutAnimationController .swift
//  StoreSearch
//
//  Created by Iwy2th on 04/07/2023.
//

import UIKit
class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if let formView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
      let containerView = transitionContext.containerView
      let time = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: time) {
        formView.center.y -= containerView.bounds.size.height
        formView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      } completion: { finished in
        transitionContext.completeTransition(finished)
      }
    }
  }
}
