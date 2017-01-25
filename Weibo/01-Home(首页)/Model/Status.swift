//
//  Status.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/25.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class Status: NSObject {

    var created_at:String? 
    
    var mid:Int = 0
    
    var text:String?
    
    var source:String?
 
    var user : User?
    
    
    init(dict: [String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        guard let user = dict["user"] as? [String:AnyObject] else {
            return
        }
        self.user = User(dict: user)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
