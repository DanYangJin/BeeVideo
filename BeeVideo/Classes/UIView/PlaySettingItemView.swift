//
//  PlaySettingItemView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class PlaySettingItemView: UIView {

    var iconImg:UIImageView!
    private var backgroundImg:UIImageView!
    private var nameLbl:UILabel!
    private var selectionLbl:UILabel!
    private var leftArrowImg:UIImageView!
    private var rightArrowImg:UIImageView!
    
    var currentIndex = 0
    var selectionList:[String]!
    
    init(frame: CGRect,title: String,selectionList: [String]) {
        super.init(frame: frame)
        self.selectionList = selectionList
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .Redraw
        backgroundImg.image = UIImage(named: "v2_play_setting_item_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        self.addSubview(backgroundImg)
        
        iconImg = UIImageView()
        iconImg.contentMode = .ScaleAspectFill
        self.addSubview(iconImg)
        
        nameLbl = UILabel()
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.text = title
        nameLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(nameLbl)
        
        selectionLbl = UILabel()
        selectionLbl.textColor = UIColor.textBlueColor()
        selectionLbl.textAlignment = .Center
        selectionLbl.text = selectionList[currentIndex]
        selectionLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(selectionLbl)
        
        leftArrowImg = UIImageView()
        leftArrowImg.contentMode = .ScaleAspectFit
        leftArrowImg.image = UIImage(named: "v2_play_setting_left_arrow_selected")
        self.addSubview(leftArrowImg)
        
        rightArrowImg = UIImageView()
        rightArrowImg.contentMode = .ScaleAspectFit
        rightArrowImg.image = UIImage(named: "v2_play_setting_right_arrow_selected")
        self.addSubview(rightArrowImg)
        
        setConstraints()
        
        leftArrowImg.addOnClickListener(self, action: #selector(self.leftClick))
        rightArrowImg.addOnClickListener(self, action: #selector(self.rightClick))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints(){
        backgroundImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        iconImg.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self).dividedBy(2.5)
            make.width.equalTo(iconImg.snp_height)
            make.left.equalTo(self).offset(10)
        }
        
        nameLbl.snp_makeConstraints { (make) in
            make.left.equalTo(iconImg.snp_right).offset(5)
            make.centerY.equalTo(self)
        }
        
        rightArrowImg.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(iconImg)
        }
        
        leftArrowImg.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.width.equalTo(rightArrowImg)
            make.left.equalTo(self.snp_right).multipliedBy(0.75)
        }
        
        selectionLbl.snp_makeConstraints { (make) in
            make.left.equalTo(leftArrowImg.snp_right)
            make.right.equalTo(rightArrowImg.snp_left)
            make.centerY.equalTo(self)
        }
        
    }
    
    func leftClick(){
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = selectionList.count - 1
        }
        selectionLbl.text = selectionList[currentIndex]
    }
    
    func rightClick(){
        currentIndex += 1
        if currentIndex >= selectionList.count {
            currentIndex = 0
        }
        selectionLbl.text = selectionList[currentIndex]
    }

}
