//
//  RecommendedVideoCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class BaseTableViewCell: ZXOptionBarCell {

    let videoNameLbl: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.lineBreakMode = .byClipping
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return label
    }()
    
    let icon: CornerImageView = {
        let img = CornerImageView(frame: CGRect.zero)
        img.contentMode = .scaleToFill
        img.layer.cornerRadius = 4
        img.layer.masksToBounds = true
        return img
    }()
    
    fileprivate let lineView: UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.white
        return line
    }()
    
    let durationLbl : UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.lineBreakMode = .byClipping
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        return label
    }()
    
    let averageLbl : UILabel = {
        
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.orange
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return label
    }()
    
    override internal var index: Int? {
        didSet {
            
        }
    }
    
    override init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       // print(self.frame.height)
        self.addSubview(icon)
        self.addSubview(videoNameLbl)
        self.addSubview(durationLbl)
        self.addSubview(lineView)
        self.addSubview(averageLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        icon.frame = CGRect(x: 5, y: 5, width: self.frame.width - 5 , height: self.frame.height - 10)
        videoNameLbl.frame = CGRect(x: 5, y: self.frame.height - 35, width: self.frame.width - 5, height: 15)
        lineView.frame = CGRect(x: 10, y: self.frame.height - 20, width: self.frame.width - 15, height: 0.5)
        durationLbl.frame = CGRect(x: 5, y: self.frame.height - 20, width: self.frame.width - 5, height: 15)
        averageLbl.frame = CGRect(x: 15, y: 5, width: 30, height: 15)
        
        setViewRadius(durationLbl)
        setViewRadius(averageLbl)
        
    }
    
    //设置label指定圆角
    fileprivate func setViewRadius(_ view: UIView){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5,height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
}
