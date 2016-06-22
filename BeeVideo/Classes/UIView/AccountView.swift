//
//  AccountView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class AccountView: UIView {

    private var backreoundImg:UIImageView!
    private var iconImg:UIImageView!
    private var dividerImg:UIImageView!
    var nameLbl:UILabel!
    private var currentNameLbl:UILabel!
    var currentPointLbl:UILabel!
    private var allNameLbl:UILabel!
    var allPointLbl:UILabel!
    var levelLbl:UILabel!
    private var levelLblImg:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backreoundImg = UIImageView()
        backreoundImg.contentMode = .Redraw
        backreoundImg.image = UIImage(named: "v2_account_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20,left: 50,bottom: 20,right: 50), resizingMode: .Stretch)
        self.addSubview(backreoundImg)
        backreoundImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        iconImg = UIImageView()
        iconImg.image = UIImage(named: "v2_account_head_default")
        iconImg.contentMode = .ScaleAspectFill
        self.addSubview(iconImg)
        iconImg.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self.snp_height).dividedBy(2)
            make.centerX.equalTo(self.snp_right).dividedBy(6)
            
        }
        
        dividerImg = UIImageView()
        dividerImg.contentMode = .ScaleToFill
        dividerImg.image = UIImage(named: "v2_account_table_divider")
        self.addSubview(dividerImg)
        dividerImg.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_right).dividedBy(3)
            make.height.equalTo(self).multipliedBy(0.8)
            make.centerY.equalTo(self)
            make.width.equalTo(2)
        }
        
        nameLbl = UILabel()
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.text = "bee233443"
        self.addSubview(nameLbl)
        nameLbl.snp_makeConstraints { (make) in
            make.left.equalTo(dividerImg).offset(30)
            make.top.equalTo(self.snp_bottom).dividedBy(3)
        }
        
        currentNameLbl = UILabel()
        currentNameLbl.textColor = UIColor.whiteColor()
        currentNameLbl.font = UIFont.systemFontOfSize(11)
        currentNameLbl.text = "当前积分："
        self.addSubview(currentNameLbl)
        currentNameLbl.snp_makeConstraints { (make) in
            make.left.equalTo(nameLbl)
            make.top.equalTo(self.snp_bottom).multipliedBy(0.6)
        }
        
        currentPointLbl = UILabel()
        currentPointLbl.textColor = UIColor.whiteColor()
        currentPointLbl.font = UIFont.systemFontOfSize(11)
        self.addSubview(currentPointLbl)
        currentPointLbl.snp_makeConstraints { (make) in
            make.left.equalTo(currentNameLbl.snp_right)
            make.centerY.equalTo(currentNameLbl)
        }
        
        allNameLbl = UILabel()
        allNameLbl.textColor = UIColor.colorWithHexString("767676")
        allNameLbl.font = UIFont.systemFontOfSize(11)
        allNameLbl.text = "总积分："
        self.addSubview(allNameLbl)
        allNameLbl.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_right).multipliedBy(0.7)
            make.centerY.equalTo(currentNameLbl)
        }
        
        allPointLbl = UILabel()
        allPointLbl.textColor = UIColor.colorWithHexString("767676")
        allPointLbl.font = UIFont.systemFontOfSize(11)
        self.addSubview(allPointLbl)
        allPointLbl.snp_makeConstraints { (make) in
            make.left.equalTo(allNameLbl.snp_right)
            make.centerY.equalTo(currentNameLbl)
        }
        
        levelLblImg = UIImageView()
        levelLblImg.contentMode = .ScaleToFill
        levelLblImg.image = UIImage(named: "v2_account_level_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 18,left: 18,bottom: 18,right: 18), resizingMode: .Stretch)
        self.addSubview(levelLblImg)
        
        levelLbl = UILabel()
        levelLbl.textColor = UIColor.whiteColor()
        levelLbl.font = UIFont.systemFontOfSize(10)
        levelLbl.text = "铜牌会员"
        self.addSubview(levelLbl)
        levelLbl.snp_makeConstraints { (make) in
            make.left.equalTo(nameLbl.snp_right).offset(5)
            make.bottom.equalTo(nameLbl.snp_top)
            
        }
        
        levelLblImg.snp_makeConstraints { (make) in
           make.center.equalTo(levelLbl)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
