//
//  TestRequest.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire


class TestRequest:BaseRequest{
    
    override init(baseResult: BaseResult) {
        super.init(baseResult: baseResult)
    }
    
    //构造URL
    override func getUrl() -> String {
        return "http://www.beevideo.tv/api/hometv2.0/listBlockByVersion.action"
    }
    
    //请求类型
    override func getMethod() -> RequestType {
        return RequestType.GET
    
    }
    //请求参数
    override func appendUrlSegment() -> Dictionary<String, String> {
        var params:Dictionary<String, String> = Dictionary<String, String>()
        params["sdkLevel"] = "19"
        params["version"] = "2"
        return params
    }
    //请求头
    override func getHeaders() -> Dictionary<String, String> {
        let headers:Dictionary<String, String> = Dictionary<String, String>()
        return headers
    }
    
}
