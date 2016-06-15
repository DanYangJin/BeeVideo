//
//  TableTitleView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/17.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

protocol TableTitleViewDelegate:class{
    func selectButtonIndex(index:Int)
}


class TableTitleView: UIScrollView {

    var mTitles:[String] = ["首页","点播","直播","设置"];
    var mButtons:[UIButton] = Array()
    var mTitleWidth:Int = 50
    var mTitleHeight:Int = 40
    var mSelectButton:UIButton!
    
    weak var mDelegate: TableTitleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initTitleData(){
        if mDelegate == nil {
            //NSLog("this view must set delegate")
            return
        }
        for index in 0 ..< mTitles.count {
            let button:UIButton = UIButton()
            button.frame = CGRect(x: mTitleWidth * index, y: 0, width: mTitleWidth, height: mTitleHeight)
            button.tag = index
            button.setTitle(mTitles[index], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: #selector(onClickBtn(_:)), forControlEvents: UIControlEvents.TouchDown)
            mButtons.append(button)
            addSubview(button)
            
            if index == 0 {
                self.mSelectButton = self.mButtons[0]
                self.onClickBtn(button)
            }
        }
        
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
