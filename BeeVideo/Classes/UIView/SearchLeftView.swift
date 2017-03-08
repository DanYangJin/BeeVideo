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

    fileprivate var fullKeyboardBtn:KeyBoardViewButton!
    fileprivate var t9KeyboardBtn:KeyBoardViewButton!
    var fullKeyboard:FullKeyboardView!
    var t9Keyboard:T9KeyboardView!
    var keyLabel:UILabel!
    fileprivate var lineView:UIImageView!
    fileprivate var seacherHelpLabel:UILabel!
    
    fileprivate var fullHidden = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fullKeyboardBtn = KeyBoardViewButton()
        fullKeyboardBtn.textLbl.text = "全键盘"
        fullKeyboardBtn.textLbl.font = UIFont.systemFont(ofSize: 13)
        fullKeyboardBtn.textLbl.textColor = UIColor.textBlueColor()
        fullKeyboardBtn.addTarget(self, action: #selector(self.fullKeyBtnClick), for: .touchUpInside)
        self.addSubview(fullKeyboardBtn)
        
        t9KeyboardBtn = KeyBoardViewButton()
        t9KeyboardBtn.textLbl.text = "九宫格"
        t9KeyboardBtn.textLbl.font = UIFont.systemFont(ofSize: 13)
        t9KeyboardBtn.addTarget(self, action: #selector(self.t9KeyClick), for: .touchUpInside)
        self.addSubview(t9KeyboardBtn)
        
        keyLabel = UILabel()
        keyLabel.textAlignment = .center
        keyLabel.font = UIFont.systemFont(ofSize: 12)
        keyLabel.textColor = UIColor.white
        self.addSubview(keyLabel)
        
        lineView = UIImageView()
        lineView.image = UIImage(named: "v2_search_input_panel_divider")?.resizableImage(withCapInsets: UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1), resizingMode: .stretch)
        self.addSubview(lineView)
        
        seacherHelpLabel = UILabel()
        seacherHelpLabel.textColor = UIColor.white
        seacherHelpLabel.textAlignment = .center
        seacherHelpLabel.font = UIFont.systemFont(ofSize: 9)
        seacherHelpLabel.text = "请输入片名或主演的首字母进行搜索"
        self.addSubview(seacherHelpLabel)
        
        fullKeyboard = FullKeyboardView()
        self.addSubview(fullKeyboard)
        
        t9Keyboard = T9KeyboardView()
        t9Keyboard.isHidden = true
        self.addSubview(t9Keyboard)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setConstraints(){
        fullKeyboardBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.08)
            make.width.equalTo(self).multipliedBy(0.48)
        }
        
        t9KeyboardBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.bottom.equalTo(fullKeyboardBtn)
            make.width.equalTo(fullKeyboardBtn)
        }
        
        keyLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(fullKeyboardBtn)
            make.top.equalTo(fullKeyboardBtn.snp.bottom)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(keyLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        seacherHelpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(fullKeyboardBtn).multipliedBy(0.7)
        }
        
        fullKeyboard.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(seacherHelpLabel.snp.bottom)
        }
        
        t9Keyboard.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.top.equalTo(seacherHelpLabel.snp.bottom)
        }
    }
    
    func fullKeyBtnClick(){
        if fullHidden {
            fullKeyboard.isHidden = false
            t9Keyboard.isHidden = true
            fullHidden = !fullHidden
            fullKeyboardBtn.textLbl.textColor = UIColor.textBlueColor()
            t9KeyboardBtn.textLbl.textColor = UIColor.white
        }
    }
    
    func t9KeyClick(){
        if !fullHidden {
            fullKeyboard.isHidden = true
            t9Keyboard.isHidden = false
            fullHidden = !fullHidden
            fullKeyboardBtn.textLbl.textColor = UIColor.white
            t9KeyboardBtn.textLbl.textColor = UIColor.textBlueColor()
        }
    }

}
