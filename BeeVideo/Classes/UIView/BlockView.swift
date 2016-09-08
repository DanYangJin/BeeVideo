//
//  BlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol BlockViewDelegate {
    func blockClick(homeSpace:HomeSpace)
}

class BlockView: BaseBlockView {

    internal var homeSpace:HomeSpace!
    private weak var delegate : BlockViewDelegate!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDelegate(delegate:BlockViewDelegate){
        self.delegate = delegate
    }

    
    func setData(homeSpace:HomeSpace){
        self.homeSpace = homeSpace
        setImage(homeSpace.items[0].icon)
        setTitle(homeSpace.items[0].name)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        let point = touches.first?.locationInView(self)
        let inside = self.pointInside(point!, withEvent: event)
        if delegate == nil || !inside {
            return
        }
        delegate.blockClick(homeSpace)
    }
    
    

}
