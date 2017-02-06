//
//  Emoticon.swift
//  09-表情键盘
//
//  Created by xiaomage on 16/4/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    // MARK:- 定义属性
    var code : String? {     // emoji的code
        didSet {
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let scanner = NSScanner(string: code)
            
            // 2.调用方法,扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt(&value)
            
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value))
            
            // 4.将字符转成字符串
            emojiCode = String(c)
        }
    }
    var png : String? {      // 普通表情对应的图片名称
        didSet {
            guard let png = png else {
                return
            }
            
            pngPath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?       // 普通表情对应的文字
    
    // MARK:- 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    // MARK:- 自定义构造函数
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    init (isRemove : Bool) {
        self.isRemove = isRemove
    }
    
    init (isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description : String {
        return dictionaryWithValuesForKeys(["emojiCode", "pngPath", "chs"]).description
    }
}
