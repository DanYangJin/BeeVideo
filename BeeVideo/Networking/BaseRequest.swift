//
//  BaseRequest.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Foundation

enum RequestType:Int{
    case GET;
    case POST;
}

class BaseRequest {
    
    private let retryTimes = 3
    private var baseResult:BaseResult
    private var url:String!
    private var pathSegments:Dictionary<String, String>!
    private var headers:Dictionary<String, String>!
    private var requestType:RequestType!
    private var needPassport:Bool = true
    
    
    init(baseResult:BaseResult){
        self.baseResult = baseResult
    }
    
    //同步请求
    func sendSync(){
    
    }
    
    //异步请求
    func sendAsyn(){
        requestType = getMethod()
        let success:Bool = configUrl()
        if !success {
            return
        }
        print("url : " + self.url)
        let requestUrl:NSURL = NSURL(string: self.url)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: requestUrl)
        for var i = 0; i < retryTimes; i++ {
            switch requestType! {
            case RequestType.GET:
                request.HTTPMethod = InternetUtils.REQUEST_METHOD_GET
            case RequestType.POST:
                request.HTTPMethod = InternetUtils.REQUEST_METHOD_POST
            }
            setCommonHeaders(request)
            setAdditionalHeaders(request)
            
            
            let session = NSURLSession.sharedSession()

//            var httpResponse:NSHTTPURLResponse!
//            var httpData:NSData!
//            var httpError:NSError!
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                httpResponse = response as! NSHTTPURLResponse
//                httpData = data
//                httpError = error
                self.baseResult.parseData(data, error: error)
            })
//            if httpResponse.statusCode == 403 {
//                sleep(1)
//                configUrl()
//                continue
//            }
//            if httpResponse.statusCode != 200 {
//                sleep(1)
//                continue
//            }
//            if httpData == nil {
//                sleep(1)
//                continue
//            }
//            self.baseResult.parseData(httpData, error: httpError)
            task.resume()
            break
        }
        
    }
    
    func configUrl() -> Bool{
        url = getUrl()
        pathSegments = appendUrlSegment()
        headers = getHeaders()
        if needPassport {
            attachPassport("3p3kgHRqy244-VwtggWOVCAQEkAsn3SyyqGnCWqhScQNC_vyA9wYQ18Vvq7XJl8U")
        }
        url = UrlCfgUtils.configNormalSegments(url, segments: pathSegments)
        return true
    }
    
    func attachPassport(passport:String){
        url.appendContentsOf("?")
        url.appendContentsOf("borqsPassport")
        url.appendContentsOf("=")
        url.appendContentsOf(passport)
    
    }
    
    
    func setCommonHeaders(request:NSMutableURLRequest){
    
    }
    
    func setAdditionalHeaders(request:NSMutableURLRequest){
        if headers == nil || headers.isEmpty {
            return
        }
        for (headerField, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    
    //构造URL
    func getUrl() -> String {
        return ""
    }
    
    //请求类型
    func getMethod() -> RequestType {
        return RequestType.GET
        
    }
    //请求参数
    func appendUrlSegment() -> Dictionary<String, String> {
        let params:Dictionary<String, String> = Dictionary<String, String>()
        return params
    }
    //请求头
    func getHeaders() -> Dictionary<String, String> {
        let headers:Dictionary<String, String> = Dictionary<String, String>()
        return headers
    }
    

}
