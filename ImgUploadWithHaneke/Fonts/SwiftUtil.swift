//
//  SwiftUtil.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 3/7/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import Foundation
import UIKit


class SwiftUtil{
    
    class func getButtonBG() -> UIColor{
        return UIColorFromRGB(0x4d94ff)
    }
    
    class func getBackgroundColor() -> UIColor {
        return UIColorFromRGB(0x1a1a1a)
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}