//
//  SettingBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol SettingBlockViewClickDelegate{
    func settingBlockViewClick(_ settingData:SettingBlockData)
}

class SettingBlockView: UIView {
    
    fileprivate var titleLbl : UILabel!
    fileprivate var inco : UIImageView!
    fileprivate var backgroundImg : UIImageView!
    fileprivate var clickView : UIView!
    
    var settingData:SettingBlockData!
    weak var clickDelegate:SettingBlockViewClickDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundImg()
        initTitleLbl()
        initInco()
        clickView = UIView()
        clickView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        clickView.isHidden = true
        self.addSubview(clickView)
        setConstraints()
        
        clickView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initBackgroundImg(){
        backgroundImg = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundImg.contentMode = .scaleAspectFill
        addSubview(backgroundImg)
    }
    
    fileprivate func initTitleLbl(){
        titleLbl = UILabel(frame: CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20))
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 12)
        addSubview(titleLbl)
    }
    
    fileprivate func initInco(){
        inco = UIImageView(frame: CGRect(x: 0, y: 10, width: frame.width, height: frame.height - 20))
        inco.contentMode = .scaleAspectFill
        addSubview(inco)
    }
    
    fileprivate func setConstraints(){
        backgroundImg.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.width.equalTo(self)
        }
        inco.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(self)
        }
        titleLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(self.snp.height).dividedBy(6)
        }
    }
    
    func setData(_ data:SettingBlockData){
        self.settingData = data
        setBackgroundImg(UIImage(named: settingData.backgroundImg)!)
        setInco(UIImage(named: settingData.icon)!)
        setTitle(settingData.title)
    }
    
    
    func setBackgroundImg(_ image: UIImage){
        backgroundImg.image = image
    }
    
    func setInco(_ image: UIImage){
        inco.image = image
    }
    
    func setTitle(_ title: String){
        titleLbl.text = title
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickView.isHidden = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        clickView.isHidden = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (touches.first?.location(in: self))!
        let isInside = self.point(inside: point, with: event)
        if !isInside {
            clickView.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickView.isHidden = true
        if clickDelegate == nil{
            return
        }
        let point:CGPoint = (touches.first?.location(in: self))!
        let isInside = self.point(inside: point, with: event)
        if !isInside {
            return
        }
        clickDelegate.settingBlockViewClick(settingData)
    }
    

}
