//
//  ComposeViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/3.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var composeTextView: ComposeTextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.KeyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        composeTextView.becomeFirstResponder()
    }

}

extension ComposeViewController {
    private func setupNaviUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeCompose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: #selector(ComposeViewController.sendCompose))
        navigationItem.rightBarButtonItem?.enabled
        
        title = "发微博"

    }
}
extension ComposeViewController {

    func closeCompose() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendCompose() {
        
    }
}

extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.composeTextView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        composeTextView.resignFirstResponder()
    }
}

extension ComposeViewController {
    @objc private func KeyboardDidChangeFrame(noti:NSNotification) {
        let during = noti.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSTimeInterval
        let endRect = (noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).CGRectValue()
        let y = endRect.origin.y
        let margin = UIScreen.mainScreen().bounds.height - y
        
        toolBarBottomCons.constant = margin
        UIView.animateWithDuration(during) { 
            self.view.layoutIfNeeded()
        }
    }
}
