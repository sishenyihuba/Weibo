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
    
    var pic_urls : [[String:String]]?
    
    var retweeted_status : Status?
    
    init(dict: [String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        guard let user = dict["user"] as? [String:AnyObject] else {
            return
        }
        self.user = User(dict: user)
        
        guard let retweeted_status = dict["retweeted_status"] as? [String : AnyObject] else {
            return
        }
        
        self.retweeted_status = Status(dict: retweeted_status)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
