//
//  SearchLeftView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

/**
 搜索页面左侧view
 */

class SearchLeftView: UIView {

    private var fullKeyboardBtn:KeyBoardViewButton!
    private var t9KeyboardBtn:KeyBoardViewButton!
    var fullKeyboard:FullKeyboardView!
    var keyLabel:UILabel!
    private var lineView:UIImageView!
    private var seacherHelpLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fullKeyboardBtn = KeyBoardViewButton()
        fullKeyboardBtn.textLbl.text = "全键盘"
        fullKeyboardBtn.textLbl.font = UIFont.systemFontOfSize(13)
        self.addSubview(fullKeyboardBtn)
        
        t9KeyboardBtn = KeyBoardViewButton()
        t9KeyboardBtn.textLbl.text = "九宫格"
        t9KeyboardBtn.textLbl.font = UIFont.systemFontOfSize(13)
        self.addSubview(t9KeyboardBtn)
        
        keyLabel = UILabel()
        keyLabel.textAlignment = .Center
        keyLabel.textColor = UIColor.whiteColor()
        self.addSubview(keyLabel)
        
        lineView = UIImageView()
        lineView.image = UIImage(named: "v2_search_input_panel_divider")?.resizableImageWithCapInsets(UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1), resizingMode: .Stretch)
        self.addSubview(lineView)
        
        seacherHelpLabel = UILabel()
        seacherHelpLabel.textColor = UIColor.whiteColor()
        seacherHelpLabel.textAlignment = .Center
        seacherHelpLabel.font = UIFont.systemFontOfSize(9)
        seacherHelpLabel.text = "请输入片名或主演的首字母进行搜索"
        self.addSubview(seacherHelpLabel)
        
        fullKeyboard = FullKeyboardView()
        self.addSubview(fullKeyboard)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints(){
        fullKeyboardBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.08)
            make.width.equalTo(self).multipliedBy(0.48)
        }
        
        t9KeyboardBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.bottom.equalTo(fullKeyboardBtn)
            make.width.equalTo(fullKeyboardBtn)
        }
        
        keyLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(fullKeyboardBtn)
            make.top.equalTo(fullKeyboardBtn.snp_bottom)
        }
        
        lineView.snp_makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(keyLabel.snp_bottom)
            make.height.equalTo(1)
        }
        
        seacherHelpLabel.snp_makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(fullKeyboardBtn).multipliedBy(0.7)
        }
        
        fullKeyboard.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(seacherHelpLabel.snp_bottom)
        }
        
        
        
    }

}
