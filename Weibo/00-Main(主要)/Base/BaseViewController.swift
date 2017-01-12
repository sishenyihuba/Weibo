//
//  BaseViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    var isLogin:Bool = false
    
    //MARK: - lazy loading
    var visitorView:VisitorView = VisitorView.createVisitorView()
    
    //MARK: - 周期方法
    override func loadView() {
        isLogin ? super.loadView() : loadVisitorView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerDidTouch), forControlEvents: .TouchUpInside)
        
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginDidTouch), forControlEvents: .TouchUpInside)
    }

}

//MARK: - 加载VisitorView访客视图
extension BaseViewController {
    private func loadVisitorView() {
        view = visitorView
    }
}

//MARK: - 设置导航栏
extension BaseViewController {
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(BaseViewController.registerDidTouch))
        
        navigationItem.rightBarButtonItem   = UIBarButtonItem(title: "登陆", style: .Plain, target: self, action: #selector(BaseViewController.loginDidTouch))
    }
}

//MARK: - 点击事件
extension BaseViewController{
    @objc private func registerDidTouch() {
        print("registerDidTouch")
    }
    
    
    @objc private func loginDidTouch() {
        //开始授权登陆
        let oAuthVC = OAuthViewController()
        
        let navi = UINavigationController(rootViewController: oAuthVC)
        
        presentViewController(navi, animated: true, completion: nil)
        
    }
}
