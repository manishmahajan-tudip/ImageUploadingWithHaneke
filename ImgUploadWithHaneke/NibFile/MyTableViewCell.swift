//
//  MyTableViewCell.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 3/2/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate {
//    func didSelectedImage(image: UIImage)
    func didSelectedImage(image: UIImage)
//    func commentButtonTapped(cell: MyTableViewCell)
    func likeButtonTapped(cell: MyTableViewCell)
}

class MyTableViewCell: UITableViewCell {

    
 
   
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var listedImage: UIImageView!
    
    var listedImageDelegate : ListViewControllerDelegate!
//    var commentButtonDelegate: ListViewControllerDelegate?
    var likeButtondelegate : ListViewControllerDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("listedImageTapped:"))
        listedImage.userInteractionEnabled = true
        listedImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func likeButtonAction(sender: AnyObject) {
        likeButtondelegate?.likeButtonTapped(self)
    }
    
    func listedImageTapped(img : AnyObject){
//        listedImageDelegate?.didSelectedImage(listedImage.image!)
        listedImageDelegate.didSelectedImage(listedImage.image!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithModel(model:MyModel){
        if model.is_liked_by_me == true {
            let image = UIImage(named: "newlike.png")
            likeButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "newunlike.png")
            likeButton.setImage(image, forState: .Normal)
        }
        listedImage.image = model.profileImage
    }
}
