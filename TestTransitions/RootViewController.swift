//
//  ViewController.swift
//  TestTransitions
//
//  Created by Eugene Dorfman on 2/6/16.
//  Copyright © 2016 justadreamer. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, ImageTransitionable {
    var navigationDelegate : NavigationControllerDelegate?
    var prevTranslation: CGPoint?

    @IBOutlet weak var imageView: UIImageView!
    var imageViewToTransition : UIImageView {
        get {
            return imageView
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationDelegate = NavigationControllerDelegate()
        self.navigationController?.delegate = self.navigationDelegate
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.navigationController?.view.addGestureRecognizer(panGestureRecognizer)
        self.navigationController?.navigationBar.hidden = true
    }

    @IBAction func unwind(segue: UIStoryboardSegue) {
    
    }
    
    func pan(recognizer:UIPanGestureRecognizer) {
        guard let navigationDelegate = self.navigationDelegate else { return }
        if (recognizer.state == .Began) {
            if (self.navigationController?.viewControllers.count == 2) {
                navigationDelegate.interactive = true
                self.navigationController?.topViewController?.performSegueWithIdentifier("exit",  sender: nil)
            }
            self.prevTranslation = CGPoint.zero
        } else if (recognizer.state == .Changed) {
            let translation = recognizer.translationInView(view)
            if let prev = self.prevTranslation {
                navigationDelegate.pan(CGPointMake(translation.x-prev.x, translation.y - prev.y))
                self.prevTranslation = translation
            }
        } else if (recognizer.state == .Ended) {
            let pt = recognizer.translationInView(view)
            if (sqrt(pt.x*pt.x+pt.y*pt.y) > 150.0) {
                print("finished")
                navigationDelegate.finishInteractiveTransition()
            } else {
                print("cancelled")
                navigationDelegate.cancelInteractiveTransition()
            }
            navigationDelegate.interactive = false;
        }
    }
}
