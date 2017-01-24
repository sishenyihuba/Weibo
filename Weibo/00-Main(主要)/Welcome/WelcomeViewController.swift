//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/16.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var imageButtonConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        guard let userAccount = UserAccountViewModel.sharedInstance.account else{
            return
        }
        
        headerImageView.sd_setImageWithURL(NSURL.init(string: userAccount.avatar_large ?? ""), placeholderImage: UIImage(named: "avatar_default"))
        welcomeLabel.text = userAccount.screen_name!
        
        
        imageButtonConstraint.constant = UIScreen.mainScreen().bounds.height - 200
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: .CurveEaseIn, animations: {
            self.view.layoutIfNeeded()
            }, completion: { finish in
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        })
    }

}
