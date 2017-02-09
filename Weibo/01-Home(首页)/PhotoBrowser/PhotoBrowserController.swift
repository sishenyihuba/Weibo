//
//  PhotoBrowserController.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/8.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
let photoBrowserCell = "photoBrowserCell"

class PhotoBrowserController: UIViewController {

    var index : NSIndexPath?
    var picURLs : [NSURL]?
    
    
    //MARK: - lazy loading
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
    lazy var closeButton  : UIButton = UIButton(color: UIColor(red: 39/255, green: 95/255, blue: 213/255, alpha: 1.0), title: "关闭", cornerR: 3, fontSize: 14)
    lazy var saveButton  : UIButton = UIButton(color: UIColor(red: 39/255, green: 95/255, blue: 213/255, alpha: 1.0), title: "保存", cornerR: 3, fontSize: 14)
    
    init(index:NSIndexPath, PicUrls :[NSURL]) {
        super.init(nibName: nil, bundle: nil)
        
        self.index = index
        self.picURLs = PicUrls
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.bounds.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purpleColor()
        
        setupUI()
        
        closeButton.addTarget(self, action: #selector(PhotoBrowserController.close), forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: #selector(PhotoBrowserController.save), forControlEvents: .TouchUpInside)
        
        setupCollectionView()
        
        collectionView.scrollToItemAtIndexPath(index!, atScrollPosition: .Left, animated: false)
    }
}

extension PhotoBrowserController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        collectionView.frame = view.bounds
        closeButton.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSizeMake(90, 32))
        }
        saveButton.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeButton.snp_bottom)
            make.size.equalTo(CGSizeMake(90, 32))
        }
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        let cell = collectionView.visibleCells().first as! PhotoBrowserCell
        
        guard let image = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    
    func setupCollectionView() {
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.dataSource = self
    }

}


extension PhotoBrowserController {
    @objc private func image(image:UIImage, didFinishSavingWithError error : NSError?, contextInfo: AnyObject) {
        if error != nil {
            SVProgressHUD.showInfoWithStatus("保存失败")
        } else {
            SVProgressHUD.showInfoWithStatus("保存成功")
        }
    }
}



extension PhotoBrowserController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserCell
        
        cell.picURL = picURLs![indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension PhotoBrowserController : PhotoBrowserCellDelegate {
    func imageDidTouch() {
        close()
    }
}



class PhotoBrowserLayout:UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = collectionView!.frame.size
        scrollDirection = .Horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}
