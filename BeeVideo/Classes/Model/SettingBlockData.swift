//
//  SettingBlockData.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/2.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class SettingBlockData: NSObject {

    var targetController:UIViewController?
    var title:String
    var icon:String
    var backgroundImg:String
    
    init(title:String, icon:String, backgroundImg:String, targetController:UIViewController?) {
        self.title = title
        self.icon = icon
        self.backgroundImg = backgroundImg
        self.targetController = targetController
    }
    
}
