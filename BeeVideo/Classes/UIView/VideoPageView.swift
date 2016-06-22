//
//  VideoPageView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/4.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoPageView: BasePageView,BlockViewDelegate {
    
    private var block_category1 : BlockView!
    private var block_category2 : BlockView!
    private var block_category3 : BlockView!
    private var block_poster1 : BlockView!
    private var block_poster2 : BlockView!
    private var block_poster3 : BlockView!
    private var block_poster4 : BlockView!
    private var block_poster5 : BlockView!
    private var block_poster6 : BlockView!
    private var block_poster7 : BlockView!
    
    override func initView(){
        super.initView()
        
        for index in 0 ..< 3 {
            let blockView = BlockView()
            // blockView.initFrame(0, y: CGFloat(73 * index), width: 65, height: 65)
            //print(height)
            blockView.frame = CGRectMake(0, height * 0.34 * CGFloat(index), height * 0.32, height * 0.32)
            blockView.setData(super.homeSpace[index])
            blockView.setDelegate(self)
            addSubview(blockView)
        }
        
        let blockLarge = BlockView()
        //blockLarge.initFrame(70, y: 0, width: 120, height: 210)
        blockLarge.frame = CGRectMake(height * 0.32 + 5.0, 0, height * 4/7, height)
        blockLarge.setData(super.homeSpace[3])
        blockLarge.setDelegate(self)
        addSubview(blockLarge)
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            //blockView.initFrame(195, y: CGFloat(110 * index), width: 150, height: 100)
            blockView.frame = CGRectMake(height * 0.32 + height * 4/7 + 10, height * 0.52 * CGFloat(index), height * 0.48 * 1.5, height * 0.48)
            blockView.setData(super.homeSpace[index + 4])
            blockView.setBlockViewMode(.Right)
            blockView.setDelegate(self)
            addSubview(blockView)
        }
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            // blockView.initFrame(350, y: CGFloat(110 * index), width: 100, height: 100)
            blockView.frame = CGRectMake(height * (1.04 + 4/7) + 15, height * 0.52 * CGFloat(index), height * 0.48, height * 0.48)
            blockView.setData(super.homeSpace[index + 6])
            blockView.setDelegate(self)
            addSubview(blockView)
        }
        
        for index in 0 ..< 2 {
            let blockView = BlockView()
            // blockView.initFrame(455, y: CGFloat(110 * index), width: 100, height: 100)
            blockView.frame = CGRectMake(height * (1.52 + 4/7) + 20, height * 0.52 * CGFloat(index), height * 0.48, height * 0.48)
            blockView.setData(super.homeSpace[index + 8])
            blockView.setDelegate(self)
            addSubview(blockView)
        }
        
    }
    
    func blockClick(homeSpace: HomeSpace) {
        let action = homeSpace.items[0].action
        
        let extras : [ExtraData] = homeSpace.items[0].extras
        if action == "com.mipt.videohj.intent.action.VOD_CompositeStdiuoUI_ACTION" {
            let vodcate = VodVideoController()
            vodcate.channelId = extras[0].value
            self.viewController.presentViewController(vodcate, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let specialController = VideoCategoryController()
            specialController.extras = extras
            self.viewController.presentViewController(specialController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.VOD_HD_ACTION"{
            let hdController = VideoHDCategoryController()
            self.viewController.presentViewController(hdController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.VIDEO_CATEGORY_GROUP"{
            let groupController = VideoCategoryGroupController()
            self.viewController.presentViewController(groupController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.REST_VOD_VIDEO"{
            let restVideoController = RestVideoViewController()
            self.viewController.presentViewController(restVideoController, animated: true, completion: nil)
        }
    }
    
    override func getViewWidth() -> CGFloat {
        return height * (2 + 4/7) + 70
    }
}
