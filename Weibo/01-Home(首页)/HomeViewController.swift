//
//  HomeViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage
class HomeViewController: BaseViewController {

    
    //MARK: - 懒加载 
    private lazy var titleBtn:TitleButton = TitleButton()
    private lazy var popMenuArray = ["iOS", "WatchOS","SiriKit","NotificationFW"]
    private lazy var viewModels :[StatusViewModel] = [StatusViewModel]()
    override func viewDidLoad() {
            super.viewDidLoad()
            visitorView.addRotateAnim()
            
            if !isLogin {
                return
            }
            
            setupHomeNavi()
            
            setupTitleBarItem()
            
            loadStatuses()
        
            tableView.estimatedRowHeight = 200
        
        
    
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

//MARK: - 加载微博数据
extension HomeViewController {
    func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            if error != nil {
                return
            }
            guard let resultArray = result else {
                return
            }
            
            for item in resultArray {
                let status = Status(dict: item)
                self.viewModels.append(StatusViewModel(status: status))
            }
            
            
            //缓存下载图片
            self.loadImageCache(self.viewModels)
        }
    }
    
    func  loadImageCache(viewModels: [StatusViewModel]) {
        let group = dispatch_group_create()
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            
            self.tableView.reloadData()
        }
    }
}


extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! StatusCell
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
}


