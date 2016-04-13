//
//  VideoPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoPageView: BasePageView {
    
    override func initView(){
        super.initView()
        backgroundColor = UIColor.yellowColor()
        
        for index in 0 ..< 3 {
            let blockView = BlockView()
            blockView.initFrame(0, y: CGFloat(73 * index), width: 65, height: 65)
            blockView.initView(super.homeSpace[index])
        
            addSubview(blockView)
        }
        
        let blockLarge = BlockView()
        blockLarge.initFrame(70, y: 0, width: 120, height: 210)
        blockLarge.initView(super.homeSpace[3])
        addSubview(blockLarge)
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            blockView.initFrame(195, y: CGFloat(110 * index), width: 150, height: 100)
            blockView.initView(super.homeSpace[index + 4])
            
            addSubview(blockView)
        }
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            blockView.initFrame(350, y: CGFloat(110 * index), width: 100, height: 100)
            blockView.initView(super.homeSpace[index + 6])
            
            addSubview(blockView)
        }
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            blockView.initFrame(455, y: CGFloat(110 * index), width: 100, height: 100)
            blockView.initView(super.homeSpace[index + 8])
            
            addSubview(blockView)
        }
        
    }
    
    override func getViewWidth() -> CGFloat {
        return 555
    }

}
