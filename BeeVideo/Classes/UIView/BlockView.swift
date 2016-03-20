//
//  BlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SDWebImage

class BlockView: UIView {

    private var blockImage:UIImageView!
    private var blockName:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化view
    func initView(item:CycleItemInfo){
        blockImage = UIImageView()
        blockImage.frame = CGRectMake(0, 0, 100, 60)
        blockImage.sd_setImageWithURL(NSURL(string: item.picUrl), placeholderImage: UIImage(named: "cycle1.jpg")) { (image, error, cacheType, url) -> Void in
            NSLog("成功")
        }
        addSubview(blockImage)
        
        blockName = UILabel()
        blockName.frame = CGRectMake(0, 40, 100, 20)
        blockName.text = item.desp
        blockName.textAlignment = NSTextAlignment.Center
        blockName.textColor = UIColor.redColor()
        addSubview(blockName)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("touchesBegan.......")
    }
    

}
