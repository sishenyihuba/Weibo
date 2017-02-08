//
//  UIButton-Extension.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/8.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(color : UIColor ,title : String , cornerR : CGFloat , fontSize : CGFloat) {
        self.init()
        backgroundColor = color
        self.setTitle(title, forState: .Normal)
        self.layer.cornerRadius = cornerR
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}
