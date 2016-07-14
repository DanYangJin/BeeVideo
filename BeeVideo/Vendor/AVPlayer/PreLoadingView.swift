//
//  PreLoadingView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/8.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class PreLoadingView: UIView {
    
    var videoNameLbl:UILabel!
    var sourceNameLbl:UILabel!
    var dramaLbl:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoNameLbl = UILabel()
        videoNameLbl.font = UIFont.systemFontOfSize(14)
        videoNameLbl.textColor = UIColor.whiteColor()
        videoNameLbl.text = "伪装者"
        self.addSubview(videoNameLbl)
        videoNameLbl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        sourceNameLbl = UILabel()
        sourceNameLbl.font = UIFont.systemFontOfSize(11)
        sourceNameLbl.textColor = UIColor.orangeColor()
        sourceNameLbl.text = "乐视"
        self.addSubview(sourceNameLbl)
        sourceNameLbl.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        dramaLbl = UILabel()
        dramaLbl.font = UIFont.systemFontOfSize(11)
        dramaLbl.textColor = UIColor.grayColor()
        dramaLbl.text = "即将播放 第3集"
        self.addSubview(dramaLbl)
        dramaLbl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDrama(drama: Int){
        dramaLbl.text = "即将播放 第\(drama)集"
    }
    
    
}
