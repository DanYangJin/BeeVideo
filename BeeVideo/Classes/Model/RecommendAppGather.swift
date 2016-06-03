//
//  RecommendAppGather.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 推荐应用信息的集合
 */


class RecommendAppGather: NSObject {
    
    var total:String
    var appList:[RecommendAppInfo]
    
    override init() {
        total = ""
        appList = [RecommendAppInfo]()
    }
    
}
