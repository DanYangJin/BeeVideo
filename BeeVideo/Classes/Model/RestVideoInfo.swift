//
//  RestVideoInfo.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/1.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class RestVideoInfo {

    var id:String = ""
    var title:String = ""
    var position:Int = -1
    var iconUrl:String = ""
    var type = Int.min
    var intentInfo:IntentInfo!
    
    internal class IntentInfo{
        var action:String = ""
        var data:String = ""
        var category:String = ""
        var type:String = ""
        var extras:Array<ExtraData> = Array<ExtraData>()
    }
}
