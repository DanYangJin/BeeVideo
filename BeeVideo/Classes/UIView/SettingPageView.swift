//
//  SettingPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SettingPageView: BasePageView,SettingBlockViewClickDelegate {

    private var cycleImage:UIImageView!
    
    private var multiControllerSettingBlock : SettingBlockView!
    private var moreSettingBlock : SettingBlockView!
    private var accountSettingBlock : SettingBlockView!
    private var playSettingBlock : SettingBlockView!
    private var recommendSettingBlock : SettingBlockView!
    private var wxShareBlock : SettingBlockView!
    
    private var aboutView : AboutView!
    
    override func initView(){
        super.initView()
        
        playSettingBlock = SettingBlockView()
        let playSettingData = SettingBlockData(title: "播放设置", icon: "v2_setting_player_icon", backgroundImg: "v2_laucher_block_green_bg", targetController: PlaySettingViewController())
        playSettingBlock.setData(playSettingData)
        playSettingBlock.clickDelegate = self
        addSubview(playSettingBlock)
        playSettingBlock.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(self.snp_height).multipliedBy(0.49)
        }
        
        multiControllerSettingBlock = SettingBlockView()
        let mutiSettingData = SettingBlockData(title: "多屏互动", icon: "v2_setting_multi_control", backgroundImg: "v2_laucher_block_purple_bg", targetController: nil)
        multiControllerSettingBlock.setData(mutiSettingData)
        multiControllerSettingBlock.clickDelegate = self
        addSubview(multiControllerSettingBlock)
        multiControllerSettingBlock.snp_makeConstraints { (make) in
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(playSettingBlock)
            make.left.equalTo(playSettingBlock.snp_right).offset(height * 0.02)
            make.width.equalTo(playSettingBlock)
        }
        
        
        recommendSettingBlock = SettingBlockView()
        let recommendSettingData = SettingBlockData(title: "应用推荐", icon: "v2_setting_app_icon", backgroundImg: "v2_laucher_block_blue_bg", targetController: AppRecommendViewController())
        recommendSettingBlock.setData(recommendSettingData)
        recommendSettingBlock.clickDelegate = self
        addSubview(recommendSettingBlock)
        recommendSettingBlock.snp_makeConstraints { (make) in
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(playSettingBlock)
            make.left.equalTo(multiControllerSettingBlock.snp_right).offset(height * 0.02)
            make.width.equalTo(playSettingBlock)
        }
        
        wxShareBlock = SettingBlockView()
        let wxShareData = SettingBlockData(title: "微信分享", icon: "v2_setting_network_check", backgroundImg: "v2_laucher_block_blue_bg", targetController: nil)
        wxShareBlock.setData(wxShareData)
        wxShareBlock.clickDelegate = self
        addSubview(wxShareBlock)
        wxShareBlock.snp_makeConstraints { (make) in
            make.left.right.equalTo(playSettingBlock)
            make.top.equalTo(playSettingBlock.snp_bottom).offset(height * 0.02)
            make.height.equalTo(playSettingBlock)
        }
        
        accountSettingBlock = SettingBlockView()
        let accountSettingData = SettingBlockData(title: "账户", icon: "v2_setting_acount_icon", backgroundImg: "v2_laucher_block_orange_bg", targetController: nil)
        accountSettingBlock.setData(accountSettingData)
        accountSettingBlock.clickDelegate = self
        addSubview(accountSettingBlock)
        accountSettingBlock.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(wxShareBlock)
            make.right.left.equalTo(multiControllerSettingBlock)
        }
        
        moreSettingBlock = SettingBlockView()
        let moreSettingData = SettingBlockData(title: "更多设置", icon: "v2_setting_more_icon", backgroundImg: "v2_laucher_block_green_bg", targetController: RestSettingViewController())
        moreSettingBlock.setData(moreSettingData)
        moreSettingBlock.clickDelegate = self
        addSubview(moreSettingBlock)
        moreSettingBlock.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(accountSettingBlock)
            make.left.equalTo(recommendSettingBlock)
            make.width.equalTo(recommendSettingBlock)
        }
        
        aboutView = AboutView()
        addSubview(aboutView)
        aboutView.snp_makeConstraints { (make) in
            make.left.equalTo(moreSettingBlock.snp_right).offset(height * 0.02)
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(moreSettingBlock)
            make.width.equalTo(height * 5/7)
        }
        
    }
    
    func settingBlockViewClick(settingData: SettingBlockData) {
        let controller = settingData.targetController
        if controller == nil {
            return
        }
        viewController.presentViewController(controller!, animated: true, completion: nil)
    }
    
    
    override func getViewWidth() -> CGFloat {
        return height * (1.5 + 5/7) + 30
    }

}
