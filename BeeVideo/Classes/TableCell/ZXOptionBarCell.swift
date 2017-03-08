//
//  ZXOptionBarCell.swift
//  ZXOptionBar-Swift
//
//  Created by 子循 on 14-10-3.
//  Copyright (c) 2014年 zixun. All rights reserved.
//

import UIKit

enum ZXOptionBarCellStyle{
    case zxOptionBarCellStyleDefault
}

// MARK: - ZXOptionBarCell
class ZXOptionBarCell: UIView {
    
    // MARK: Internal Var
    internal var index: Int?
    
    internal var indicatorColor: UIColor?
    
    internal var optionBar: ZXOptionBar? { return self.superview as? ZXOptionBar }
    
    internal var selected: Bool {
        get { return optionBarCellDidSelectedFlag }
        set { optionBarCellDidSelectedFlag = newValue }
    }
    
    // MARK: ReadOnly Var
    fileprivate(set) var reuseIdentifier: String?
    
    // MARK: Private Var
    fileprivate var optionBarCellDidMovedFlag: Bool = false
    
    fileprivate var optionBarCellDidSelectedFlag: Bool = false
    
    
    internal init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(frame: CGRect.zero)
        self.reuseIdentifier = reuseIdentifier
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func prepareForReuse() {
        self.index = nil
        self.indicatorColor = nil
        self.removeAllAnimations()
        self.setNeedsDisplay()
    }
    
    internal func prepareForDisplay() {
        self.removeAllAnimations()
    }
}

extension ZXOptionBarCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with: event)
        optionBarCellDidMovedFlag = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches , with: event)
        optionBarCellDidMovedFlag = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches  , with: event)
        if optionBarCellDidMovedFlag == false {
            
            self.optionBar?.selectColumnAtIndex(self.index!, origin: ZXOptionBarOrigin.zxOptionBarOriginTap)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches!, with: event)
        optionBarCellDidMovedFlag = false
    }
    

}

// MARK: - ZXOptionBarCell - Private Extension
extension ZXOptionBarCell {
    fileprivate func removeAllAnimations() {
        self.layer.removeAllAnimations()
        for view in self.subviews {
            view.layer.removeAllAnimations()
        }
    }
}
