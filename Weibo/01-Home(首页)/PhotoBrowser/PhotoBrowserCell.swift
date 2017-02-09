//
//  PhotoBrowserCell.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/8.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate : class {
    func imageDidTouch()
}

class PhotoBrowserCell: UICollectionViewCell {

    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            print(picURL.absoluteString)
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
            
            let width = scrollView.frame.width
            
            let height = width * image.size.height / image.size.width
            
            var y :CGFloat = 0
            if height > UIScreen.mainScreen().bounds.height {
                y = 0
            } else {
                y = (UIScreen.mainScreen().bounds.height - height) * 0.5
            }
            
            imageView.frame = CGRectMake(0, y, width, height)
            
            progressView.hidden = false
            imageView.sd_setImageWithURL(getBigURL(picURL), placeholderImage: image, options: [], progress: { (current, total) in
                    self.progressView.progress = CGFloat(current) / CGFloat(total)
                }) { (_, _, _, _) in
                    self.progressView.hidden = true
            }
            
            scrollView.contentSize = CGSize(width: 0, height: height)
        }
    }
    
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    lazy var progressView : ProgressView = ProgressView()
    
    var delegate : PhotoBrowserCellDelegate?
    
    
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
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        scrollView.bounds.size.width -= 20
        progressView.bounds = CGRectMake(0, 0, 50, 50)
        progressView.center = CGPointMake(UIScreen.mainScreen().bounds.width * 0.5, UIScreen.mainScreen().bounds.height * 0.5)
        progressView.backgroundColor = UIColor.clearColor()
        progressView.hidden = true
        
        imageView.userInteractionEnabled = true
        let tap = UIGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.tapImage))
        imageView.addGestureRecognizer(tap)
    }
    
    private func getBigURL(smallURL:NSURL) -> NSURL {
        let urlString = smallURL.absoluteString
        let bigUrlString = urlString.stringByReplacingOccurrencesOfString("bmiddle", withString: "large")
        return NSURL(string: bigUrlString)!
    }
}

extension PhotoBrowserCell {
    @objc private func tapImage() {
        delegate?.imageDidTouch()
    }
}
