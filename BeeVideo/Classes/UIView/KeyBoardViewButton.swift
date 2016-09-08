//
//  KeyBoardButton.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

enum KeyBoardViewButtonMode {
    case Icon
    case Text
}


class KeyBoardViewButton: UIButton {

    private var icon : UIImageView!
    var textLbl : UILabel!
    var buttonMode:KeyBoardViewButtonMode {
        get{
            return self.buttonMode
        }
        
        set{
            switch newValue {
            case .Icon:
                self.textLbl.hidden = true
                break
            case .Text:
                self.imageView?.hidden = true
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .ScaleAspectFit
        imageView!.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.center.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
        
        self.setBackgroundImage(UIImage(named: "v2_normal_button_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 18,left: 20,bottom: 18,right: 20), resizingMode: .Stretch), forState: .Normal)
        
        textLbl = UILabel()
        textLbl.textColor = UIColor.whiteColor()
        textLbl.textAlignment = .Center
        self.addSubview(textLbl)
        textLbl.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
