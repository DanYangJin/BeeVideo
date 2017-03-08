//
//  TableTitleView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/17.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol TableTitleViewDelegate{
    func selectButtonIndex(_ index:Int)
}


class TableTitleView: UIScrollView {

    var mTitles:[String] = ["首页","点播","直播","设置"];
    var mButtons:[UIButton] = [UIButton]()
    var mSelectButton:UIButton!
    
    weak var mDelegate: TableTitleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button_1 = UIButton()
        button_1.tag = 0
        button_1.setTitle(mTitles[0], for: UIControlState())
        button_1.setTitleColor(UIColor.gray, for: UIControlState())
        button_1.addTarget(self, action: #selector(onClickBtn(_:)), for: UIControlEvents.touchDown)
        mButtons.append(button_1)
        addSubview(button_1)
        button_1.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(self).dividedBy(4)
        }
        
        let button_2 = UIButton()
        button_2.tag = 1
        button_2.setTitle(mTitles[1], for: UIControlState())
        button_2.setTitleColor(UIColor.gray, for: UIControlState())
        button_2.addTarget(self, action: #selector(onClickBtn(_:)), for: UIControlEvents.touchDown)
        mButtons.append(button_2)
        addSubview(button_2)
        button_2.snp.makeConstraints { (make) in
            make.left.equalTo(button_1.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }
        
        let button_3 = UIButton()
        button_3.tag = 2
        button_3.setTitle(mTitles[2], for: UIControlState())
        button_3.setTitleColor(UIColor.gray, for: UIControlState())
        button_3.addTarget(self, action: #selector(onClickBtn(_:)), for: UIControlEvents.touchDown)
        mButtons.append(button_3)
        addSubview(button_3)
        button_3.snp.makeConstraints { (make) in
            make.left.equalTo(button_2.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }
        
        let button_4 = UIButton()
        button_4.tag = 3
        button_4.setTitle(mTitles[3], for: UIControlState())
        button_4.setTitleColor(UIColor.gray, for: UIControlState())
        button_4.addTarget(self, action: #selector(onClickBtn(_:)), for: UIControlEvents.touchDown)
        mButtons.append(button_4)
        addSubview(button_4)
        button_4.snp.makeConstraints { (make) in
            make.left.equalTo(button_3.snp.right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }

        mSelectButton = mButtons[0]
        onClickBtn(mButtons[0])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    func onClickBtn(_ button:UIButton) {
        mDelegate?.selectButtonIndex(button.tag)
        setOnSelectButton(button)
    }
    
    func setOnSelectButtonByPosition(_ index:Int){
        self.mSelectButton.setTitleColor(UIColor.gray, for: UIControlState())
        self.mSelectButton.transform = CGAffineTransform.identity
        mButtons[index].setTitleColor(UIColor.textBlueColor(), for: UIControlState())
        mButtons[index].transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.mSelectButton = mButtons[index]
    }
    

    func setOnSelectButton(_ button:UIButton){
        self.mSelectButton.setTitleColor(UIColor.gray, for: UIControlState())
        self.mSelectButton.transform = CGAffineTransform.identity
        button.setTitleColor(UIColor.textBlueColor(), for: UIControlState())
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.mSelectButton = button
    }


}
