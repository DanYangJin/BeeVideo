//
//  UIView+Extension.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

extension UIView {
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        self.userInteractionEnabled = true
        self.addGestureRecognizer(gr)
    }
}
