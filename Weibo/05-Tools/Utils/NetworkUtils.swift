//
//  NetworkUtils.swift
//  Weibo
//
//  Created by daixianglong on 2017/1/11.
//  Copyright © 2017年 Dale. All rights reserved.
//

import AFNetworking

enum RequestType :Int {
    case GET
    case POST
}

class NetworkUtils: AFHTTPSessionManager {

    static let sharedInstance : NetworkUtils = NetworkUtils()
    
}

//MARK: - 封装网络请求方法
extension NetworkUtils {
    func request(type:RequestType,urlString:String,parameters:AnyObject?,completHandler:(result:AnyObject?,error:NSError?)->()) {
        if(type == .GET) {
            GET(urlString, parameters: parameters, success: { (task: NSURLSessionDataTask, result:AnyObject?) in
                completHandler(result: result, error: nil)
                }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                    completHandler(result: nil, error: error)
            })
        } else if (type == .POST) {
            POST(urlString, parameters: parameters, success: { (task: NSURLSessionDataTask, result:AnyObject?) in
                completHandler(result: result, error: nil)
                }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
            })
        }
    }
}
