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
        initUI()
        
    }
    
    func initUI(){
        block_category1 = BlockView()
        setBlockViewCommen(block_category1, index: 0)
        
        block_category2 = BlockView()
        setBlockViewCommen(block_category2, index: 1)
        
        block_category3 = BlockView()
        setBlockViewCommen(block_category3, index: 2)
        
        block_poster1 = BlockView()
        block_poster1.setBlockViewMode(.Right)
        setBlockViewCommen(block_poster1, index: 3)
        
        block_poster2 = BlockView()
        block_poster2.setBlockViewMode(.Right)
        setBlockViewCommen(block_poster2, index: 4)
        
        block_poster3 = BlockView()
        block_poster3.setBlockViewMode(.Right)
        setBlockViewCommen(block_poster3, index: 5)
        
        block_poster4 = BlockView()
        setBlockViewCommen(block_poster4, index: 6)
        block_poster5 = BlockView()
        
        setBlockViewCommen(block_poster5, index: 7)
        block_poster6 = BlockView()
        setBlockViewCommen(block_poster6, index: 8)
        
        block_poster7 = BlockView()
        setBlockViewCommen(block_poster7, index: 9)
        
        block_category1.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self.snp_height).multipliedBy(0.32)
            make.width.equalTo(self.snp_height).multipliedBy(0.32)
        }
        
        block_category2.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.height.width.equalTo(block_category1)
        }
        
        block_category3.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.height.width.equalTo(block_category1)
        }
        
        block_poster1.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(block_category2.snp_right).offset(height * 0.02)
            make.width.equalTo(self.snp_height).multipliedBy( 0.58 )
        }
        
        block_poster2.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(block_poster1.snp_right).offset(height * 0.02)
            make.height.equalTo(self.snp_height).multipliedBy(0.49)
            make.width.equalTo(self.snp_height).multipliedBy(0.49 * 1.5)
        }

        block_poster3.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(block_poster2)
            make.height.equalTo(block_poster2)
            make.width.equalTo(block_poster2)
        }
        
        block_poster4.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(block_poster2.snp_right).offset(height * 0.02)
            make.height.equalTo(block_poster2)
            make.width.equalTo(block_poster2.snp_height)
        }
        
        block_poster5.snp_makeConstraints { (make) in
            make.left.equalTo(block_poster4)
            make.bottom.equalTo(self)
            make.width.equalTo(block_poster4)
            make.height.equalTo(block_poster4)
        }
        
        block_poster6.snp_makeConstraints { (make) in
            make.left.equalTo(block_poster4.snp_right).offset(height * 0.02)
            make.top.equalTo(self)
            make.height.equalTo(block_poster4)
            make.width.equalTo(block_poster4)
        }
        
        block_poster7.snp_makeConstraints { (make) in
            make.left.equalTo(block_poster6)
            make.bottom.equalTo(self)
            make.height.equalTo(block_poster4)
            make.width.equalTo(block_poster4)
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
    
    func setBlockViewCommen(view:BlockView, index: Int){
        view.setData(homeSpace[index])
        view.setDelegate(self)
        self.addSubview(view)
    }
    
    override func getViewWidth() -> CGFloat {
        return height * 3
    }
}
