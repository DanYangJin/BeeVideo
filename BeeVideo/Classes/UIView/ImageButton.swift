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
        backgroundImge.contentMode = .ScaleToFill
        backgroundImge.image = UIImage(named: "item_normal_bg.9")
        self.addSubview(backgroundImge)
        
        iconImg = UIImageView()
        iconImg.contentMode = .ScaleAspectFill
        //iconImg.backgroundColor = UIColor.redColor()
        self.addSubview(iconImg)
        
        titleLbl = UILabel()
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.font = UIFont.systemFontOfSize(14)
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
            make.top.equalTo(backgroundImge).offset(3)
            make.bottom.equalTo(backgroundImge).offset(-5)
            make.left.equalTo(backgroundImge).offset(3)
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
    
    
//    
//    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
//        
//        let w = contentRect.size.width;
//        let h = contentRect.size.height;
//        
//        return CGRectMake(w * 1/3 * 1/4, h * 1/6, w * 1/3 , h * 2/3)
//    }
//    
//    
//    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
//        
//        let w = contentRect.size.width
//        let h = contentRect.size.height
//        
//        return CGRectMake(w * 1/3 * 1/4 + w * 1/3 * 7/9 + w * 1/15, h * 1/6, w * 2/3 - w * 1/15, h * 2/3)
//    }
//    

}
