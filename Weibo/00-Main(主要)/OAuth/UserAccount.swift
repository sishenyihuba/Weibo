//
//  UserAccount.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/12.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {

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
    
    //MARK: -  nsCoding
    required  init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
}
