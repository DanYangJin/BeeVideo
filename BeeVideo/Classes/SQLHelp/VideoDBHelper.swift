//
//  VideoDBHelper.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/22.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoDBHelper: NSObject {
    
    private let TABLE_VIDEO_INFO = "t_video_info"
    private let ONE_MONTH_TIME_INTERVAL:Double = 30 * 24 * 3600 * 1000
    
    static func shareInstance() -> VideoDBHelper{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:VideoDBHelper?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=VideoDBHelper()
            }
        )
        return Singleton.single!
    }
    
    private override init() {
        
    }
    
    
    private func getDB() -> FMDatabase{
        
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        let databasePath = docsDir.stringByAppendingPathComponent("data.db")
        let db = FMDatabase(path: databasePath)
        if db.open(){
            let sql_stmt = "CREATE TABLE IF NOT EXISTS t_video_info(_id INTEGER PRIMARY KEY AUTOINCREMENT,videoId TEXT NOT NULL,videoName TEXT,poster TEXT,sourceId TEXT NOT NULL,sourceName TEXT,resolutionType INTEGER, playedDrama INTEGER,playedDuration TEXT,isHistory INTEGER,isFavorited INTEGER,duration TEXT,deleteFavorite INTEGER DEFAULT \(VideoInfoUtils.DELETE_FAVORITE_NO),deleteTrace INTEGER DEFAULT \(VideoInfoUtils.DELETE_TRACE_NO),dramaOrder INTEGER DEFAULT \(VideoInfoUtils.DRAMA_ORDER_SEQUENCE),dramaTotalSize INTEGER,totalSize INTEGER,hasUpdate INTEGER DEFAULT \(VideoInfoUtils.VIDEO_NO_UPDATE) ,timestamp LONG)"
            if !db.executeStatements(sql_stmt) {
                print("table creat fail")
            }
            db.close()
            
        }
        
        return FMDatabase(path: databasePath)
    }
    
    private class VideoItem {
        private static let _ID = "_id"
        private static let _count = "_count"
        /* 用于查询视频信息 */
        private static let VIDEO_ID = "videoId";
        /* 视频名称，用于界面展示 */
        private static let VIDEO_NAME = "videoName";
        /* 海报 */
        private static let POSTER = "poster";
        /* 记录播放的是哪一个源，剧集和源有关系，各个源所拥有的剧集数不一定一样 */
        private static let SOURCE_ID = "sourceId";
        /* 记录播放的源名称，用于播放加载的时候界面展示 */
        private static let SOURCE_NAME = "sourceName";
        /* 视频清晰度，用于界面展示 */
        private static let RESOLUTION_TYPE = "resolutionType";
        /* 播放到哪一集 */
        private static let PLAYED_DRAMA = "playedDrama";
        /* 当前播放的进度 */
        private static let PLAYED_DURATION = "playedDuration";
        /* 视频的总时长，或者是电视剧的总集数 */
        private static let DURATION = "duration";
        /* 是否观看历史 */
        private static let IS_HISTORY = "isHistory";
        /* 是否已收藏 */
        private static let IS_FAVORITED = "isFavorited";
        /* 删除收藏 */
        private static let DELETE_FAVORITE = "deleteFavorite";
        /* 删除观看历史 */
        private static let DELETE_TRACE = "deleteTrace";
        /* 剧集排序方式 */
        private static let DRAMA_ORDER = "dramaOrder";
        /* 该源下总共有多少集 */
        private static let DRAMA_TOTAL_SIZE = "dramaTotalSize";
        /* 合并所有源后显示的总集数 */
        private static let TOTAL_SIZE = "totalSize";
        /* 改剧集是否有更新 */
        private static let HAS_UPDATE = "hasUpdate";
        /* 观看的时间戳 */
        private static let TIMESTAMP = "timestamp";
    }
    
    /**
     插入新的数据，如果存在则更新
     */
    func saveOrUpdate(videoDetailInfo:VideoDetailInfo){
        let videoSourceInfo = videoDetailInfo.currentDrama?.currentUsedSourceInfo
        if videoSourceInfo == nil{
            return
        }
        let result = getItem(videoDetailInfo)
        if result {
            updateHistory(videoDetailInfo)
        }else{
            saveHistory(videoDetailInfo)
        }
        
    }
    
    private func getItem(videoDetailInfo:VideoDetailInfo) -> Bool{
        let db = getDB()
        let sql = "select * from " + TABLE_VIDEO_INFO + " where videoId = ?"
        
        if db.open(){
            let result = db.executeQuery(sql, withArgumentsInArray: [videoDetailInfo.id])
            let flag = result.next()
            db.close()
            return flag
        }
        
        return false
    }
    
    private func saveHistory(videoDetailInfo:VideoDetailInfo){
        let db = getDB()
        
        let sql = "insert into " + TABLE_VIDEO_INFO + " (videoId, videoName, poster, sourceId, sourceName, resolutionType, playedDrama, playedDuration, duration, isFavorited, deleteFavorite, deleteTrace, dramaOrder, dramaTotalSize, totalSize, timestamp, isHistory) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        let timeInterval = NSDate().timeIntervalSince1970 * 1000
        let params:[AnyObject] = [videoDetailInfo.id,
                                  videoDetailInfo.name ?? NSNull(),
                                  videoDetailInfo.poster ?? NSNull(),
                                  (videoDetailInfo.currentDrama!.currentUsedSourceInfo?.id)!,
                                  (videoDetailInfo.currentDrama!.currentUsedSourceInfo?.name)!,
                                  videoDetailInfo.resolutionType ?? NSNull(),
                                  videoDetailInfo.lastPlayDramaPosition ?? NSNull(),
                                  videoDetailInfo.dramaPlayedDuration ?? NSNull(),
                                  videoDetailInfo.duration ?? NSNull(),
                                  videoDetailInfo.isFavorite ? VideoInfoUtils.FAVORITE_YES : VideoInfoUtils.FAVORITE_NO,
                                  VideoInfoUtils.DELETE_FAVORITE_NO,
                                  VideoInfoUtils.DELETE_TRACE_NO,
                                  videoDetailInfo.dramaOrderFlag ?? NSNull(),
                                  videoDetailInfo.dramas.count ?? NSNull(),
                                  videoDetailInfo.count ?? NSNull(),
                                  timeInterval,
                                  1]
        
        if db.open() {
            db.executeUpdate(sql, withArgumentsInArray: params)
            db.close()
        }
        
    }
    
    private func updateHistory(videoDetailInfo:VideoDetailInfo){
        
        print("update")
        
        let db = getDB()
        
        let sql = "update " + TABLE_VIDEO_INFO + " set videoName = ?, poster = ?, sourceId = ?, sourceName = ?, resolutionType = ?, playedDrama = ?, playedDuration = ?, duration = ?, isFavorited = ?, deleteFavorite = ?, deleteTrace = ?, dramaOrder = ?, dramaTotalSize = ?, totalSize = ?, timestamp = ?, isHistory = ? where videoId = ?"
        
        let timeInterval = NSDate().timeIntervalSince1970 * 1000
        let params:[AnyObject] = [videoDetailInfo.name ?? NSNull(),
                                  videoDetailInfo.poster ?? NSNull(),
                                  (videoDetailInfo.currentDrama!.currentUsedSourceInfo?.id)!,
                                  (videoDetailInfo.currentDrama!.currentUsedSourceInfo?.name)!,
                                  videoDetailInfo.resolutionType ?? NSNull(),
                                  videoDetailInfo.lastPlayDramaPosition ?? NSNull(),
                                  videoDetailInfo.dramaPlayedDuration ?? NSNull(),
                                  videoDetailInfo.duration ?? NSNull(),
                                  videoDetailInfo.isFavorite ? VideoInfoUtils.FAVORITE_YES : VideoInfoUtils.FAVORITE_NO,
                                  VideoInfoUtils.DELETE_FAVORITE_NO,
                                  VideoInfoUtils.DELETE_TRACE_NO,
                                  videoDetailInfo.dramaOrderFlag ?? NSNull(),
                                  videoDetailInfo.dramas.count ?? NSNull(),
                                  videoDetailInfo.count ?? NSNull(),
                                  timeInterval,
                                  1,
                                  videoDetailInfo.id]
        if db.open(){
            db.executeUpdate(sql, withArgumentsInArray: params)
            db.close()
        }
    }
    
    /**
     获取用户观看历史，一个月有效
     */
    func getHistoryList() -> [VideoHistoryItem]{
        
        let db = getDB()
        var ret = [VideoHistoryItem]()
        let sql = "select * from " + TABLE_VIDEO_INFO + " where timestamp > ? and deleteTrace = ? and isHistory = ? order by timestamp desc"
        let now = NSDate().timeIntervalSince1970 * 1000
        let params:[AnyObject] = [ now - ONE_MONTH_TIME_INTERVAL,
                                   VideoInfoUtils.DELETE_TRACE_NO,
                                   1]
        if db.open(){
            let result = db.executeQuery(sql, withArgumentsInArray: params)
            ret = getVideoList(result)
            db.close()
        }
        
        return ret
    }
    
    
    private func getVideoList(result:FMResultSet) -> [VideoHistoryItem]{
        var ret = [VideoHistoryItem]()
        while result.next() {
            ret.append(obtainHistoryItem(result))
        }
        
        return ret
        
    }
    
    private func obtainHistoryItem(result:FMResultSet) -> VideoHistoryItem{
        
        let ret = VideoHistoryItem()
        ret.videoId = result.stringForColumn(VideoItem.VIDEO_ID)
        ret.videoName = result.stringForColumn(VideoItem.VIDEO_NAME)
        ret.poster = result.stringForColumn(VideoItem.POSTER)
        ret.sourceId = result.stringForColumn(VideoItem.SOURCE_ID)
        ret.sourceName = result.stringForColumn(VideoItem.SOURCE_NAME)
        ret.resolutionType = Int(result.intForColumn(VideoItem.RESOLUTION_TYPE))
        ret.playedDrama = Int(result.intForColumn(VideoItem.PLAYED_DRAMA))
        ret.playedDuration = Int(result.intForColumn(VideoItem.PLAYED_DURATION))
        ret.duration = result.stringForColumn(VideoItem.DURATION)
        ret.isFavorited = VideoInfoUtils.isVideoFavorited(Int(result.intForColumn(VideoItem.IS_FAVORITED)))
        ret.deleteFavorite = Int(result.intForColumn(VideoItem.DELETE_FAVORITE))
        ret.deleteTrace = Int(result.intForColumn(VideoItem.DELETE_TRACE))
        ret.dramaOrder = Int(result.intForColumn(VideoItem.DRAMA_ORDER))
        ret.dramaTotalSize = Int(result.intForColumn(VideoItem.DRAMA_TOTAL_SIZE))
        
        return ret
    }
    
    /**
     删除历史
     */
    func deleteHistory(item:VideoHistoryItem){
        let videoId = item.videoId
        if videoId == nil || videoId.isEmpty {
            return
        }
        let sql = "update " + TABLE_VIDEO_INFO + " set deleteTrace = ? where videoId = ?"
        let db = getDB()
        if db.open() {
            db.executeUpdate(sql, withArgumentsInArray: [VideoInfoUtils.DELETE_TRACE_YES,videoId])
            db.close()
        }
    }
    
    /**
     删除收藏
     */
    func deleteFavorite(item:VideoHistoryItem){
        let videoId = item.videoId
        if videoId == nil || videoId.isEmpty {
            return
        }
        let sql = "update " + TABLE_VIDEO_INFO + " set deleteFavorite = ? where videoId = ?"
        let db = getDB()
        if db.open(){
            db.executeUpdate(sql, withArgumentsInArray: [VideoInfoUtils.DELETE_FAVORITE_YES,videoId])
            db.close()
        }
    }
    
    func getFavoriteList() -> [VideoHistoryItem]{
        let sql = "select * from " + TABLE_VIDEO_INFO + " where isFavorited = ? and deleteFavorite = ?"
        let db = getDB()
        var ret = [VideoHistoryItem]()
        if db.open(){
            let result = db.executeQuery(sql, withArgumentsInArray: [VideoInfoUtils.FAVORITE_YES,VideoInfoUtils.DELETE_FAVORITE_NO])
            ret = getVideoList(result)
            db.close()
        }
        return ret
    }
    
    func updateFavorite(videoDetailInfo: VideoDetailInfo){
        if getItem(videoDetailInfo) {
            updateHistory(videoDetailInfo)
        }else{
            saveHistory(videoDetailInfo)
        }
    }
    
    func getHistoryItem(videoId: String) -> VideoHistoryItem?{
        let sql = "select * from " + TABLE_VIDEO_INFO + " where videoId = ?"
        let db = getDB()
        if db.open() {
            let result = db.executeQuery(sql, withArgumentsInArray: [videoId])
            if result == nil {
                db.close()
                return nil
            }
            if result.next() {
                let ret = obtainHistoryItem(result)
                db.close()
                return ret
            }
        }
        return nil
    }
    
    
    
}
