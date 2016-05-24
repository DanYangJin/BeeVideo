//
//  VodCategory.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 点播列表分类的单个分类的数据结构
 */

class VodCategory{
    
    static let ID_SEARCH:String = "-1000"; // 搜索
    static let ID_SEVEN_DATE_UPGRAD:String = "-1"; // 七日更新
    static let ID_FILTER_CATEGORY_VIDEO:String = "-9"; // 点播筛选
    static let ID_ALL_CATEGORY_VIDEO:String = "-10"; // 全部视频
    
    var id : String = ""
    var channelId : String = ""
    var name : String = ""
    var title : String = ""
}