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
    @IBOutlet weak var picPickerHCons: NSLayoutConstraint!
    @IBOutlet weak var composeTextView: ComposeTextView!
    
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    private lazy var images :[UIImage] = [UIImage]()
    private lazy var emoticonVc :EmoticonController = EmoticonController {  [weak self] (emoticon) -> () in
        self?.composeTextView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.composeTextView)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviUI()
        
        setupNotifications()
        
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
    
    
    private func setupNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.KeyboardDidChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.picDidPick(_:)), name: picDidPickNoti, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.picDidDelete(_:)), name: picDidDeleteNoti, object: nil)
    }
}
extension ComposeViewController {

    func closeCompose() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendCompose() {
        print(self.composeTextView.getEmoticonString())
    }
    
    @IBAction func emoticonBtnClick(sender: AnyObject) {
        composeTextView.resignFirstResponder()
        composeTextView.inputView = composeTextView.inputView != nil ?  nil : emoticonVc.view
        composeTextView.becomeFirstResponder()
    }

    @IBAction func picBtnClick(sender: AnyObject) {
        composeTextView.resignFirstResponder()
        
        picPickerHCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { 
            self.view.layoutIfNeeded()
        }
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
    
    @objc private func picDidPick(noti: NSNotification) {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        let ipc = UIImagePickerController()
        
        ipc.sourceType = .PhotoLibrary
        
        ipc.delegate = self
        
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    @objc private func picDidDelete(noti:NSNotification) {
        guard let image = noti.object as? UIImage else {
            return
        }
        
        guard let index = images.indexOf(image) else {
            return
        }
        images.removeAtIndex(index)
        
        picPickerCollectionView.images = images
        
    }
}


extension ComposeViewController :UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        images.append(image)
        
        picPickerCollectionView.images = images
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
