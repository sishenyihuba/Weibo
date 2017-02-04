//
//  PicPickerCell.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/4.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPicBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var image : UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPicBtn.userInteractionEnabled = false
                deleteBtn.hidden = false
            } else {
                imageView.image = nil
                addPicBtn.userInteractionEnabled = true
                deleteBtn.hidden = true

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func picPickerDidTouch(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(picDidPickNoti, object: nil)
        
    }
    
    @IBAction func deletePicDidTouch(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(picDidDeleteNoti, object: imageView.image)

    }

}