//
//  StatusCell.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/25.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage

private let  margin : CGFloat = 15
private let itemMargin :CGFloat = 10
class StatusCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var verifyImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var retweetContentLabel: UILabel!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetLabelTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var bottomToolView: UIView!
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImageView.sd_setImageWithURL(NSURL.init(string: (viewModel.status?.user?.profile_image_url)!), placeholderImage: UIImage.init(named: "avatar_default_small"))
            
            verifyImageView.image = viewModel.verifiedImage
            
            nameLable.text = viewModel.status?.user?.screen_name
            
            vipImageView.image = viewModel.vipImage
            
            createTimeLabel.text = viewModel.create_at_text
            
            fromLabel.text = "来自 " + viewModel.sourceText!
            
            contentLabel.text = viewModel.status?.text
            
            nameLable.textColor = (viewModel.vipImage != nil) ? UIColor.orangeColor() : UIColor.blackColor()
            
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewHCons.constant = picViewSize.height
            picViewWCons.constant = picViewSize.width
            
            picView.picURLs = viewModel.picURLs
            
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name , retweetText = viewModel.status?.retweeted_status?.text {
                    
                    retweetContentLabel.text = "@\(screenName):\n" + retweetText
                    retweetView.hidden = false
                    retweetLabelTopCons.constant = 15
                }
            } else {
                retweetContentLabel.text = nil
                retweetView.hidden = true
                retweetLabelTopCons.constant = 0

            }
            
            //计算Cell高度
            if (viewModel.cellHeight == 0) {
                layoutIfNeeded()
                let cellHeight = CGRectGetMaxY(bottomToolView.frame)
                viewModel.cellHeight = cellHeight
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabelWidth.constant = UIScreen.mainScreen().bounds.width - 2 * margin
    }

}

extension StatusCell {
    private func calculatePicViewSize(count:Int) -> CGSize {
        //没有配图
        if count  == 0 {
            picViewBottomCons.constant = 0
            return CGSizeZero
        }
        
        picViewBottomCons.constant = 10
        
        let flowLayout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if count == 1 {
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(viewModel?.picURLs.last?.absoluteString)
            flowLayout.itemSize = CGSizeMake(image.size.width * 2 , image.size.height * 2)
            return CGSizeMake(image.size.width * 2 , image.size.height * 2)
        }
        
        
        let itemWH = (UIScreen.mainScreen().bounds.width - 2 * margin - 2 * itemMargin) / 3
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH)
        //4张配图
        if  count == 4 {
            let picViewWH = 2 * itemWH + itemMargin
            return CGSizeMake(picViewWH, picViewWH)
        }
        
        //其他配图情况
        let row = CGFloat((count - 1) / 3 + 1)
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * margin
        let picViewH = row * itemWH + (row - 1) * itemMargin
        return CGSizeMake(picViewW, picViewH)
        
        
    }
}
