//
//  LivePageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class LivePageView: BasePageView {

    private var cycleImage:UIImageView!
    
    override func initView(){
        super.initView()
        cycleImage = UIImageView()
        cycleImage.frame = CGRectMake(0, 0, 220, 150)
        cycleImage.image = UIImage(named: "girl")
        addSubview(cycleImage)
        
    }
    
    override func getViewWidth() -> CGFloat {
        return 1000
    }
    

}
