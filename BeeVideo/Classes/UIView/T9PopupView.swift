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
        centerView.setTitle(data[0], forState: .Normal)
        setBtnImage(centerView)
        centerView.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(centerView)
        let centerY = centerPoint.origin.y + centerPoint.height/2 - UIScreen.mainScreen().bounds.height/2
        let centerX = centerPoint.origin.x + centerPoint.width/2 - UIScreen.mainScreen().bounds.width/2
        centerView.snp_makeConstraints { (make) in
            make.centerX.equalTo(centerX)
            make.centerY.equalTo(centerY)
            make.height.equalTo(centerPoint.height * 5/8)
            make.width.equalTo(centerPoint.width * 5/8)
        }
        
        let count = data.count
        if count >= 2 {
            leftView  = UIButton()
            leftView.setTitle(data[1], forState: .Normal)
            setBtnImage(leftView)
            leftView.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(leftView)
            leftView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(centerView)
                make.right.equalTo(centerView.snp_left)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 3 {
            topView = UIButton()
            topView.setTitle(data[2], forState: .Normal)
            setBtnImage(topView)
            topView.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(topView)
            topView.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(centerView.snp_top)
                make.centerX.equalTo(centerView)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 4 {
            rightView = UIButton()
            rightView.setTitle(data[3], forState: .Normal)
            setBtnImage(rightView)
            rightView.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(rightView)
            rightView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(centerView)
                make.left.equalTo(centerView.snp_right)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
        if count >= 5 {
            bottomView = UIButton()
            bottomView.setTitle(data[4], forState: .Normal)
            bottomView.addTarget(self, action: #selector(self.click(_:)), forControlEvents: .TouchUpInside)
            setBtnImage(bottomView)
            self.addSubview(bottomView)
            bottomView.snp_makeConstraints(closure: { (make) in
                make.centerX.equalTo(centerView)
                make.top.equalTo(centerView.snp_bottom)
                make.height.equalTo(centerView)
                make.width.equalTo(centerView)
            })
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }

    
    func setBtnImage(btn:UIButton){
        btn.setBackgroundImage(UIImage(named: "v2_keyboard_value_normal"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "v2_keyboard_value_highlight"), forState: .Highlighted)
    }
    
    
    func click(sender:UIButton){
        
        if clickDelegate != nil {
            clickDelegate.onKeyboardClick(sender.currentTitle!)
        }
        
        self.removeFromSuperview()
    }
    
}
