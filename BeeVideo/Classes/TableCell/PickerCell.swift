//
//  PickerCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class PickerCell: UIView {

    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
