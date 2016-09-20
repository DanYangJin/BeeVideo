//
//  VideoHistoryItem.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/23.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 对应VideoDBHelper中的VideoItem
 */

class VideoHistoryItem: NSObject {

    var videoId:String!
    var videoName:String!
    var sourceId:String!
    var sourceName:String!
    var resolutionType:Int!
    var playedDrama:Int!    //播放的集
    var playedDuration:Int! //播放时间
    var duration:String!
    var poster:String!
    var isFavorited:Bool!
    var deleteTrace:Int!
    var deleteFavorite:Int!
    var dramaOrder:Int!
    var dramaTotalSize:Int!
    var hasUpdate:Bool!
    var score:String!
    
}
