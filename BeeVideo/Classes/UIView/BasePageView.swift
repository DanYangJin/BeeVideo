//
//  BasePageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class BasePageView: UIView {

    internal var homeSpace:[HomeSpace]!
    
    func initView(){
       initData()
    }
    
    func getViewWidth() -> CGFloat {
        return 0
    }
    
    func setData(homeSpace:[HomeSpace]?){
        self.homeSpace = homeSpace
        for var i = 0; i < homeSpace!.count; i++ {
            let homeItem:HomeSpace = homeSpace![i]
            for var j = 0; j < homeItem.items.count; j++ {
                print("#####\(homeItem.position)######\(homeItem.items[j].name)")
            }
        }
    }

    func initData(){
        
    }
}
