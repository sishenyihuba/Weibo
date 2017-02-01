//
//  PicCollectionView.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/1.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
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
    }

}

extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCellWithReuseIdentifier("PicCell", forIndexPath: indexPath) as! PicCell
        
        let picUrl = picURLs[indexPath.item]
        cell.picURL = picUrl
        
        return cell
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
