//
//  VideoPageView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/4.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoPageView: BasePageView,BlockViewDelegate {
    
    fileprivate var block_category1 : BlockView!
    fileprivate var block_category2 : BlockView!
    fileprivate var block_category3 : BlockView!
    fileprivate var block_poster1 : BlockView!
    fileprivate var block_poster2 : BlockView!
    fileprivate var block_poster3 : BlockView!
    fileprivate var block_poster4 : BlockView!
    fileprivate var block_poster5 : BlockView!
    fileprivate var block_poster6 : BlockView!
    fileprivate var block_poster7 : BlockView!
    
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
        block_poster1.setBlockViewMode(.right)
        setBlockViewCommen(block_poster1, index: 3)
        
        block_poster2 = BlockView()
        block_poster2.setBlockViewMode(.right)
        setBlockViewCommen(block_poster2, index: 4)
        
        block_poster3 = BlockView()
        block_poster3.setBlockViewMode(.right)
        setBlockViewCommen(block_poster3, index: 5)
        
        block_poster4 = BlockView()
        setBlockViewCommen(block_poster4, index: 6)
        block_poster5 = BlockView()
        
        setBlockViewCommen(block_poster5, index: 7)
        block_poster6 = BlockView()
        setBlockViewCommen(block_poster6, index: 8)
        
        block_poster7 = BlockView()
        setBlockViewCommen(block_poster7, index: 9)
        
        block_category1.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self.snp.height).multipliedBy(0.32)
            make.width.equalTo(self.snp.height).multipliedBy(0.32)
        }
        
        block_category2.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.height.width.equalTo(block_category1)
        }
        
        block_category3.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.height.width.equalTo(block_category1)
        }
        
        block_poster1.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(block_category2.snp.right).offset(height * 0.02)
            make.width.equalTo(self.snp.height).multipliedBy( 0.58 )
        }
        
        block_poster2.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(block_poster1.snp.right).offset(height * 0.02)
            make.height.equalTo(self.snp.height).multipliedBy(0.49)
            make.width.equalTo(self.snp.height).multipliedBy(0.49 * 1.5)
        }

        block_poster3.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(block_poster2)
            make.height.equalTo(block_poster2)
            make.width.equalTo(block_poster2)
        }
        
        block_poster4.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(block_poster2.snp.right).offset(height * 0.02)
            make.height.equalTo(block_poster2)
            make.width.equalTo(block_poster2.snp.height)
        }
        
        block_poster5.snp.makeConstraints { (make) in
            make.left.equalTo(block_poster4)
            make.bottom.equalTo(self)
            make.width.equalTo(block_poster4)
            make.height.equalTo(block_poster4)
        }
        
        block_poster6.snp.makeConstraints { (make) in
            make.left.equalTo(block_poster4.snp.right).offset(height * 0.02)
            make.top.equalTo(self)
            make.height.equalTo(block_poster4)
            make.width.equalTo(block_poster4)
        }
        
        block_poster7.snp.makeConstraints { (make) in
            make.left.equalTo(block_poster6)
            make.bottom.equalTo(self)
            make.height.equalTo(block_poster4)
            make.width.equalTo(block_poster4)
        }
        
        
    }
    
    func blockClick(_ homeSpace: HomeSpace) {
        let action = homeSpace.items[0].action
        
        let extras : [ExtraData] = homeSpace.items[0].extras
        if action == "com.mipt.videohj.intent.action.VOD_CompositeStdiuoUI_ACTION" {
            let vodcate = VodVideoController()
            vodcate.channelId = extras[0].value
            self.viewController.present(vodcate, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.SPECIAL_DETAIL"{
            let specialController = VideoCategoryController()
            specialController.extras = extras
            self.viewController.present(specialController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.VOD_HD_ACTION"{
            let hdController = VideoHDCategoryController()
            self.viewController.present(hdController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.VIDEO_CATEGORY_GROUP"{
            let groupController = VideoCategoryGroupController()
            self.viewController.present(groupController, animated: true, completion: nil)
        }else if action == "com.mipt.videohj.intent.action.REST_VOD_VIDEO"{
            let restVideoController = RestVideoViewController()
            self.viewController.present(restVideoController, animated: true, completion: nil)
        }
    }
    
    func setBlockViewCommen(_ view:BlockView, index: Int){
        view.setData(homeSpace[index])
        view.setDelegate(self)
        self.addSubview(view)
    }
    
    override func getViewWidth() -> CGFloat {
        return height * 3
    }
}
