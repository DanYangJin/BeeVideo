//
//  VodVideoPageData.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
/**
 * 点播视频列表分页请求的存储数据结构
 */

class VodVideoPageData: IBasePageData {
    
    var id : String = ""  // 请求频道视频列表的URL, 作为与其他page作为唯一识别的key值
    var totalSize:String = "" //匹配搜索关键词所有结果的数量
    var pageNo : Int = 0 //分页请求所在的页数
    var videoList : Array<VideoBriefItem> = Array()

}
