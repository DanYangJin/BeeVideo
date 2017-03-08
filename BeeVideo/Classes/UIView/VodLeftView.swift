//
//  VodLeftView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 点播列表左侧view
 */

class VodLeftView: UIView {

    var topArrow : UIImageView!
    var bottomArrow : UIImageView!
    var tableView : UITableView!
    fileprivate var backgroundImg : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .redraw
        backgroundImg.image = UIImage(named: "v2_search_keyboard_background")?.resizableImage(withCapInsets: UIEdgeInsets(top: 4,left: 20,bottom: 4,right: 20), resizingMode: .stretch)
        self.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        topArrow = UIImageView()
        topArrow.image = UIImage(named: "v2_vod_list_arrow_top")
        topArrow.contentMode = .scaleAspectFill
        self.addSubview(topArrow)
        topArrow.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.top.equalTo(20)
        }
        
        bottomArrow = UIImageView()
        bottomArrow.image = UIImage(named: "v2_vod_list_arrow_bottom")
        bottomArrow.contentMode = .scaleAspectFill
        self.addSubview(bottomArrow)
        bottomArrow.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.centerX.equalTo(self)
        }
        
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topArrow.snp.bottom).offset(10)
            make.left.equalTo(self)
            make.bottom.equalTo(bottomArrow.snp.top).offset(-10)
            make.width.equalTo(self)
        }
    }
    
}
