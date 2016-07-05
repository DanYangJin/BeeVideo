//
//  HttpContants.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class HttpContants {
    static let HOST = "www.beevideo.tv"
    
    
    static let V20_VOD_VIDEO_CATOGORY_LIST_ACTION = "/api/video2.0/stb_area_cate.action"
    static let V20_VOD_VIDEO_VIDEO_LIST_ACTION = "/api/video2.0/video_list.action"
    static let V20_VOD_FILTRATE_CATEGORY_ACTION = "/api/video2.0/video_area_cate_years.action"
    static let V20_SEARCH_VIDEO_RECOMMAND_KEY_ACTION = "/api/video2.0/video_search_hotkey.action"
    static let V20_SEARCH_VIDEO_ACTION = "/api/video2.0/video_search.action"
    
    static let URL_HISTORY_RECOMMEND = "/api/video2.0/commonVideoRec.action"
    static let URL_HOME_DATA = "/api/hometv2.0/listBlockByVersion.action"
    static let URL_HD_VIDEO = "/videoplus/hometv/video_hd.action"
    static let URL_GET_CATEGORY_GROUP = "/api/hometv2.0/listSubjectBlock.action"
    static let URL_SPECIAL_RANK = "/api/video2.0/subject_rank.action"
    static let URL_SPECIAL_ALL = "/api/video2.0/subject_all.action"
    static let URL_WEEK_HOT = "/api/video2.0/listWeekHotVideo.action"
    static let URL_REST_VIDEO_ACTION = "/api/hometv2.0/listVideoCategoryBlock.action"
    static let URL_GET_RECOMM_APK_LIST = "/apprec/front/listAppRec.action"
    static let URL_GET_LIST_VIDEO_SOURCE_INFO = "/api/video2.0/list_video_source_info.action"
    static let URL_GET_VIDEO_DETAIL_INFO_V2 = "/api/video2.0/video_detail_info.action"
    static let URL_GET_VIDEO_RELATED_LIST = "/api/video2.0/video_relate.action"
    
    static let ACTION_QUERY_USER_POINT_INFO = "/userpoint/client/queryUserPointInfo.action"
    
    //Request param
    static let PARAM_CHANNEL_ID = "channelId"
    static let PARAM_STB_CATE_ID = "stbCateId"
    static let PARAM_PAGE_NO = "pageNo"
    static let PARAM_PAGE_SIZE = "pageSize"
}