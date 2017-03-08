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
    
    fileprivate var backgroundImge : UIView!
    fileprivate var iconImg : UIImageView!
    fileprivate var titleLbl : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        backgroundImge = UIImageView(image: UIImage(named: "normal_bg"))
        //backgroundImge.contentMode = .ScaleToFill
       // backgroundImge.image = UIImage(named: "normal_bg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(12, 30, 12, 30))
        //backgroundImge.
        self.addSubview(backgroundImge)
        
        iconImg = UIImageView()
        iconImg.contentMode = .scaleAspectFill
        self.addSubview(iconImg)
        
        titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(titleLbl)
    
    }
    
    func setConstraint(){
        backgroundImge.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self.snp.right).dividedBy(4)
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
            make.width.equalTo(self.snp.height).multipliedBy(0.6)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImg)
            make.left.equalTo(iconImg.snp.right)
            make.right.equalTo(self).offset(-5)
        }
    }
    
    func setImage(_ imgName: String){
        iconImg.image = UIImage(named: imgName)
    }
    
    func setTitle(_ title : String){
        titleLbl.text = title
    }
    

}
