//
//  UserAccount.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/12.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class UserAccount: NSObject {

    //MARK: - 属性
    var access_token:String?
    
    var expires_in:NSTimeInterval = 0.0 {
        didSet {
             expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    var uid:String?
    
    var expires_date:NSDate?
    
    var avatar_large:String?
    
    var screen_name:String?
    
    //MARK: - 构造方法
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    
    
    //MARK: - description
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token","expires_date","uid","avatar_large","screen_name"]).description
    }
}
