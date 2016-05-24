//
//  CornerImageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class CornerImageView: UIImageView {
    
    
    func setCorner(corner:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner;
    }
    
    
}
