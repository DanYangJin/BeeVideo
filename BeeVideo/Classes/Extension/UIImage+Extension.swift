//
//  UIImage+Extension.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//

extension UIImage{
    
    ///给图片绘制圆角
    func drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!
    }
}
