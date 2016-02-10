//
//  NavigationControllerDelegate.swift
//  TestTransitions
//
//  Created by Eugene Dorfman on 2/7/16.
//  Copyright © 2016 justadreamer. All rights reserved.
//

import UIKit

@objc class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate, UIViewControllerInteractiveTransitioning {
    var interactive : Bool = false
    var iv : UIImageView?
    var center : CGPoint = CGPoint.zero
    var toView : UIView?
    
    var animator: UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
    
    var transitionContext : UIViewControllerContextTransitioning?

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactive {
            return self
        }
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animator
    }

    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ImageTransitionable,
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ImageTransitionable,
            let containerView = transitionContext.containerView()
            else {
                return
        }
        toView.alpha = 0
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
        center = iv.center
        self.iv = iv
        self.toView = toView

    }
    
    func pan(translation:CGPoint) {
        if let iv = self.iv {
            let p = iv.center
            iv.center = CGPointMake(p.x+translation.x, p.y+translation.y)
            let d = CGPointMake(center.x-iv.center.x,center.y-iv.center.y)
            toView?.alpha = sqrt(d.x*d.x+d.y*d.y)/200.0
        }
    }
    
    func cancelInteractiveTransition() {
        animateCompletion(false)
    }
    
    func finishInteractiveTransition() {
        animateCompletion(true)
    }
    
    func animateCompletion(complete: Bool) {
        guard
            let iv = self.iv,
            let transitionContext = self.transitionContext,
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ImageTransitionable,
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ImageTransitionable,
            let containerView = transitionContext.containerView()
            else {
                return
        }
        
        UIView.animateWithDuration(0.5,animations: { () -> Void in
            if (complete) {
                iv.frame = containerView.convertRect(toVC.imageViewToTransition.frame, fromView: toView)
                toView.alpha = 1.0
            } else {
                iv.frame = containerView.convertRect(fromVC.imageViewToTransition.frame, fromView: fromView)
                toView.alpha = 0
            }
        }, completion: { (finished: Bool) -> Void in
                iv.removeFromSuperview()
                fromVC.imageViewToTransition.hidden = complete
                toVC.imageViewToTransition.hidden = !complete
                if (complete) {
                    transitionContext.finishInteractiveTransition()
                } else {
                    transitionContext.cancelInteractiveTransition()
                }
                transitionContext.completeTransition(complete)
                self.transitionContext = nil
                self.toView = nil 
        })
    }
}
