//
//  BackView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/27.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class BackView: UIView {

    private var backImg : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backImg = UIImageView()
        backImg.contentMode = .ScaleAspectFit
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        self.addSubview(backImg)
        backImg.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(10)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
