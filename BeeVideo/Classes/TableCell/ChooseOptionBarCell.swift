//
//  ChooseOptionBarCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/29.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class ChooseOptionBarCell: ZXOptionBarCell {
    
    fileprivate var backgroundImg:UIView!
    var titleLable:UILabel!
    
    override var selected: Bool{
        didSet{
            if selected{
                titleLable.textColor = UIColor.textBlueColor()
            }else{
                titleLable.textColor = UIColor.white
            }
        }
    }

    override init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundImg = UIImageView(image: UIImage(named: "normal_bg"))
        self.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
        titleLable = UILabel()
        titleLable.textColor = UIColor.white
        titleLable.font = UIFont.systemFont(ofSize: 12)
        titleLable.textAlignment = .center
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
