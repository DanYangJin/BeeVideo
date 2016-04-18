//
//  RecommendedVideoCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class BaseTableViewCell: ZXOptionBarCell {
    
    let videoNameLbl: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.lineBreakMode = .ByClipping
        label.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.8)
        return label
    }()
    
    let icon: CornerImageView = {
        return CornerImageView(frame: CGRectZero)
    }()
    
    let lineView: UIView = {
       let line = UIView(frame: CGRectZero)
        line.backgroundColor = UIColor.whiteColor()
        return line
    }()
    
    let durationLbl : UILabel = {
        
        let label = UILabel(frame: CGRectZero)
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.lineBreakMode = .ByClipping
        label.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.8)
        return label
    }()
    
    override internal var index: Int? {
        didSet {

        }
    }
    
//    override internal var selected: Bool {
//        didSet {
//            if selected {
//                icon.image = UIImage(named: "bra_focus")
//            }else{
//                icon.image = UIImage(named: "bra")
//            }
//        }
//    }
    
    override init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(icon)
        self.addSubview(videoNameLbl)
        self.addSubview(durationLbl)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        icon.frame = CGRectMake(5, 5, self.frame.width - 5 , self.frame.height - 10)
        videoNameLbl.frame = CGRectMake(5, self.frame.height - 35, self.frame.width - 5, 15)
        lineView.frame = CGRectMake(10, self.frame.height - 20, self.frame.width - 15, 0.5)
        durationLbl.frame = CGRectMake(5, self.frame.height - 20, self.frame.width - 5, 15)
    }

    
}
