//
//  SettingPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SettingPageView: BasePageView {

    private var cycleImage:UIImageView!
    
    private var netCheckSetting : SettingBlockView!
    private var moreSetting : SettingBlockView!
    private var accountSetting : SettingBlockView!
    private var playSetting : SettingBlockView!
    private var recommendSetting : SettingBlockView!
    private var wxShare : SettingBlockView!
    
    private var aboutView : AboutView!
    
    override func initView(){
        super.initView()
        backgroundColor = UIColor.greenColor()
        
        playSetting = SettingBlockView(frame: CGRectMake(0, 0, 100, 100))
        playSetting.setInco(UIImage(named: "v2_setting_player_icon")!)
        playSetting.setTitle("播放设置")
        playSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_green_bg")!)
        addSubview(playSetting)
        
        wxShare = SettingBlockView(frame: CGRectMake(110, 0, 100, 100))
        wxShare.setInco(UIImage(named: "v2_setting_weixin_icon")!)
        wxShare.setTitle("微信分享")
        wxShare.setBackgroundImg(UIImage(named: "v2_laucher_block_purple_bg")!)
        addSubview(wxShare)
        
        recommendSetting = SettingBlockView(frame: CGRectMake(220, 0, 100, 100))
        recommendSetting.setTitle("应用推荐")
        recommendSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_blue_bg")!)
        recommendSetting.setInco(UIImage(named: "v2_setting_app_icon")!)
        addSubview(recommendSetting)
        
        netCheckSetting = SettingBlockView(frame: CGRectMake(0, 110, 100, 100))
        netCheckSetting.setTitle("网络诊断")
        netCheckSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_blue_bg")!)
        netCheckSetting.setInco(UIImage(named: "v2_setting_network_check")!)
        addSubview(netCheckSetting)
        
        accountSetting = SettingBlockView(frame: CGRectMake(110, 110, 100, 100))
        accountSetting.setTitle("账户")
        accountSetting.setInco(UIImage(named: "v2_setting_acount_icon")!)
        accountSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_orange_bg")!)
        addSubview(accountSetting)
        
        moreSetting = SettingBlockView(frame: CGRectMake(220, 110, 100, 100))
        moreSetting.setTitle("更多设置")
        moreSetting.setInco(UIImage(named: "v2_setting_more_icon")!)
        moreSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_green_bg")!)
        addSubview(moreSetting)
        
        aboutView = AboutView(frame: CGRectMake(335, 0, 160, 210))
        addSubview(aboutView)
        
    }
    
    
    override func getViewWidth() -> CGFloat {
        return 600
    }

}
