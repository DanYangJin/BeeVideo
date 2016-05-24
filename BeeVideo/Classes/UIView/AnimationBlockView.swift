//
//  AnimationBlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class AnimationBlockView: BlockView {
    
    

    override func initView(homeSpace: HomeSpace) {
        //setFrame()
        self.homeSpace = homeSpace
        initImage(homeSpace.items[0].icon)
    }
    
    
}
