//
//  Drama.swift
//  SwiftTest
//
//  Created by JinZhang on 16/4/13.
//  Copyright © 2016年 金璋. All rights reserved.
//

import UIKit

class Drama {
    var id : String = ""
    var title : String = ""//剧集名称  对应name
    var playedDuration : Int = 0//已播放时长
    var downloadStatus : DownloadStatus = DownloadStatus.NORMAL //下载状态
    var lastWatched : Bool = false //是否为最后一次观看，针对有多集的情况
    var sources : [Source] = [Source]() //每一集的源信息
    var currentUsedSourcePosition : Int = 0 //当前使用源的位置
    var currentUsedSourceInfo : VideoSourceInfo? //正在使用的源
}



public enum DownloadStatus : Int{
    case NORMAL = 0
    case SELECTED = 1
    case DOWNLOADING = 2
    case DOWNLOADED = 3
}