//
//  VideoInfoUtils.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/22.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoInfoUtils: NSObject {

    ///是否删除收藏
    static let DELETE_FAVORITE_NO = 0
    static let DELETE_FAVORITE_YES = 1
    ///是否删除历史
    static let DELETE_TRACE_NO = 0
    static let DELETE_TRACE_YES = 1
    ///是否有更新
    static let VIDEO_NO_UPDATE = 0
    static let VIDEO_HAS_UPDATE = 1
    ///是否收藏
    static let FAVORITE_NO = 0
    static let FAVORITE_YES = 1
    ///视频剧集排列方式
    static let DRAMA_ORDER_SEQUENCE = 0 //顺
    static let DRAMA_ORDER_REVERS = 1 //逆
    
    static let VIDEO_CHOOSE_DRAMA_THRESHOLD = 1
    
    /**
     * 视频详情页操作选项的ID
     */
    static let OP_POSITION_PLAY = 0;
    static let OP_POSITION_CHOOSE = 1;
    static let OP_POSITION_DOWNLOAD = 2;
    static let OP_POSITION_FAV = 3;
    
    //选集弹框每次显示的集数
    static let GRID_ITEM_COUNT = 20
    
    
    static func isVideoFavorited(favorited: Int? = 0) -> Bool{
        if favorited == FAVORITE_YES {
            return true
        }
        return false
    }
    //判断是否需要选集
    static func isChooseDramaNeeded(detailInfo: VideoDetailInfo) -> Bool{
        let dramas = detailInfo.dramas
        if dramas.isEmpty {
            return false
        }
        
        return dramas.count > VIDEO_CHOOSE_DRAMA_THRESHOLD
    }
    
    static func getDramaReadablePosition(dramaOrderFlag: Int,dramaTotalSize: Int, index: Int) -> Int{
        if dramaOrderFlag == DRAMA_ORDER_SEQUENCE{
            return (index + 1)
        }else{
            return dramaTotalSize - index
        }
    }
    
    static func chooseImageWithFavorite(isFavorited: Bool) -> String{
        return isFavorited ? "v2_my_video_like_bg_favorited" : "v2_my_video_like_bg_normal"
    }
    
    static func refreshWatchRecord(detailInfo: VideoDetailInfo){
        let item:VideoHistoryItem? = VideoDBHelper.shareInstance().getHistoryItem(detailInfo.id)
        if item == nil {
            detailInfo.setLastPlayDramaPosition(0)
        }else{
            if item?.deleteFavorite == DELETE_FAVORITE_NO {
                detailInfo.isFavorite = (item?.isFavorited)!
            }
            if item?.deleteTrace == DELETE_TRACE_NO {
                detailInfo.setLastPlayDramaPosition(item!.playedDrama)
                detailInfo.dramaPlayedDuration = item!.playedDuration
                detailInfo.currentDrama?.setCurrentUsedSourcePosition(VideoInfoUtils.getSourcePositionBySourceId(detailInfo, sourceId: item!.sourceId))
            }else{
                detailInfo.setLastPlayDramaPosition(0)
            }
        }
        
    }
    
    static func getSourcePositionBySourceId(detailInfo: VideoDetailInfo, sourceId:String) -> Int{
        
        var position = 0
        if sourceId.isEmpty {
            return position
        }
        
        let list = detailInfo.currentDrama?.sources
        if list == nil || list!.isEmpty {
            return position
        }
        
        var index = 0
        for item in list! {
            if item.id == sourceId {
                position = index
                break
            }
            index += 1
        }
        if index >= list!.count {
            position = 0
        }
    
        return position
    }
    
    static func getDramaReadablePositon(dramaOrderFlag: Int,dramaTotalSize: Int,index: Int) -> Int{
        if dramaOrderFlag == DRAMA_ORDER_SEQUENCE {
            return index + 1
        } else {
            return dramaTotalSize - index
        }
    
    }
    
}














