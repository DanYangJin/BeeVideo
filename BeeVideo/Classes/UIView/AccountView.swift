//
//  AccountView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class AccountView: UIView {

    fileprivate var backreoundImg:UIImageView!
    fileprivate var iconImg:UIImageView!
    fileprivate var dividerImg:UIImageView!
    var nameLbl:UILabel!
    fileprivate var currentNameLbl:UILabel!
    var currentPointLbl:UILabel!
    fileprivate var allNameLbl:UILabel!
    var allPointLbl:UILabel!
    var levelLbl:UILabel!
    fileprivate var levelLblImg:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backreoundImg = UIImageView()
        backreoundImg.contentMode = .redraw
        backreoundImg.image = UIImage(named: "v2_account_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20,left: 50,bottom: 20,right: 50), resizingMode: .stretch)
        self.addSubview(backreoundImg)
        backreoundImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        iconImg = UIImageView()
        iconImg.image = UIImage(named: "v2_account_head_default")
        iconImg.contentMode = .scaleAspectFill
        self.addSubview(iconImg)
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self).dividedBy(2)
            make.width.equalTo(self.snp.height).dividedBy(2)
            make.centerX.equalTo(self.snp.right).dividedBy(6)
            
        }
        
        dividerImg = UIImageView()
        dividerImg.contentMode = .scaleToFill
        dividerImg.image = UIImage(named: "v2_account_table_divider")
        self.addSubview(dividerImg)
        dividerImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.right).dividedBy(3)
            make.height.equalTo(self).multipliedBy(0.8)
            make.centerY.equalTo(self)
            make.width.equalTo(2)
        }
        
        nameLbl = UILabel()
        nameLbl.textColor = UIColor.white
        nameLbl.text = "bee233443"
        self.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(dividerImg).offset(30)
            make.top.equalTo(self.snp.bottom).dividedBy(3)
        }
        
        currentNameLbl = UILabel()
        currentNameLbl.textColor = UIColor.white
        currentNameLbl.font = UIFont.systemFont(ofSize: 11)
        currentNameLbl.text = "当前积分："
        self.addSubview(currentNameLbl)
        currentNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(nameLbl)
            make.top.equalTo(self.snp.bottom).multipliedBy(0.6)
        }
        
        currentPointLbl = UILabel()
        currentPointLbl.textColor = UIColor.white
        currentPointLbl.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(currentPointLbl)
        currentPointLbl.snp.makeConstraints { (make) in
            make.left.equalTo(currentNameLbl.snp.right)
            make.centerY.equalTo(currentNameLbl)
        }
        
        allNameLbl = UILabel()
        allNameLbl.textColor = UIColor.colorWithHexString("767676")
        allNameLbl.font = UIFont.systemFont(ofSize: 11)
        allNameLbl.text = "总积分："
        self.addSubview(allNameLbl)
        allNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.right).multipliedBy(0.7)
            make.centerY.equalTo(currentNameLbl)
        }
        
        allPointLbl = UILabel()
        allPointLbl.textColor = UIColor.colorWithHexString("767676")
        allPointLbl.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(allPointLbl)
        allPointLbl.snp.makeConstraints { (make) in
            make.left.equalTo(allNameLbl.snp.right)
            make.centerY.equalTo(currentNameLbl)
        }
        
        levelLblImg = UIImageView()
        levelLblImg.contentMode = .scaleToFill
        levelLblImg.image = UIImage(named: "v2_account_level_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 18,left: 18,bottom: 18,right: 18), resizingMode: .stretch)
        self.addSubview(levelLblImg)
        
        levelLbl = UILabel()
        levelLbl.textColor = UIColor.white
        levelLbl.font = UIFont.systemFont(ofSize: 10)
        levelLbl.text = "铜牌会员"
        self.addSubview(levelLbl)
        levelLbl.snp.makeConstraints { (make) in
            make.left.equalTo(nameLbl.snp.right).offset(5)
            make.bottom.equalTo(nameLbl.snp.top)
            
        }
        
        levelLblImg.snp.makeConstraints { (make) in
           make.center.equalTo(levelLbl)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
