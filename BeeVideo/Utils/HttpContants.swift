//
//  HttpContants.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class HttpContants {
    static let HOST:String = "www.beevideo.tv"
    
    static let URL_HOME_DATA = "/api/hometv2.0/listBlockByVersion.action"
    static let V20_VOD_VIDEO_CATOGORY_LIST_ACTION:String = "/api/video2.0/stb_area_cate.action"
    static let V20_VOD_VIDEO_VIDEO_LIST_ACTION:String = "/api/video2.0/video_list.action"
    
    
    
    //Request param
    static let PARAM_CHANNEL_ID = "channelId"
    static let PARAM_STB_CATE_ID = "stbCateId"
    static let PARAM_PAGE_NO = "pageNo"
    static let PARAM_PAGE_SIZE = "pageSize"
}