//
//  VodFiltrateCategory.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

enum FiltType {
    case YEAR
    case AREA
    case ORDER
    case CATEGORY
    case UNKNOW
}


class VodFiltrateCategory: NSObject {
    
    static let ID_VOD_FILTRATE_ALL = INT32_MAX
    static let ID_VOD_FILTRATE_LAST_UPDATE = -10 //最新
    static let ID_VOD_FILTRATE_MOST_POPULE = -11 //最热
    
    var type:FiltType = FiltType.UNKNOW
    var id = 0;
    var name = ""
    
    override init() {
        super.init()
    }
    
    init(filt:VodFiltrateCategory){
        self.type = filt.type
        self.id = filt.id
        self.name = filt.name
    }

}
