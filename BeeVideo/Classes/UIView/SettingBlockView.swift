//
//  SettingBlockView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SettingBlockView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var titleLbl : UILabel!
    private var inco : UIImageView!
    private var backgroundImg : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundImg()
        initTitleLbl()
        initInco()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initBackgroundImg(){
        backgroundImg = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundImg.contentMode = .ScaleAspectFill
        addSubview(backgroundImg)
    }
    
    private func initTitleLbl(){
        titleLbl = UILabel(frame: CGRectMake(0, frame.height - 20, frame.width, 20))
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.textAlignment = .Center
        titleLbl.font = UIFont.systemFontOfSize(12)
        addSubview(titleLbl)
    }
    
    private func initInco(){
        inco = UIImageView(frame: CGRectMake(0, 10, frame.width, frame.height - 20))
        inco.contentMode = .ScaleAspectFill
        addSubview(inco)
    }
    
    private func setConstraints(){
        backgroundImg.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.width.equalTo(self)
        }
        inco.snp_makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.width.equalTo(self)
        }
        titleLbl.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(self.snp_height).dividedBy(6)
        }
    }
    
    func setBackgroundImg(image: UIImage){
        backgroundImg.image = image
    }
    
    func setInco(image: UIImage){
        inco.image = image
    }
    
    func setTitle(title: String){
        titleLbl.text = title
    }
    

}
