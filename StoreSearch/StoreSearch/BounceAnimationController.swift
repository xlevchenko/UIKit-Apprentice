//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Olexsii Levchenko on 9/19/22.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewController(forKey: .to),
           let toViwe = transitionContext.view(forKey: .to) {
            let containerView = transitionContext.containerView
            toViwe.frame = transitionContext.finalFrame(for: toViewController)
            containerView.addSubview(toViwe)
            toViwe.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic) {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.344) {
                    toViwe.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                    toViwe.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                    toViwe.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            } completion: { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
