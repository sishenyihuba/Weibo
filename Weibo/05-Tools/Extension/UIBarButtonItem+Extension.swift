//
//  UIBarButtonItem+Extension.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/10.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    convenience init(imageName:String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Selected)
        btn.sizeToFit()
        
        self.customView = btn
    }
}