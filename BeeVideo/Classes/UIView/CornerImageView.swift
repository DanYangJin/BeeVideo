//
//  CornerImageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class CornerImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCorner(4.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setCorner(4.0)
    }
    
    func setCorner(corner:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner;
    }
    
    
}
