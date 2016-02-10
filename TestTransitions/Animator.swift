//
//  Animator.swift
//  TestTransitions
//
//  Created by Eugene Dorfman on 2/7/16.
//  Copyright © 2016 justadreamer. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ImageTransitionable,
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ImageTransitionable,
            let containerView = transitionContext.containerView()
            else {
                return
        }

        containerView.addSubview(toView)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        toVC.imageViewToTransition.hidden = true
        fromVC.imageViewToTransition.hidden = true
        
        let iv : UIImageView = UIImageView(image: fromVC.imageViewToTransition.image)
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        containerView.addSubview(iv)
        iv.frame = containerView.convertRect(fromVC.imageViewToTransition.frame, fromView: fromView)
        
        toView.alpha = 0
        UIView.animateWithDuration(self.transitionDuration(transitionContext),animations: { () -> Void in
            iv.frame = containerView.convertRect(toVC.imageViewToTransition.frame, fromView: toView)
            toView.alpha = 1.0
            print ("iv frame = \(iv.frame)")
        }, completion: { (finished: Bool) -> Void in
            let complete = !transitionContext.transitionWasCancelled()
            iv.removeFromSuperview()
            fromVC.imageViewToTransition.hidden = complete
            toVC.imageViewToTransition.hidden = !complete
            transitionContext.completeTransition(complete)

        })
    }

    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    func animationEnded(complete: Bool) {

        
        
    }

}
