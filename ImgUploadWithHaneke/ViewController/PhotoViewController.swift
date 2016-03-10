//
//  PhotoViewController.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 3/3/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController : UIViewController{
    
    var image:UIImage = UIImage()
    @IBOutlet weak var largeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SwiftUtil.getBackgroundColor()
        largeImageView.image = image

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
