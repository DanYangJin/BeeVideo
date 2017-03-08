//
//  VerticalAlignmentLabel.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

/**
 可在垂直方向进行上、中、下调整内容的label
 
 */

class VerticalAlignmentLabel: UILabel {
    
    var verticalAlignmentMode : VerticalAlignmentMode = VerticalAlignmentMode.verticalAlignmentMiddle
    
    
    internal enum VerticalAlignmentMode {
        case verticalAlignmentTop
        case verticalAlignmentMiddle
        case verticalAligmentBottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalAlignmentMode = VerticalAlignmentMode.verticalAlignmentMiddle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVerticalAlignmentMode(_ mode: VerticalAlignmentMode){
        self.verticalAlignmentMode = mode
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch verticalAlignmentMode {
        case .verticalAlignmentTop:
            textRect.origin.y = bounds.origin.y
            break
        case .verticalAligmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
            break
        case .verticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
            break
        }
        return textRect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
    
}
