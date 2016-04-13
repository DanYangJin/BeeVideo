//
//  VideoSourceInfo.swift
//  SwiftTest
//
//  Created by JinZhang on 16/4/12.
//  Copyright © 2016年 金璋. All rights reserved.
//

import UIKit

class VideoSourceInfo {
    
    var id : String = String()
    var metaId : String = String()//response 中的videoMetaId
    var name : String  = String()
    var sourceThhumbail : String = String()//标识源的图片 对应 logo
    var metaDuration : String = String() // meta_duration
    var resolutionType : Int = 0 // 清晰度，对应 most
    var playPointAmount : Int = 0 //播放所需要的积分数  playpoint
    var downloadPointAmount : Int = 0 //下载需要的积分数 downloadpoint
    var isPlayPurchased : Bool = false //是否已经购买播放 playPurchaseStatus
    var isDownloadPurchased : Bool = false //是否已经购买下载  downloadPurchaseStatus
    var childSourceId : Int = 0  //子id，用来配合id一起获取解析用的正则表达式  otherSource
    var played : Bool = false // 记住该源是否已经尝试过，在轮询源的时候使用
    var source : Source?//视频源信息
    

}
