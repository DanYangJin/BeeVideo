//
//  SearchVideoPageData.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/13.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SearchVideoPageData: IBasePageData {

    static let V20_SEARCH_TYPE_ALL = 0 //搜全部
    static let V20_SEARCH_TYPE_DIRECTOR = 1 //搜导演
    static let V20_SEARCH_TYPE_ACTOR = 2 //搜演员
    static let V20_SEARCH_TYPE_VIDEO = 3 //搜视频
    
    var searchKey = ""
    var pageNo = 1
    var totalSize = 0
    var type = V20_SEARCH_TYPE_ALL
    var videoList:[VideoBriefItem] = [VideoBriefItem]()
    var maxPageNum = 0
}
