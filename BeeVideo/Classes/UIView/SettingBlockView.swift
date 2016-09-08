//
//  SettingBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol SettingBlockViewClickDelegate{
    func settingBlockViewClick(settingData:SettingBlockData)
}

class SettingBlockView: UIView {
    
    private var titleLbl : UILabel!
    private var inco : UIImageView!
    private var backgroundImg : UIImageView!
    private var clickView : UIView!
    
    var settingData:SettingBlockData!
    weak var clickDelegate:SettingBlockViewClickDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundImg()
        initTitleLbl()
        initInco()
        clickView = UIView()
        clickView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        clickView.hidden = true
        self.addSubview(clickView)
        setConstraints()
        
        clickView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initBackgroundImg(){
        backgroundImg = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundImg.contentMode = .ScaleAspectFill
        addSubview(backgroundImg)
    }
    
    private func initTitleLbl(){
        titleLbl = UILabel(frame: CGRectMake(0, frame.height - 20, frame.width, 20))
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.textAlignment = .Center
        titleLbl.font = UIFont.systemFontOfSize(12)
        addSubview(titleLbl)
    }
    
    private func initInco(){
        inco = UIImageView(frame: CGRectMake(0, 10, frame.width, frame.height - 20))
        inco.contentMode = .ScaleAspectFill
        addSubview(inco)
    }
    
    private func setConstraints(){
        backgroundImg.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.width.equalTo(self)
        }
        inco.snp_makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(self)
        }
        titleLbl.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(self.snp_height).dividedBy(6)
        }
    }
    
    func setData(data:SettingBlockData){
        self.settingData = data
        setBackgroundImg(UIImage(named: settingData.backgroundImg)!)
        setInco(UIImage(named: settingData.icon)!)
        setTitle(settingData.title)
    }
    
    
    func setBackgroundImg(image: UIImage){
        backgroundImg.image = image
    }
    
    func setInco(image: UIImage){
        inco.image = image
    }
    
    func setTitle(title: String){
        titleLbl.text = title
    }
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clickView.hidden = false
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clickView.hidden = true
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point:CGPoint = (touches.first?.locationInView(self))!
        let isInside = self.pointInside(point, withEvent: event)
        if !isInside {
            clickView.hidden = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clickView.hidden = true
        if clickDelegate == nil{
            return
        }
        let point:CGPoint = (touches.first?.locationInView(self))!
        let isInside = self.pointInside(point, withEvent: event)
        if !isInside {
            return
        }
        clickDelegate.settingBlockViewClick(settingData)
    }
    

}
