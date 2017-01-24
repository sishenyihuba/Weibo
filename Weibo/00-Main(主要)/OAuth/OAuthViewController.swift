//
//  OAuthViewController.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/11.
//  Copyright © 2017年 Dale. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        loadPage()
    }
}


//MARK: - UI方法
extension OAuthViewController {
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeDidTouch))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillDidTouch))
        
        title = "授权登陆"
    }
    
    private func loadPage() {
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(callback_url)"
        
        guard let url = NSURL(string: urlStr) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
        
    }
}

//MARK: -  点击处理方法
extension OAuthViewController {
    func closeDidTouch() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func fillDidTouch() {
        let jsCode = "document.getElementById('userId').value='macache@163.com';document.getElementById('passwd').value='botoukuang991600';"
        
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}


//MARK: - 网页加载delegate

extension OAuthViewController:UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let  url = request.URL else {
            return true
        }
        
        let urlString = url.absoluteString
        
        guard urlString.containsString("code") else {
                return true
            }
        let code = urlString.componentsSeparatedByString("code=").last!
        //获取AccessToken
        loadAccessToken(code)

        return false
        
    }
}

//MARK: - 获取AccessToken
extension OAuthViewController {
    private func loadAccessToken(code:String) {
        NetworkTools.shareInstance.loadAccessToken(code) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            guard let accoutDict = result else {
                return
            }
            
            let userAccount = UserAccount(dict: accoutDict)
            
            //拿到了Account就需要获取用户信息了
            self.loadUserInfo(userAccount)
        }
    }
}

//MARK: - 获取用户信息
extension OAuthViewController {
    private func loadUserInfo(userAccount:UserAccount) {
        NetworkTools.shareInstance.loadUserInfo(userAccount) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let userInfoDict = result else {
                return
            }
            
            guard let avatar_large = userInfoDict["avatar_large"] as? String else {
                return
            }
            
            guard let screen_name = userInfoDict["screen_name"] as? String else {
                return
            }
            
            userAccount.avatar_large = avatar_large
            userAccount.screen_name = screen_name
            
            //将UserAccount信息保存到plist中
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let accountPath = (path as NSString).stringByAppendingPathComponent("account.plist")
            
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: accountPath)
            
            UserAccountViewModel.sharedInstance.account = userAccount
            
            //欢迎界面
            self.dismissViewControllerAnimated(false, completion: { 
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}