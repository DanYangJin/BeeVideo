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

    fileprivate var isFlagImgHidden : Bool = true
    
    fileprivate var nameLbl : UILabel!
    fileprivate var durationLbl : MyUILabel!
    fileprivate var averageLbl : MyUILabel!
    fileprivate var poster : UIImageView!
    fileprivate var lineView : UIView!
    fileprivate var flagImg : UIImageView!
    
    fileprivate var data : VideoBriefItem!
    fileprivate var dataByDatabase : VideoHistoryItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setConstraints()
    }
    
    func longPress(_ gesture:UILongPressGestureRecognizer){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initView(){
        poster = UIImageView()
        poster.contentMode = .scaleToFill
        poster.layer.cornerRadius = 4
        poster.layer.masksToBounds = true
        self.addSubview(poster)
        
        
        nameLbl = UILabel()
        nameLbl.textAlignment = NSTextAlignment.center
        nameLbl.font = UIFont.systemFont(ofSize: 12)
        nameLbl.textColor = UIColor.white
        nameLbl.lineBreakMode = .byClipping
        nameLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(nameLbl)
        
        durationLbl = MyUILabel()
        durationLbl.textAlignment = NSTextAlignment.center
        durationLbl.font = UIFont.systemFont(ofSize: 10)
        durationLbl.textColor = UIColor.white
        durationLbl.lineBreakMode = .byClipping
        durationLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(durationLbl)
        
        averageLbl = MyUILabel()
        averageLbl.textAlignment = .center
        averageLbl.font = UIFont.systemFont(ofSize: 12)
        averageLbl.textColor = UIColor.orange
        averageLbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(averageLbl)
        
        flagImg = UIImageView()
        flagImg.contentMode = .scaleToFill
        flagImg.isHidden = true
        self.addSubview(flagImg)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.white
        self.addSubview(lineView)

    }
    
    fileprivate func setConstraints(){
        poster.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.left.right.equalTo(self)
        }
        nameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(-40)
            make.height.equalTo(20)
            make.left.right.equalTo(poster)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLbl.snp.bottom)
            make.height.equalTo(0.5)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.9)
        }
        durationLbl.snp.makeConstraints { (make) in
            make.top.equalTo(nameLbl.snp.bottom)
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        flagImg.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.4)
            make.height.equalTo(self.snp.width).multipliedBy(0.4)
        }
        averageLbl.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.height.equalTo(15)
            make.width.equalTo(30)
        }
        
    }
    
    internal func setData(_ data: VideoBriefItem){
        self.data = data
        poster.sd_setImage(with: URL(string: data.posterImg), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        //durationLbl.text = data.duration
        setDurationText(data.duration)
        nameLbl.text = data.name
        if data.score.isEmpty {
            averageLbl.isHidden = true
        }else{
            averageLbl.isHidden = false
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
    
    func setDataFromDataBase(_ data: VideoHistoryItem){
        self.dataByDatabase = data
        poster.sd_setImage(with: URL(string: data.poster), placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        durationLbl.text =  "已观看" + TimeUtils.formatTime(data.playedDuration)
        nameLbl.text = data.videoName
        if data.score == nil || data.score.isEmpty {
            averageLbl.isHidden = true
        }else{
            averageLbl.isHidden = false
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
    
    func setFlagHidden(_ hidden: Bool){
        isFlagImgHidden = hidden
        flagImg.isHidden = hidden
    }
    
    //设置label指定圆角
    fileprivate func setViewRadius(_ view: UIView){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5,height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }

    
    func setDurationText(_ text:String){
        if !text.contains("集") {
            durationLbl.text = text
            return
        }
        var num:Int32 = -1
        let scanner = Scanner(string: text)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        scanner.scanInt32(&num)
        
        let subString = String(num)
        let range = (text as NSString).range(of: subString)
        
        if range.location != NSNotFound{
            let mutable = NSMutableAttributedString(string: text)
            mutable.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: range)
            durationLbl.attributedText = mutable
        }else{
            durationLbl.text = text
        }
        
    }
    
    func getDataFromDatabase() -> VideoHistoryItem{
        return self.dataByDatabase
    }
    
    
}
