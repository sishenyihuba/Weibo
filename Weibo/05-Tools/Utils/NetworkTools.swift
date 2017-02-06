//
//  NetworkTools.swift
//  06-AFNetworking的封装
//
//  Created by daixianglong on 16/4/6.
//  Copyright . All rights reserved.
//

import AFNetworking

// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    // let是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
}

// MARK:- 封装请求方法
extension NetworkTools {
    func request(methodType : RequestType, urlString : String, parameters : [String : AnyObject], finished : (result : AnyObject?, error : NSError?) -> ()) {
        
        // 1.定义成功的回调闭包
        let successCallBack = { (task : NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        
        // 2.定义失败的回调闭包
        let failureCallBack = { (task : NSURLSessionDataTask?, error : NSError) -> Void in
            finished(result: nil, error: error)
        }
        
        // 3.发送网络请求
        if methodType == .GET {
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}


// MARK:- 请求AccessToken
extension NetworkTools {
    func loadAccessToken(code : String, finished : (result : [String : AnyObject]?, error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : secret_key, "grant_type" : "authorization_code", "redirect_uri" : callback_url, "code" : code]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}


// MARK:- 请求用户的信息
extension NetworkTools {
    func loadUserInfo(userAccount:UserAccount,completionHandler:(result:[String:AnyObject]?,error:NSError?)->()) {
        guard let access_token = userAccount.access_token else {
            return
        }
        
        guard let uid = userAccount.uid else {
            return
        }
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        request(.GET, urlString: "https://api.weibo.com/2/users/show.json", parameters: parameters) { (result, error) in
            completionHandler(result: result as? [String:AnyObject], error: error)
        }
    }
}

//MARK: - 请求微博数据
extension NetworkTools {
    func loadStatuses(since_id :Int,max_id :Int, completionHandler:(result:[[String:AnyObject]]?, error:NSError?)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token" : (UserAccountViewModel.sharedInstance.account?.access_token)!, "since_id" : since_id,"max_id" : max_id]
        request(.GET, urlString: urlString, parameters: parameters as! [String : AnyObject]) { (result, error) in
            guard let resultDict = result as?  [String:AnyObject] else {
                return
            }
            completionHandler(result: resultDict["statuses"] as? [[String:AnyObject]], error: error)
        }
    }
}

//MARK: - 发送微博
extension NetworkTools {
    func sendStatus(statusText : String, isSuccess : (isSuccess : Bool) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.sharedInstance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            if result != nil {
                isSuccess(isSuccess: true)
            } else {
                isSuccess(isSuccess: false)
            }
        }
    }
}


// MARK:- 发送微博并且携带照片
extension NetworkTools {
    func sendStatus(statusText : String, image : UIImage, isSuccess : (isSuccess : Bool) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.sharedInstance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
        POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPartWithFileData(imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
            
            }, progress: nil, success: { (_, _) -> Void in
                isSuccess(isSuccess: true)
        }) { (_, error) -> Void in
            print(error)
        }
    }
}



