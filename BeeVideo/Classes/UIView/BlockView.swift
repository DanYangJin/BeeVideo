//
//  BlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

protocol BlockViewDelegate {
    func blockClick(homeSpace:HomeSpace)
}

class BlockView: UIControl {

    internal var homeSpace:HomeSpace!
    private var blockImage:CornerImageView!
    private var blockName:UILabel!
    private var delegate : BlockViewDelegate!
    private var blockViewMode : BlockViewMode = BlockViewMode.Center
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.click), forControlEvents: .TouchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    //初始化view
    func initView(homeSpace:HomeSpace){
        //setFrame()
        self.homeSpace = homeSpace
        initImage(homeSpace.items[0].icon)
        initLabel(homeSpace.items[0].name)
        setConstriants()
    }

    
    func setDelegate(delegate:BlockViewDelegate){
        self.delegate = delegate
    }
    
    func initImage(url:String){
       // blockImage = CornerImageView(frame: CGRectMake(0, 0, width, height))
        blockImage = CornerImageView()
        blockImage.setCorner(4.0)
        blockImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "v2_image_default_bg.9"));
        addSubview(blockImage)
    }
    
    func initLabel(text:String){
        blockName = UILabel()
        //blockName.frame = CGRectMake(0, height - 20, width, 20)
        blockName.text = text
        blockName.textAlignment = NSTextAlignment.Center
        blockName.textColor = UIColor.whiteColor()
        blockName.font = UIFont(name: "Helvetica", size: 12.0)

        addSubview(blockName)
    }
    
    func setBlockViewMode(mode: BlockViewMode){
        self.blockViewMode = mode
        blockImage.snp_removeConstraints()
        blockName.snp_removeConstraints()
        setConstriants()
    }
    
    func hiddenLbl(hidden: Bool){
        blockName.hidden = hidden
    }
    
    
    private func setConstriants(){
        blockImage.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        blockName.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(20)
            switch blockViewMode {
            case .Center:
                make.left.equalTo(self)
                make.right.equalTo(self)
                break
            case .Left:
                
                break
                
            case .Right:
                make.left.equalTo(self)
                make.right.equalTo(self.snp_right).inset(20)
                blockName.textAlignment = .Right
                break
                
            }
        }
    }
    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        print("cancelled.....")
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if delegate == nil {
//            return
//        }
//        delegate.blockClick(homeSpace)
//    }
    
    func click(){
        if delegate == nil {
            return
        }
        delegate.blockClick(homeSpace)
    }
    

}
