//
//  UIView+Extension.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

extension UIView {
    
    func addOnClickListener(_ target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gr)
    }
}
