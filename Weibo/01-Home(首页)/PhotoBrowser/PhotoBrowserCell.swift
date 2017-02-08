//
//  PhotoBrowserCell.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/8.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage
class PhotoBrowserCell: UICollectionViewCell {

    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
            
            let width = scrollView.frame.width
            
            let height = width * image.size.height / image.size.width
            
            let y = (UIScreen.mainScreen().bounds.height - height) * 0.5
            
            imageView.frame = CGRectMake(0, y, width, height)
            
            
            imageView.setImageWithURL(picURL)
        }
    }
    
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserCell {
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds

    }
}
