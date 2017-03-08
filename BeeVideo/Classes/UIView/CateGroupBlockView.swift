//
//  CateGroupBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//
@objc protocol CateGroupBlockClick {
    func cateGroupBlockClick(_ categoryGroupItem:CategoryGroupItem)
}

class CateGroupBlockView: BaseBlockView {

    var categoryGroupItem : CategoryGroupItem!
    weak var delegate : CateGroupBlockClick!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        blockName.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ categoryGroupItem:CategoryGroupItem){
        self.categoryGroupItem = categoryGroupItem
        setImage(categoryGroupItem.poster)
        setTitle(categoryGroupItem.name)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if delegate == nil{
            return
        }
        delegate.cateGroupBlockClick(categoryGroupItem)
    }
    

}
