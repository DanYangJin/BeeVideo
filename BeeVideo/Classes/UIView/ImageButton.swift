//
//  ImageButton.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/15.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class ImageButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        let w = contentRect.size.width;
        let h = contentRect.size.height;
        
        return CGRectMake(w * 1/3 * 1/4, h * 1/6, w * 1/3 , h * 2/3)
    }
    
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        let w = contentRect.size.width
        let h = contentRect.size.height
        
        return CGRectMake(w * 1/3 * 1/4 + w * 1/3 * 7/9 + w * 1/15, h * 1/6, w * 2/3 - w * 1/15, h * 2/3)
    }
    

}
