//
//  VisitorView.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    @IBOutlet weak var rotateImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    class func createVisitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }
    
    
    func setupVisitorViewInfo(imageName:String,title:String) {
        iconImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        rotateImageView.hidden = true
    }
    
    
    func addRotateAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.duration = 5
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        rotateImageView.layer.addAnimation(anim, forKey: nil)
    }
 
}
