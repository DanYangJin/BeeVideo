//
//  BaseBackViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/31.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class BaseBackViewController: BaseViewController {
    
    var backView : BackView!
    var titleLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView = BackView()
        backView.addOnClickListener(self, action: #selector(self.dismissViewController))
        view.addSubview(backView)
        backView.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.top.equalTo(view).offset(20)
            make.width.height.equalTo(30)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(14)
        titleLbl.textColor = UIColor.whiteColor()
        view.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView.snp_right)
        }
        
    }

    
}
