//
//  User.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/25.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class User: NSObject {
    var screen_name:String?
    var profile_image_url:String?
    var verified_type:Int = -1 
    var mbrank :Int = 0 
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
