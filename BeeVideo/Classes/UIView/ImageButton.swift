//
//  ImageButton.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/15.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class ImageButton: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var backgroundImge : UIImageView!
    private var iconImg : UIImageView!
    private var titleLbl : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        backgroundImge = UIImageView()
        //backgroundImge.contentMode = .ScaleAspectFill
        backgroundImge.image = UIImage(named: "normal_bg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 30, 30, 30))
        self.addSubview(backgroundImge)
        
        iconImg = UIImageView()
        iconImg.contentMode = .ScaleAspectFill
        //iconImg.backgroundColor = UIColor.redColor()
        self.addSubview(iconImg)
        
        titleLbl = UILabel()
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.font = UIFont.systemFontOfSize(12)
        //titleLbl.backgroundColor = UIColor.redColor()
        self.addSubview(titleLbl)
    
    }
    
    func setConstraint(){
        backgroundImge.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        iconImg.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(20)
            make.left.equalTo(self).offset(3)
            make.width.equalTo(25)
        }
        
        titleLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(iconImg)
            make.top.equalTo(iconImg)
            make.bottom.equalTo(iconImg)
            make.left.equalTo(iconImg.snp_right).offset(3)
            make.right.equalTo(self).offset(-5)
        }
    }
    
    func setImage(imgName: String){
        iconImg.image = UIImage(named: imgName)
    }
    
    func setTitle(title : String){
        titleLbl.text = title
    }
    

}
