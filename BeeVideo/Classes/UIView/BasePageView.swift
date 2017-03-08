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
    internal weak var viewController:UIViewController!
    internal var height:CGFloat!
    
    func initView(){
       initData()
    }
    
    func setController(_ viewController:UIViewController){
       self.viewController = viewController
    }
    
    func getViewWidth() -> CGFloat {
        return 0
    }
    
    func setData(_ homeSpace:[HomeSpace]?){
        self.homeSpace = homeSpace
    }

    func initData(){
        
    }
    
    
}
