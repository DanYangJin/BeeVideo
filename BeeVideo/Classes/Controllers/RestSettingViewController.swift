//
//  RestSettingViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/2.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
  更多设置页面
 */

class RestSettingViewController: BaseBackViewController,SettingBlockViewClickDelegate {

    private var backgroundSettingBlockView:SettingBlockView!
    private var downloadSettingBlockView:SettingBlockView!
    private var clearCacheBlockView:SettingBlockView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "更多设置"
        
        var settingData:SettingBlockData
        
        backgroundSettingBlockView = SettingBlockView()
        settingData = SettingBlockData(title: "背景设置", icon: "v2_setting_app_background", backgroundImg: "v2_laucher_block_green_bg", targetController: "")
        backgroundSettingBlockView.setData(settingData)
        backgroundSettingBlockView.clickDelegate = self
        view.addSubview(backgroundSettingBlockView)
        backgroundSettingBlockView.snp_makeConstraints { (make) in
            make.top.equalTo(backView.snp_bottom).offset(30)
            make.left.equalTo(titleLbl.snp_centerX)
            make.height.width.equalTo(150)
        }
        
        downloadSettingBlockView = SettingBlockView()
        settingData = SettingBlockData(title: "下载设置", icon: "v2_setting_screen_saver", backgroundImg: "v2_laucher_block_green_bg", targetController: "")
        downloadSettingBlockView.clickDelegate = self
        downloadSettingBlockView.setData(settingData)
        view.addSubview(downloadSettingBlockView)
        downloadSettingBlockView.snp_makeConstraints { (make) in
            make.left.equalTo(backgroundSettingBlockView.snp_right).offset(10)
            make.top.bottom.equalTo(backgroundSettingBlockView)
            make.width.equalTo(backgroundSettingBlockView)
        }
        
        
        clearCacheBlockView = SettingBlockView()
        settingData = SettingBlockData(title: "清除缓存", icon: "v2_setting_clean_cache", backgroundImg: "v2_laucher_block_green_bg", targetController: "")
        clearCacheBlockView.setData(settingData)
        clearCacheBlockView.clickDelegate = self
        view.addSubview(clearCacheBlockView)
        clearCacheBlockView.snp_makeConstraints { (make) in
            make.left.equalTo(downloadSettingBlockView.snp_right).offset(10)
            make.top.bottom.equalTo(downloadSettingBlockView)
            make.width.equalTo(backgroundSettingBlockView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func settingBlockViewClick(settingData: SettingBlockData) {
        
    }
    
}
