//
//  TableTitleView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/17.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol TableTitleViewDelegate{
    func selectButtonIndex(index:Int)
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
        button_1.setTitle(mTitles[0], forState: UIControlState.Normal)
        button_1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button_1.addTarget(self, action: #selector(onClickBtn(_:)), forControlEvents: UIControlEvents.TouchDown)
        mButtons.append(button_1)
        addSubview(button_1)
        button_1.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(self).dividedBy(4)
        }
        
        let button_2 = UIButton()
        button_2.tag = 1
        button_2.setTitle(mTitles[1], forState: UIControlState.Normal)
        button_2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button_2.addTarget(self, action: #selector(onClickBtn(_:)), forControlEvents: UIControlEvents.TouchDown)
        mButtons.append(button_2)
        addSubview(button_2)
        button_2.snp_makeConstraints { (make) in
            make.left.equalTo(button_1.snp_right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }
        
        let button_3 = UIButton()
        button_3.tag = 2
        button_3.setTitle(mTitles[2], forState: UIControlState.Normal)
        button_3.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button_3.addTarget(self, action: #selector(onClickBtn(_:)), forControlEvents: UIControlEvents.TouchDown)
        mButtons.append(button_3)
        addSubview(button_3)
        button_3.snp_makeConstraints { (make) in
            make.left.equalTo(button_2.snp_right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }
        
        let button_4 = UIButton()
        button_4.tag = 3
        button_4.setTitle(mTitles[3], forState: UIControlState.Normal)
        button_4.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button_4.addTarget(self, action: #selector(onClickBtn(_:)), forControlEvents: UIControlEvents.TouchDown)
        mButtons.append(button_4)
        addSubview(button_4)
        button_4.snp_makeConstraints { (make) in
            make.left.equalTo(button_3.snp_right)
            make.top.bottom.equalTo(self)
            make.width.equalTo(button_1)
        }

        mSelectButton = mButtons[0]
        onClickBtn(mButtons[0])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    func onClickBtn(button:UIButton) {
        mDelegate?.selectButtonIndex(button.tag)
        setOnSelectButton(button)
    }
    
    func setOnSelectButtonByPosition(index:Int){
        self.mSelectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.mSelectButton.transform = CGAffineTransformIdentity
        mButtons[index].setTitleColor(UIColor.textBlueColor(), forState: UIControlState.Normal)
        mButtons[index].transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.mSelectButton = mButtons[index]
    }
    

    func setOnSelectButton(button:UIButton){
        self.mSelectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.mSelectButton.transform = CGAffineTransformIdentity
        button.setTitleColor(UIColor.textBlueColor(), forState: UIControlState.Normal)
        button.transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.mSelectButton = button
    }


}
