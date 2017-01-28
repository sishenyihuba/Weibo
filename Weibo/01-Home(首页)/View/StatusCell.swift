//
//  StatusCell.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/25.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage

let  margin : CGFloat = 15
class StatusCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var verifyImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelWidth: NSLayoutConstraint!
    
    
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
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabelWidth.constant = UIScreen.mainScreen().bounds.width - 2 * margin
    }

}
