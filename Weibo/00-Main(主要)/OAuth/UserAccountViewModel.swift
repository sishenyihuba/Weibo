//
//  UserAccountViewModel.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/16.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class UserAccountViewModel  {

    static var sharedInstance :UserAccountViewModel = UserAccountViewModel()
    
    //MARK: - 计算属性
    var accountPath:String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
         return  (path as NSString).stringByAppendingPathComponent("account.plist")
    }
    
    var isLogin:Bool {
        if let account = account {
            if let expires_date = account.expires_date {
                return expires_date.compare(NSDate()) == .OrderedDescending
            }
        }
        return false
    }
    
    
    
    //MARK: - 存储属性
    var account:UserAccount? 
    
     init() {
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
}
