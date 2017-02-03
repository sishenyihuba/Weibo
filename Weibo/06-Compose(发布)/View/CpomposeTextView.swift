//
//  CpomposeTextView.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/3.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {

    lazy var placeHolderLabel :UILabel = {
       let label = UILabel()
        label.font = self.font
        label.textColor = UIColor.lightGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
        
    }
    
    private func setupUI() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        
        //设置内容边距
        textContainerInset = UIEdgeInsetsMake(6, 7, 0, 0)
    }

}
