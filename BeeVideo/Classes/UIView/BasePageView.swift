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
    internal var viewController:ViewController!
    
    func initView(){
       initData()
    }
    
    func setController(viewController:ViewController){
       self.viewController = viewController
    }
    
    func getViewWidth() -> CGFloat {
        return 0
    }
    
    func setData(homeSpace:[HomeSpace]?){
        self.homeSpace = homeSpace
    }

    func initData(){
        
    }
    
    
}
