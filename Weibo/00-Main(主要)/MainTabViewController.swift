//
//  MainTabViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.whiteColor()
        guard let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else {
            return
        }
        
        
        guard let jsonData = NSData(contentsOfFile: path) else {
            return
        }
        
        
        guard let jsonAnyObj = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else {
            return
        }
        
        guard let jsonArray = jsonAnyObj as? [[String:AnyObject]] else {
            return
        }
        
        for dict in jsonArray {
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            guard let title = dict["title"] as? String else {
                continue
            }
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            addChildViewController(vcName, title: title, imageName: imageName)
        }

    }
    
    
    func addChildViewController(controllerStr:String,title:String,imageName:String) {
        guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        let vcStr = nameSpace + "." + controllerStr
        
        guard let childVcClass = NSClassFromString(vcStr) else {
            return
        }
        
        guard let childVcType = childVcClass as? UIViewController.Type else {
            return
        }
        
        let childVc = childVcType.init()
        
        //设置控制器的属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let navi = UINavigationController(rootViewController: childVc)
        
        addChildViewController(navi)

    }
}
