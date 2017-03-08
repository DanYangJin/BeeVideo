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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setViewRadius(self)
    }

    
    fileprivate func setViewRadius(_ view: UIView){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5,height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
}
