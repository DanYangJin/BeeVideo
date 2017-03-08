//
//  T9PopupView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/9.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class T9PopupView: UIView {
    
    var centerView:UIButton!
    var leftView:UIButton!
    var topView:UIButton!
    var rightView:UIButton!
    var bottomView:UIButton!
    
    var clickDelegate:IKeyboardDelegate!
    
    init(frame:CGRect, data:[String],centerPoint: CGRect){
        super.init(frame:frame)
        
        centerView = UIButton()
        centerView.setTitle(data[0], for: UIControlState())
        setBtnImage(centerView)
        centerView.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
        self.addSubview(centerView)
        let centerY = centerPoint.origin.y + centerPoint.height/2 - UIScreen.main.bounds.height/2
        let centerX = centerPoint.origin.x + centerPoint.width/2 - UIScreen.main.bounds.width/2
        centerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerX)
            make.centerY.equalTo(centerY)
            make.height.equalTo(centerPoint.height * 5/8)
            make.width.equalTo(centerPoint.width * 5/8)
        }
        
        let count = data.count
        if count >= 2 {
            leftView  = UIButton()
            leftView.setTitle(data[1], for: UIControlState())
            setBtnImage(leftView)
            leftView.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
            self.addSubview(leftView)
            leftView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(centerView)
                make.right.equalTo(centerView.snp.left)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 3 {
            topView = UIButton()
            topView.setTitle(data[2], for: UIControlState())
            setBtnImage(topView)
            topView.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
            self.addSubview(topView)
            topView.snp.makeConstraints({ (make) in
                make.bottom.equalTo(centerView.snp.top)
                make.centerX.equalTo(centerView)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 4 {
            rightView = UIButton()
            rightView.setTitle(data[3], for: UIControlState())
            setBtnImage(rightView)
            rightView.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
            self.addSubview(rightView)
            rightView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(centerView)
                make.left.equalTo(centerView.snp.right)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 5 {
            bottomView = UIButton()
            bottomView.setTitle(data[4], for: UIControlState())
            bottomView.addTarget(self, action: #selector(self.click(_:)), for: .touchUpInside)
            setBtnImage(bottomView)
            self.addSubview(bottomView)
            bottomView.snp.makeConstraints({ (make) in
                make.centerX.equalTo(centerView)
                make.top.equalTo(centerView.snp.bottom)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }

    
    func setBtnImage(_ btn:UIButton){
        btn.setBackgroundImage(UIImage(named: "v2_keyboard_value_normal"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "v2_keyboard_value_highlight"), for: .highlighted)
    }
    
    
    func click(_ sender:UIButton){
        
        if clickDelegate != nil {
            clickDelegate.onKeyboardClick(sender.currentTitle!)
        }
        
        self.removeFromSuperview()
    }
    
}
