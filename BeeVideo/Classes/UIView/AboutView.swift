//
//  AboutView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class AboutView: UIView,UITableViewDelegate,UITableViewDataSource {

    fileprivate var backgroundImg : UIImageView!
    fileprivate var qCodeImg : UIImageView!
    fileprivate var infoTable : UITableView!
    fileprivate var aboutLbl : UILabel!
    fileprivate var versionLbl : UILabel!
    
    fileprivate var items = DataFactory.aboutItems
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundView()
        initQCodeImg()
        initTableView()
        initLbl()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "AboutSettingCell"
    
        let cell : AboutSettingCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AboutSettingCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
//        cell.setInco(items[indexPath.row].picUrl)
//        cell.setInfo(items[indexPath.row].desp)
        cell.iconImage.image = UIImage(named: items[(indexPath as NSIndexPath).row].picUrl)
        cell.infoLbl.text = items[(indexPath as NSIndexPath).row].desp
        cell.infoLbl.font = UIFont.systemFont(ofSize: 11)
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    
    fileprivate func initTableView(){
        infoTable = UITableView()//frame: CGRectMake((frame.width - 100)/2, 120, (frame.width + 100)/2, 60))
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.register(UINib(nibName: "AboutSettingCell", bundle: nil), forCellReuseIdentifier: "AboutSettingCell")
        infoTable.backgroundColor = UIColor.clear
        infoTable.separatorStyle = .none
        addSubview(infoTable)
    }
    
    
    
    fileprivate func initBackgroundView(){
        backgroundImg = UIImageView()//frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundImg.contentMode = .scaleToFill
        backgroundImg.image = UIImage(named: "v2_setting_about_bg")
        addSubview(backgroundImg)
    }
    
    fileprivate func initQCodeImg(){
        qCodeImg = UIImageView()//frame: CGRectMake((frame.width - 100)/2, 20, 100, 100))
        qCodeImg.image = UIImage(named: "v2_setting_about_qr_code")
        addSubview(qCodeImg)
    }
    
    fileprivate func initLbl(){
        aboutLbl = UILabel()//frame: CGRectMake(0, frame.height - 20, frame.width/2, 20))
        aboutLbl.textColor = UIColor.white
        aboutLbl.text = "关于|升级"
        aboutLbl.textAlignment = .right
        aboutLbl.font = UIFont.systemFont(ofSize: 12)
        addSubview(aboutLbl)
        
        versionLbl = UILabel()//frame: CGRectMake(frame.width/2 + 5, frame.height - 20, frame.width/2 - 5, 20))
        versionLbl.textColor = UIColor.gray
        versionLbl.text = "1.0.0"
        versionLbl.font = UIFont.systemFont(ofSize: 11)
        addSubview(versionLbl)
    }
    
    fileprivate func setConstraints(){
        backgroundImg.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
        qCodeImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImg)
            make.top.equalTo(backgroundImg).offset(30)
            make.width.height.equalTo(backgroundImg.snp.width).multipliedBy(0.6)
        }
        
        infoTable.snp.makeConstraints { (make) in
            make.left.equalTo(qCodeImg)
            make.top.equalTo(qCodeImg.snp.bottom).offset(5)
            make.right.equalTo(backgroundImg)
            make.bottom.equalTo(backgroundImg).offset(-20)
        }
        
        aboutLbl.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundImg.snp.bottom).offset(-20)
            make.bottom.equalTo(backgroundImg)
            make.left.equalTo(backgroundImg)
            make.width.equalTo(backgroundImg.snp.width).dividedBy(2)
        }
        
        versionLbl.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(aboutLbl)
            make.left.equalTo(aboutLbl.snp.right).offset(5)
            make.right.equalTo(backgroundImg)
        }
    }
    
    
    
    
}
