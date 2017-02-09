//
//  PicCollectionView.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/1.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage

private let  margin : CGFloat = 15
private let itemMargin :CGFloat = 10
class PicCollectionView: UICollectionView {

    var picURLs: [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }

}

extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCell
        
        let picUrl = picURLs[indexPath.item]
        cell.picURL = picUrl
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let info = ["index" : indexPath , "PicURLs" : picURLs]
        NSNotificationCenter.defaultCenter().postNotificationName(picBrowserShowNoti, object: self, userInfo: info)
    }
}


//MARK: - TransitionDelegate

extension PicCollectionView : TransitionDelegate {
    func startRect(index: NSIndexPath) -> CGRect {
        let cell = cellForItemAtIndexPath(index)!
        let startFrame = convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        return startFrame
    }
    
    func endRect(index: NSIndexPath) -> CGRect {
        let url = picURLs[index.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)
        
        let width = UIScreen.mainScreen().bounds.width
        let  height = width * image.size.height / image.size.width
        var y :CGFloat = 0
        if height >= UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        
        return CGRectMake(0, y, width, height)
    }
    
    func imageView(index: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        let url = picURLs[index.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        
        return imageView
    }
}




class PicCell : UICollectionViewCell {
    @IBOutlet weak var picImage: UIImageView!
    
    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            picImage.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
}
