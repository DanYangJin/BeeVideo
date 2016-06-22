//
//  MyVideoEmptyView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class MyVideoEmptyView: UIView {

    var titleLabel:UILabel!
    var emptyImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel(frame: CGRectMake(0,0,frame.width,20))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(8)
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        
        emptyImage = UIImageView(frame: CGRectMake(0, 20, frame.width, frame.width * 410/1160))
        emptyImage.contentMode = .ScaleAspectFit
        self.addSubview(emptyImage)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
