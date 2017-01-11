//
//  HomeViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
    //MARK: - 懒加载 
    private lazy var titleBtn:TitleButton = TitleButton()
    private lazy var popMenuArray = ["iOS", "WatchOS","SiriKit","NotificationFW"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addRotateAnim()
        
        if !isLogin {
            return
        }
        
        setupHomeNavi()
        
        setupTitleBarItem()
    }
    
}

//MARK: - 设置Home界面的Bar
extension HomeViewController {
    private func setupHomeNavi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
    }
    
    private func setupTitleBarItem() {
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnDidTouch(_:)), forControlEvents: .TouchUpInside)
    }

}

//MARK: - 点击事件
extension HomeViewController {
    @objc private func titleBtnDidTouch(sender:TitleButton) {
        titleBtn.selected = !titleBtn.selected

        let popMenu = ZWCustomPopView(bounds: CGRectMake(0, 0, 160, 44 * CGFloat(popMenuArray.count)), titleMenus: popMenuArray , maskAlpha: 0.0)
        popMenu.delegate = self
        popMenu.containerBackgroudColor = UIColor.init(red: 68.0/255.0, green: 77.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        
        popMenu.showFrom(sender, alignStyle: .Center)
        
    }
}

//MARK: - 点击TitleButton PopMenu的代理
extension HomeViewController : ZWCustomPopViewDelegate {
    func popOverViewDidDismiss(pView: ZWCustomPopView!) {
        titleBtn.selected = !titleBtn.selected
    }
    
    func popOverView(pView: ZWCustomPopView!, didClickMenuIndex index: Int) {
        print(index)
    }
}


