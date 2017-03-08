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
        videoNameLbl.font = UIFont.systemFont(ofSize: 14)
        videoNameLbl.textColor = UIColor.white
        videoNameLbl.text = "伪装者"
        self.addSubview(videoNameLbl)
        videoNameLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        sourceNameLbl = UILabel()
        sourceNameLbl.font = UIFont.systemFont(ofSize: 11)
        sourceNameLbl.textColor = UIColor.orange
        sourceNameLbl.text = "乐视"
        self.addSubview(sourceNameLbl)
        sourceNameLbl.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        dramaLbl = UILabel()
        dramaLbl.font = UIFont.systemFont(ofSize: 11)
        dramaLbl.textColor = UIColor.gray
        dramaLbl.text = "即将播放 第3集"
        self.addSubview(dramaLbl)
        dramaLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDrama(_ drama: Int){
        dramaLbl.text = "即将播放 第\(drama)集"
    }
    
    
}
