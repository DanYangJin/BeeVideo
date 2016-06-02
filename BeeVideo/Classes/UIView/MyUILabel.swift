//
//  MyUILabel.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
  左下和右下角为圆角的label
 */

class MyUILabel: UILabel {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        setViewRadius(self)
    }

    
    private func setViewRadius(view: UIView){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.BottomLeft,UIRectCorner.BottomRight], cornerRadii: CGSizeMake(5,5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.CGPath
        view.layer.mask = maskLayer
    }
    
}
