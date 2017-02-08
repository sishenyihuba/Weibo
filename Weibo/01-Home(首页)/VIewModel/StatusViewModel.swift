//
//  StatusViewModel.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/25.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    var status:Status?
    
    var cellHeight:CGFloat = 0
    
    //处理微博数据,MVVM的应用
    var sourceText :String?
    var create_at_text:String?
    
    
    var verifiedImage:UIImage?
    var vipImage:UIImage?
    
    var picURLs :[NSURL] = [NSURL]()
    
    
    init(status:Status) {
        super.init()
        self.status = status
        
        if let source = status.source where source != "" {
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            sourceText =  (source as NSString).substringWithRange(NSRange.init(location: startIndex, length: length))
        }
        
        if let created_at = status.created_at {
            create_at_text = NSDate.createDateString(created_at)
        }
        
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        
        let mbrank = status.user?.mbrank ?? 0
        if (mbrank > 0 && mbrank <= 6) {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        let picArray = (status.pic_urls?.count != 0) ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picArray = picArray {
            for picDict in picArray {
                guard let picUrlString = picDict["thumbnail_pic"] else {
                    continue
                }
                var tempPicUrlString = picUrlString
                if tempPicUrlString.containsString("thumbnail") {
                    let  range = tempPicUrlString.rangeOfString("thumbnail")
                    tempPicUrlString.replaceRange(range!, with: "bmiddle")
                }
                
                picURLs.append(NSURL(string: tempPicUrlString)!)
            }
        }
        
        
    }
}
