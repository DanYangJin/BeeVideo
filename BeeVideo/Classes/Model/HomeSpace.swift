//
//  HomeSpace.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/22.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class HomeSpace {

    internal var tableName:String!
    internal var position:Int!
    internal var items:[HomeItem]!
    
    init(){
        items = Array()
    }
    
    init(tableName:String, position:Int, items:[HomeItem]){
        self.tableName = tableName
        self.position = position
        self.items = items
    }
    
}
