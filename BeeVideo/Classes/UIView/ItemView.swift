//
//  ItemView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/17.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 用于视频列表的cell
 */

class ItemView: UIView {

    private var isFlagImgHidden : Bool = true
    
    private var nameLbl : UILabel!
    private var durationLbl : MyUILabel!
    private var averageLbl : MyUILabel!
    private var poster : UIImageView!
    private var lineView : UIView!
    private var flagImg : UIImageView!
    
    private var data : VideoBriefItem!
    private var dataByDatabase : VideoHistoryItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        poster = UIImageView()
        poster.contentMode = .ScaleToFill
        poster.layer.cornerRadius = 4
        poster.layer.masksToBounds = true
        self.addSubview(poster)
        
        
        nameLbl = UILabel()
        nameLbl.textAlignment = NSTextAlignment.Center
        nameLbl.font = UIFont.systemFontOfSize(12)
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.lineBreakMode = .ByClipping
        nameLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(nameLbl)
        
        durationLbl = MyUILabel()
        durationLbl.textAlignment = NSTextAlignment.Center
        durationLbl.font = UIFont.systemFontOfSize(12)
        durationLbl.textColor = UIColor.whiteColor()
        durationLbl.lineBreakMode = .ByClipping
        durationLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(durationLbl)
        
        
        averageLbl = MyUILabel()
        averageLbl.textAlignment = .Center
        averageLbl.font = UIFont.systemFontOfSize(12)
        averageLbl.textColor = UIColor.orangeColor()
        averageLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(averageLbl)
        
        flagImg = UIImageView()
        flagImg.contentMode = .ScaleToFill
        flagImg.hidden = true
        self.addSubview(flagImg)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.whiteColor()
        self.addSubview(lineView)

    }
    
    private func setConstraints(){
        poster.snp_makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.left.right.equalTo(self)
        }
        nameLbl.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_bottom).offset(-40)
            make.height.equalTo(20)
            make.left.right.equalTo(poster)
        }
        lineView.snp_makeConstraints { (make) in
            make.top.equalTo(nameLbl.snp_bottom)
            make.height.equalTo(0.5)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.9)
        }
        durationLbl.snp_makeConstraints { (make) in
            make.top.equalTo(nameLbl.snp_bottom)
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        flagImg.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.4)
            make.height.equalTo(self.snp_width).multipliedBy(0.4)
        }
        averageLbl.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.height.equalTo(15)
            make.width.equalTo(30)
        }
        
    }
    
    internal func setData(data: VideoBriefItem){
        self.data = data
        poster.sd_setImageWithURL(NSURL(string: data.posterImg), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        durationLbl.text = data.duration
        nameLbl.text = data.name
        if data.score.isEmpty {
            averageLbl.hidden = true
        }else{
            averageLbl.hidden = false
            averageLbl.text = data.score
        }
        if !isFlagImgHidden {
            if data.resolutionType == 4 {
                flagImg.image = UIImage(named: "v2_video_flag_sd")
            }else if data.resolutionType == 3{
                flagImg.image = UIImage(named: "v2_video_flag_hd")
            }
        }
    }
    
    func setDataFromDataBase(data: VideoHistoryItem){
        self.dataByDatabase = data
        poster.sd_setImageWithURL(NSURL(string: data.poster), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        durationLbl.text = data.duration
        nameLbl.text = data.videoName
        if data.score == nil || data.score.isEmpty {
            averageLbl.hidden = true
        }else{
            averageLbl.hidden = false
            averageLbl.text = data.score
        }
        if !isFlagImgHidden {
            if data.resolutionType == 4 {
                flagImg.image = UIImage(named: "v2_video_flag_sd")
            }else if data.resolutionType == 3{
                flagImg.image = UIImage(named: "v2_video_flag_hd")
            }
        }

    }
    
    func setFlagHidden(hidden: Bool){
        isFlagImgHidden = hidden
        flagImg.hidden = hidden
    }
    
    //设置label指定圆角
    private func setViewRadius(view: UIView){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.BottomLeft,UIRectCorner.BottomRight], cornerRadii: CGSizeMake(5,5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.CGPath
        view.layer.mask = maskLayer
    }

    
}
