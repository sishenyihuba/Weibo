//
//  PhotoBrowserTransition.swift
//  Weibo
//
//  Created by daixianglong on 2017/2/9.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit

protocol TransitionDelegate : NSObjectProtocol {
    func startRect(index : NSIndexPath) -> CGRect
    func endRect(index : NSIndexPath) -> CGRect
    func imageView(index : NSIndexPath) -> UIImageView
}

protocol DimissDelegate : NSObjectProtocol {
    func indexPathForDismiss() -> NSIndexPath
    func imageView() -> UIImageView
}

class PhotoBrowserTransition: NSObject {

    var isPresented : Bool = false
    var presentedDelegate : TransitionDelegate?
    var dimissDelegate : DimissDelegate?
    var index : NSIndexPath?
}

extension PhotoBrowserTransition :UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


extension PhotoBrowserTransition : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.取出弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 2.将prensentedView添加到containerView中
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        transitionContext.containerView()?.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.alpha = 0.0
        guard let imageView = presentedDelegate?.imageView(index!) else {
            return
        }
        guard let startRect = presentedDelegate?.startRect(index!) else {
            return
        }
        
        guard let endRect = presentedDelegate?.endRect(index!) else {
            return
        }
        
        imageView.frame = startRect
        
        transitionContext.containerView()?.addSubview(imageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
            imageView.frame = endRect
            }) { (_) in
                presentedView.alpha = 1.0
                imageView.removeFromSuperview()
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }
        
    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissDeletgate = dimissDelegate , presentedDelegate = presentedDelegate else {
            return
        }
        // 1.取出消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        dismissView?.removeFromSuperview()
        // 2.执行动画
        let imageView = dismissDeletgate.imageView()
        transitionContext.containerView()?.addSubview(imageView)
        let indexPath = dismissDeletgate.indexPathForDismiss()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentedDelegate.startRect(indexPath)
        }) { (_) -> Void in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    
    }
}
