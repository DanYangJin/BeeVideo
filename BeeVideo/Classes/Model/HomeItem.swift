//
//  HomeItem.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/22.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class HomeItem {
    internal var tableName:String!
    internal var name:String!
    internal var icon:String!
    internal var type:Int!
    internal var content:String!
    internal var action:String!
    internal var category:String!
    internal var extras:[ExtraData]!
    internal var position:Int!
    
    init(){
        extras = Array()
    }
    
    
    init(tableName:String, name:String, icon:String, type:Int, content:String, action:String, category:String, extras:[ExtraData], position:Int){
        self.tableName = tableName
        self.name = name
        self.icon = icon
        self.type = type
        self.content = content
        self.action = action
        self.category = category
        self.extras = extras
        self.position = position
    }
    
}
