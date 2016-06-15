//
//  PlaySettingViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 播放设置页面
 */

class PlaySettingViewController: BaseBackViewController {
    
    private let playSettingList:[String] = ["标清","高清","超清"]
    
    private var playSettingItem:PlaySettingItemView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "播放设置"
        
        playSettingItem = PlaySettingItemView(frame: CGRectZero, title: "清晰度选择", selectionList: playSettingList)
        playSettingItem.iconImg.image = UIImage(named: "v2_play_setting_definition_default")
        view.addSubview(playSettingItem)
        playSettingItem.snp_makeConstraints { (make) in
            make.top.equalTo(backView.snp_bottom)
            make.left.equalTo(titleLbl)
            make.right.equalTo(self.view).offset(-50)
            make.height.equalTo(40)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
