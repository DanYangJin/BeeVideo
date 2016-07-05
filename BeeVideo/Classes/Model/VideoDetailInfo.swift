//
//  VideoDetailInfo.swift
//  SwiftTest
//
//  Created by JinZhang on 16/4/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class VideoDetailInfo{
    
    var id : String!
    var name : String!
    var channel : String!//频道
    var channelId : String!
    var area : String!//地区
    var duration : String!
    var category : String!//视频分类
    var publishTime : String!//上映时间
    var directorString : String = "" //导演
    var directors : [String]!
    var actorString : String = ""//演员
    var actors : [String]!
    var isFavorite : Bool = false//是否收藏
    var desc : String = "" //影片详情 annotation
    var poster : String! //影片图片  smallImage
    var resolutionType : Int! //视频清晰度，对应most
    var count : Int! // 视频集数 对应totalInfo
    var doubanId : String! //豆瓣id
    var doubanKey : String! //apikey
    var doubanAverage : String! //豆瓣评分
    var dramas : [Drama] = [Drama]() // 剧集列表
    
    
    var currentDrama : Drama? // 记录用户要播的集，选中的集
    var lastPlayDramaPosition : Int = 0 //记录最后播放的集数
    var dramaPlayedDuration : Int = 0 //视频播放进度
    var resolutionScaleRation : Int = 0
    var decodeSolution : Int = 0
    var chooseDramaFlag : Int = 0
    var dramaOrderFlag : Int = 0

    func setLastPlayDramaPosition(lastPlayDramaPosition: Int){
        if dramas.isEmpty {
            return
        }
        
        if lastPlayDramaPosition >= dramas.count - 1 {
            self.lastPlayDramaPosition = dramas.count - 1
        }else if lastPlayDramaPosition <= 0 {
            self.lastPlayDramaPosition = 0
        }else {
            self.lastPlayDramaPosition = lastPlayDramaPosition
        }
        
        currentDrama = dramas[self.lastPlayDramaPosition]
    }

    
}
