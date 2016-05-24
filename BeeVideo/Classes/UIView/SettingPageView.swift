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
        
        playSetting = SettingBlockView()//frame: CGRectMake(0, 0, 100, 100))
        playSetting.setInco(UIImage(named: "v2_setting_player_icon")!)
        playSetting.setTitle("播放设置")
        playSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_green_bg")!)
        addSubview(playSetting)
        playSetting.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(height * 0.49)
        }
        
        wxShare = SettingBlockView()//frame: CGRectMake(110, 0, 100, 100))
        wxShare.setInco(UIImage(named: "v2_setting_weixin_icon")!)
        wxShare.setTitle("微信分享")
        wxShare.setBackgroundImg(UIImage(named: "v2_laucher_block_purple_bg")!)
        addSubview(wxShare)
        wxShare.snp_makeConstraints { (make) in
            make.top.equalTo(playSetting)
            make.bottom.equalTo(playSetting)
            make.left.equalTo(playSetting.snp_right).offset(height * 0.02)
            make.width.equalTo(playSetting)
        }
        
        
        recommendSetting = SettingBlockView()//frame: CGRectMake(220, 0, 100, 100))
        recommendSetting.setTitle("应用推荐")
        recommendSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_blue_bg")!)
        recommendSetting.setInco(UIImage(named: "v2_setting_app_icon")!)
        addSubview(recommendSetting)
        recommendSetting.snp_makeConstraints { (make) in
            make.top.equalTo(playSetting)
            make.bottom.equalTo(playSetting)
            make.left.equalTo(wxShare.snp_right).offset(height * 0.02)
            make.width.equalTo(playSetting)
        }
        
        netCheckSetting = SettingBlockView()//frame: CGRectMake(0, 110, 100, 100))
        netCheckSetting.setTitle("网络诊断")
        netCheckSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_blue_bg")!)
        netCheckSetting.setInco(UIImage(named: "v2_setting_network_check")!)
        addSubview(netCheckSetting)
        netCheckSetting.snp_makeConstraints { (make) in
            make.left.right.equalTo(playSetting)
            make.top.equalTo(playSetting.snp_bottom).offset(height * 0.02)
            make.height.equalTo(playSetting)
        }
        
        accountSetting = SettingBlockView()//frame: CGRectMake(110, 110, 100, 100))
        accountSetting.setTitle("账户")
        accountSetting.setInco(UIImage(named: "v2_setting_acount_icon")!)
        accountSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_orange_bg")!)
        addSubview(accountSetting)
        accountSetting.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(netCheckSetting)
            make.right.left.equalTo(wxShare)
        }
        
        moreSetting = SettingBlockView()//frame: CGRectMake(220, 110, 100, 100))
        moreSetting.setTitle("更多设置")
        moreSetting.setInco(UIImage(named: "v2_setting_more_icon")!)
        moreSetting.setBackgroundImg(UIImage(named: "v2_laucher_block_green_bg")!)
        addSubview(moreSetting)
        moreSetting.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(accountSetting)
            make.left.equalTo(recommendSetting)
            make.width.equalTo(recommendSetting)
        }
        
        aboutView = AboutView()//frame: CGRectMake(335, 0, 160, 210))
        addSubview(aboutView)
        aboutView.snp_makeConstraints { (make) in
            make.left.equalTo(moreSetting.snp_right).offset(height * 0.02)
            make.top.equalTo(playSetting)
            make.bottom.equalTo(moreSetting)
            make.width.equalTo(height * 5/7)
        }
        
    }
    
    
    override func getViewWidth() -> CGFloat {
        return height * (1.5 + 5/7) + 30
    }

}
