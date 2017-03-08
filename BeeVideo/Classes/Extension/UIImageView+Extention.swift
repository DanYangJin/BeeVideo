//
//  UIImageView+Extention.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//

extension UIImageView{
    func addCorner(radius: CGFloat) {
        self.image = self.image?.drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}
