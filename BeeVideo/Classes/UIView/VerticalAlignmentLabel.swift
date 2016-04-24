//
//  VerticalAlignmentLabel.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VerticalAlignmentLabel: UILabel {
    
    var verticalAlignmentMode : VerticalAlignmentMode = VerticalAlignmentMode.VerticalAlignmentMiddle


    internal enum VerticalAlignmentMode {
        case VerticalAlignmentTop
        case VerticalAlignmentMiddle
        case VerticalAligmentBottom
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalAlignmentMode = VerticalAlignmentMode.VerticalAlignmentMiddle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVerticalAlignmentMode(mode: VerticalAlignmentMode){
        self.verticalAlignmentMode = mode
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        switch verticalAlignmentMode {
        case .VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y
            break
        case .VerticalAligmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
            break
        case .VerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
            break
        }
        return textRect
    }
    
    override func drawTextInRect(rect: CGRect) {
        let actualRect = textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawTextInRect(actualRect)
    }
    
}
