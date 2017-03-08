//
//  PlaySettingItemView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/6.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class PlaySettingItemView: UIView {

    var iconImg:UIImageView!
    var contentChanged:Bool = false
    fileprivate var backgroundImg:UIImageView!
    fileprivate var nameLbl:UILabel!
    fileprivate var selectionLbl:UILabel!
    fileprivate var leftArrowImg:UIImageView!
    fileprivate var rightArrowImg:UIImageView!
    
    fileprivate var index = 0
    
    var currentIndex:Int{
        set{
            self.index = newValue
            selectionLbl.text = selectionList[newValue]
        }
        get{
            return self.index
        }
    }
    var selectionList:[String]!
    
    init(frame: CGRect,title: String,selectionList: [String]) {
        super.init(frame: frame)
        self.selectionList = selectionList
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .redraw
        backgroundImg.image = UIImage(named: "v2_play_setting_item_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        self.addSubview(backgroundImg)
        
        iconImg = UIImageView()
        iconImg.contentMode = .scaleAspectFill
        self.addSubview(iconImg)
        
        nameLbl = UILabel()
        nameLbl.textColor = UIColor.white
        nameLbl.text = title
        nameLbl.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(nameLbl)
        
        selectionLbl = UILabel()
        selectionLbl.textColor = UIColor.textBlueColor()
        selectionLbl.textAlignment = .center
        selectionLbl.text = selectionList[currentIndex]
        selectionLbl.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(selectionLbl)
        
        leftArrowImg = UIImageView()
        leftArrowImg.contentMode = .scaleAspectFit
        leftArrowImg.image = UIImage(named: "v2_play_setting_left_arrow_selected")
        self.addSubview(leftArrowImg)
        
        rightArrowImg = UIImageView()
        rightArrowImg.contentMode = .scaleAspectFit
        rightArrowImg.image = UIImage(named: "v2_play_setting_right_arrow_selected")
        self.addSubview(rightArrowImg)
        
        setConstraints()
        
        leftArrowImg.addOnClickListener(self, action: #selector(self.leftClick))
        rightArrowImg.addOnClickListener(self, action: #selector(self.rightClick))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setConstraints(){
        backgroundImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self).dividedBy(2.5)
            make.width.equalTo(iconImg.snp.height)
            make.left.equalTo(self).offset(10)
        }
        
        nameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(iconImg.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        
        rightArrowImg.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(iconImg)
        }
        
        leftArrowImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.width.equalTo(rightArrowImg)
            make.left.equalTo(self.snp.right).multipliedBy(0.75)
        }
        
        selectionLbl.snp.makeConstraints { (make) in
            make.left.equalTo(leftArrowImg.snp.right)
            make.right.equalTo(rightArrowImg.snp.left)
            make.centerY.equalTo(self)
        }
        
    }
    
    func leftClick(){
        index -= 1
        if index < 0 {
            index = selectionList.count - 1
        }
        selectionLbl.text = selectionList[index]
        contentChanged = true
    }
    
    func rightClick(){
        index += 1
        if index >= selectionList.count {
            index = 0
        }
        selectionLbl.text = selectionList[index]
        contentChanged = true
    }

}
