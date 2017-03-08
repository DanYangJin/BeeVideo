//
//  BaseBackViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/31.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class BaseBackViewController: BaseViewController {
    
    var backView : UIButton!
    var titleLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView = UIButton()
        backView.setImage(UIImage(named: "v2_title_arrow_default"), for: UIControlState())
        backView.setImage(UIImage(named: "v2_title_arrow_selected"), for: .highlighted)
        backView.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.top.equalTo(view).offset(20)
            make.width.height.equalTo(40)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.textColor = UIColor.white
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView.snp.right)
        }
        
    }

    
}
