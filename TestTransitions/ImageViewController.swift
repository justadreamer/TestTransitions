//
//  ImageViewController.swift
//  TestTransitions
//
//  Created by Eugene Dorfman on 2/6/16.
//  Copyright © 2016 justadreamer. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, ImageTransitionable {
    @IBOutlet weak var imageView: UIImageView!
    var imageViewToTransition : UIImageView {
        get {
            return imageView
        }
    }
    
    func showImageView (show: Bool) {
        self.imageView.hidden = !show
    }
}
