//
//  EmoticonController.swift
//  09-表情键盘
//
//  Created by xiaomage on 16/4/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonController: UIViewController {
    // MARK:- 定义属性
    var emoticonCallBack : (emoticon : Emoticon) -> ()
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    
    // MARK:- 自定义构造函数
    init (emoticonCallBack : (emoticon : Emoticon) -> ()) {
        
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}


// MARK:- 设置UI界面内容
extension EmoticonController {
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        toolBar.backgroundColor = UIColor.darkGrayColor()
        
        // 2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cView]-0-[tBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        // 3.准备collectionView
        prepareForCollectionView()
        
        // 4.准备toolBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        collectionView.registerClass(EmioticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        // 1.定义toolBar中titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 2.遍历标题,创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: "itemClick:")
            item.tag = index
            index++
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        
        // 3.设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
    }
    
    @objc private func itemClick(item : UIBarButtonItem) {
        // 1.获取点击的item的tag
        let tag = item.tag
        
        // 2.根据tag获取到当前组
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        
        // 3.滚动到对应的位置
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}


// MARK:- collectionView的数据源和代理方法
extension EmoticonController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        
        return package.emoticons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonCell, forIndexPath: indexPath) as! EmioticonViewCell
        
        // 2.给cell设置数据
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    
    /// 代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1.取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        // 2.将点击的表情插入最近分组中
        insertRecentlyEmoticon(emoticon)
        
        // 3.将表情回调给外界控制器
        emoticonCallBack(emoticon: emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon : Emoticon) {
        // 1.如果是空白表情或者删除按钮,不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        
        // 2.删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) { // 原来有该表情
            let index = (manager.packages.first?.emoticons.indexOf(emoticon))!
            manager.packages.first?.emoticons.removeAtIndex(index)
        } else { // 原来没有这个表情
            manager.packages.first?.emoticons.removeAtIndex(19)
        }
        
        // 3.将emoticon插入最近分组中
        manager.packages.first?.emoticons.insert(emoticon, atIndex: 0)
    }
}




class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.计算itemWH
        let itemWH = UIScreen.mainScreen().bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        // 3.设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}








