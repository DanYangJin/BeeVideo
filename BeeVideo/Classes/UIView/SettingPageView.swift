//
//  SettingPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SettingPageView: BasePageView,SettingBlockViewClickDelegate {

    fileprivate var cycleImage:UIImageView!
    
    fileprivate var multiControllerSettingBlock : SettingBlockView!
    fileprivate var moreSettingBlock : SettingBlockView!
    fileprivate var accountSettingBlock : SettingBlockView!
    fileprivate var playSettingBlock : SettingBlockView!
    fileprivate var recommendSettingBlock : SettingBlockView!
    fileprivate var wxShareBlock : SettingBlockView!
    
    fileprivate var aboutView : AboutView!
    
    fileprivate let PLAY_SETTING_CONTROLLER = "playSetting"
    fileprivate let APP_RECOMMEND_CONTROLLER = "appRecommend"
    fileprivate let ACCOUNT_CONTROLLER = "account"
    fileprivate let REST_SETTING_CONTROLLER = "restSetting"
    
    override func initView(){
        super.initView()
        
        playSettingBlock = SettingBlockView()
        let playSettingData = SettingBlockData(title: "播放设置", icon: "v2_setting_player_icon", backgroundImg: "v2_laucher_block_green_bg", targetController: PLAY_SETTING_CONTROLLER)
        playSettingBlock.setData(playSettingData)
        playSettingBlock.clickDelegate = self
        addSubview(playSettingBlock)
        playSettingBlock.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(self.snp.height).multipliedBy(0.49)
        }
        
        multiControllerSettingBlock = SettingBlockView()
        let mutiSettingData = SettingBlockData(title: "多屏互动", icon: "v2_setting_multi_control", backgroundImg: "v2_laucher_block_purple_bg", targetController: "")
        multiControllerSettingBlock.setData(mutiSettingData)
        multiControllerSettingBlock.clickDelegate = self
        addSubview(multiControllerSettingBlock)
        multiControllerSettingBlock.snp.makeConstraints { (make) in
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(playSettingBlock)
            make.left.equalTo(playSettingBlock.snp.right).offset(height * 0.02)
            make.width.equalTo(playSettingBlock)
        }
        
        
        recommendSettingBlock = SettingBlockView()
        let recommendSettingData = SettingBlockData(title: "应用推荐", icon: "v2_setting_app_icon", backgroundImg: "v2_laucher_block_blue_bg", targetController: APP_RECOMMEND_CONTROLLER)
        recommendSettingBlock.setData(recommendSettingData)
        recommendSettingBlock.clickDelegate = self
        addSubview(recommendSettingBlock)
        recommendSettingBlock.snp.makeConstraints { (make) in
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(playSettingBlock)
            make.left.equalTo(multiControllerSettingBlock.snp.right).offset(height * 0.02)
            make.width.equalTo(playSettingBlock)
        }
        
        wxShareBlock = SettingBlockView()
        let wxShareData = SettingBlockData(title: "微信分享", icon: "v2_setting_network_check", backgroundImg: "v2_laucher_block_blue_bg", targetController: "")
        wxShareBlock.setData(wxShareData)
        wxShareBlock.clickDelegate = self
        addSubview(wxShareBlock)
        wxShareBlock.snp.makeConstraints { (make) in
            make.left.right.equalTo(playSettingBlock)
            make.top.equalTo(playSettingBlock.snp.bottom).offset(height * 0.02)
            make.height.equalTo(playSettingBlock)
        }
        
        accountSettingBlock = SettingBlockView()
        let accountSettingData = SettingBlockData(title: "账户", icon: "v2_setting_acount_icon", backgroundImg: "v2_laucher_block_orange_bg", targetController: ACCOUNT_CONTROLLER)
        accountSettingBlock.setData(accountSettingData)
        accountSettingBlock.clickDelegate = self
        addSubview(accountSettingBlock)
        accountSettingBlock.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(wxShareBlock)
            make.right.left.equalTo(multiControllerSettingBlock)
        }
        
        moreSettingBlock = SettingBlockView()
        let moreSettingData = SettingBlockData(title: "更多设置", icon: "v2_setting_more_icon", backgroundImg: "v2_laucher_block_green_bg", targetController: REST_SETTING_CONTROLLER)
        moreSettingBlock.setData(moreSettingData)
        moreSettingBlock.clickDelegate = self
        addSubview(moreSettingBlock)
        moreSettingBlock.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(accountSettingBlock)
            make.left.equalTo(recommendSettingBlock)
            make.width.equalTo(recommendSettingBlock)
        }
        
        aboutView = AboutView()
        addSubview(aboutView)
        aboutView.snp.makeConstraints { (make) in
            make.left.equalTo(moreSettingBlock.snp.right).offset(height * 0.02)
            make.top.equalTo(playSettingBlock)
            make.bottom.equalTo(moreSettingBlock)
            make.width.equalTo(height * 5/7)
        }
        
    }
    
    func settingBlockViewClick(_ settingData: SettingBlockData) {
        var controller:UIViewController?
        switch settingData.targetController {
        case PLAY_SETTING_CONTROLLER:
            controller = PlaySettingViewController()
            break
        case ACCOUNT_CONTROLLER:
            controller = AccountViewController()
            break
        case APP_RECOMMEND_CONTROLLER:
            controller = AppRecommendViewController()
            break
        case REST_SETTING_CONTROLLER:
            controller = RestVideoViewController()
            break
        default:
            
            break
        }
        
        if controller == nil {
            return
        }
        
        viewController.present(controller!, animated: true, completion: nil)
    }
    
    
    override func getViewWidth() -> CGFloat {
        return height * (1.5 + 5/7) + 30
    }

}
