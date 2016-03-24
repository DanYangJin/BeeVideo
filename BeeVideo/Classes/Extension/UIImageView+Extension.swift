//
//  UIImageView+Extension.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

extension UIImageView {

    public func setCorner(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4.0;
    }

}
