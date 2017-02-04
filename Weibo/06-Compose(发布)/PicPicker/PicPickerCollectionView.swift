//
//  PicPickerCollectionView.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/4.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
let picPickerIdentifier = "picPickerIdentifier"
let picMargin :CGFloat = 5
let picEdge :CGFloat = 12
class PicPickerCollectionView: UICollectionView {

   var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        
        setupCollectionViewLayout()
        
        
        registerNib(UINib.init(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: picPickerIdentifier)
    }

}


extension PicPickerCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCellWithReuseIdentifier(picPickerIdentifier, forIndexPath: indexPath) as! PicPickerCell
        
        cell.image = (indexPath.row <= images.count - 1) ? images[indexPath.row] : nil
        
        return cell
    }
}

extension PicPickerCollectionView {
    private func setupCollectionViewLayout() {
        let itemWH = (UIScreen.mainScreen().bounds.width - 2 * picMargin - 2 * picEdge) / 3
        
        let layout  = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSizeMake(itemWH, itemWH)
        
        contentInset = UIEdgeInsetsMake(picEdge, picEdge, 0, picEdge)
    }
}
