//
//  CateGroupBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

protocol CateGroupBlockClick {
    func cateGroupBlockClick(categoryGroupItem:CategoryGroupItem)
}

class CateGroupBlockView: BaseBlockView {

    var categoryGroupItem : CategoryGroupItem!
    var delegate : CateGroupBlockClick!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        blockName.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(categoryGroupItem:CategoryGroupItem){
        self.categoryGroupItem = categoryGroupItem
        setImage(categoryGroupItem.poster)
        setTitle(categoryGroupItem.name)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if delegate == nil{
            return
        }
        delegate.cateGroupBlockClick(categoryGroupItem)
    }
    

}
