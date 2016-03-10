//
//  Extensions.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 3/4/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
 
    func setImageColorForState(image: UIImage, color: UIColor, forState: UIControlState) {
        let temp = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        setImage(temp, forState: forState)
        tintColor = color
    }
}

extension UIView {
    func fadeIn(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay,
            usingSpringWithDamping: CGFloat(0.30),
            initialSpringVelocity: CGFloat(8.0),
            options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
                self.transform = CGAffineTransformIdentity
                self.transform = CGAffineTransformMakeScale(1.2, 1.2)

            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay,
            usingSpringWithDamping: CGFloat(0.30),
            initialSpringVelocity: CGFloat(8.0),
            options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
                self.transform = CGAffineTransformIdentity
                 self.transform = CGAffineTransformMakeScale(1.2, 1.2)

            }, completion: completion)
    }
}