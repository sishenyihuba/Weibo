//
//  MainTabViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    private lazy var composeBtn:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCpomposeBtn()
    }
    
    //MARK: - Utils方法
    private func setupCpomposeBtn() {
        tabBar.addSubview(composeBtn)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        composeBtn.sizeToFit()
        
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        composeBtn.addTarget(self, action: #selector(MainTabViewController.composeBtnDidTouch), forControlEvents: .TouchUpInside)

    }

    @objc private func composeBtnDidTouch() {
        
    }
    
}
