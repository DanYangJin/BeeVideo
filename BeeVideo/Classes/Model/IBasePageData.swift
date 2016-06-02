//
//  IBasePageData.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class IBasePageData {
    
    static var PAGE_SIZE : Int = 96
    //请求分页的响应值
    static let CODE_UNKNOW : Int = -1
    static let CODE_REQUESTRING : Int = 0 //请求中
    static let CODE_NO_RESULT : Int = 1 //没有相应的视频结果
    static let CODE_SUCCEED : Int = 2 //请求成功
    static let CODE_FAILED : Int = 3 //请求失败
}