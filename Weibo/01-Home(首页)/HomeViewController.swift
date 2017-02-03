//
//  HomeViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class HomeViewController: BaseViewController {

    
    //MARK: - 懒加载 
    private lazy var titleBtn:TitleButton = TitleButton()
    private lazy var popMenuArray = ["iOS", "WatchOS","SiriKit","NotificationFW"]
    private lazy var viewModels :[StatusViewModel] = [StatusViewModel]()
    private lazy var tipLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            visitorView.addRotateAnim()
            
            if !isLogin {
                return
            }
            
            setupHomeNavi()
            
            setupTitleBarItem()
        
            tableView.estimatedRowHeight = 200
        
            setupHeaderRefresh()
        
            setupFooterRefresh()
        
            setupTipLabel()
    
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
    
    private func  setupHeaderRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("释放刷新", forState: .Pulling)
        header.setTitle("加载中", forState: .Refreshing)
        
        tableView.mj_header = header
        
        tableView.mj_header.beginRefreshing()

    }

    private func   setupFooterRefresh() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
    }

    
    private func setupTipLabel() {
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.mainScreen().bounds.width, height: 25)
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textAlignment = .Center
        tipLabel.textColor = UIColor.whiteColor()
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        tipLabel.hidden = true
        
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
    @objc private func loadNewStatuses() {
        loadStatuses(true)
    }
    
    @objc private func loadMoreStatuses() {
        loadStatuses(false)
    }
    
    func loadStatuses(isNewStatus:Bool) {
        var since_id = 0
        var max_id = 0
        if isNewStatus {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = (max_id == 0) ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error) in
            if error != nil {
                return
            }
            guard let resultArray = result else {
                return
            }
            
            var tempModels = [StatusViewModel]()
            for item in resultArray {
                let status = Status(dict: item)
                tempModels.append(StatusViewModel(status: status))
            }
            if isNewStatus {
                self.viewModels = tempModels + self.viewModels
            } else {
                self.viewModels += tempModels
            }
            
            //缓存下载图片
            self.loadImageCache(tempModels)
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
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.showTipLabel(viewModels.count)
        }
    }
    
    func showTipLabel(count :Int) {
        UIView.animateWithDuration(1.0, animations: { 
            self.tipLabel.hidden = false
            self.tipLabel.frame.origin.y = 44
            self.tipLabel.text = (count == 0) ? "没有新微博" : "新的\(count)条微博"
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
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


