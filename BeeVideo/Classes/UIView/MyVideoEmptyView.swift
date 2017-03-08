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
        
        titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: frame.width,height: 20))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 8)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        emptyImage = UIImageView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.width * 410/1160))
        emptyImage.contentMode = .scaleAspectFit
        self.addSubview(emptyImage)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
