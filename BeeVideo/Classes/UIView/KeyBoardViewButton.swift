//
//  KeyBoardButton.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

enum KeyBoardViewButtonMode {
    case icon
    case text
}


class KeyBoardViewButton: UIButton {

    fileprivate var icon : UIImageView!
    var textLbl : UILabel!
    var buttonMode:KeyBoardViewButtonMode {
        get{
            return self.buttonMode
        }
        
        set{
            switch newValue {
            case .icon:
                self.textLbl.isHidden = true
                break
            case .text:
                self.imageView?.isHidden = true
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .scaleAspectFit
        imageView!.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.center.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
        
        self.setBackgroundImage(UIImage(named: "v2_normal_button_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 18,left: 20,bottom: 18,right: 20), resizingMode: .stretch), for: UIControlState())
        
        textLbl = UILabel()
        textLbl.textColor = UIColor.white
        textLbl.textAlignment = .center
        self.addSubview(textLbl)
        textLbl.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
