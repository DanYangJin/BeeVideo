//
//  LeftViewTableData.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/30.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
  周热播，我的影视等页面左侧菜单数据
 */

class LeftViewTableData {

    var title:String = ""
    var unSelectPic:String = ""
    var selectedPic:String = ""
    
    init(title:String,unSelectPic:String,selectedPic:String){
        self.title = title
        self.unSelectPic = unSelectPic
        self.selectedPic = selectedPic
    }
    
}
