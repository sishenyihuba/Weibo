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
    
    
    override func loadView() {
        isLogin ? super.loadView() : loadVisitorView()
    }

}

//MARK: - 加载VisitorView访客视图
extension BaseViewController {
    private func loadVisitorView() {
        view = visitorView
    }
}
