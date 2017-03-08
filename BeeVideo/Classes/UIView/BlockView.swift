//
//  BlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol BlockViewDelegate {
    func blockClick(_ homeSpace:HomeSpace)
}

class BlockView: BaseBlockView {

    internal var homeSpace:HomeSpace!
    fileprivate weak var delegate : BlockViewDelegate!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDelegate(_ delegate:BlockViewDelegate){
        self.delegate = delegate
    }

    
    func setData(_ homeSpace:HomeSpace){
        self.homeSpace = homeSpace
        setImage(homeSpace.items[0].icon)
        setTitle(homeSpace.items[0].name)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let point = touches.first?.location(in: self)
        let inside = self.point(inside: point!, with: event)
        if delegate == nil || !inside {
            return
        }
        delegate.blockClick(homeSpace)
    }
    
    

}
