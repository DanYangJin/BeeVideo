//
//  AboutView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class AboutView: UIView,UITableViewDelegate,UITableViewDataSource {

    private var backgroundImg : UIImageView!
    private var qCodeImg : UIImageView!
    private var infoTable : UITableView!
    private var aboutLbl : UILabel!
    private var versionLbl : UILabel!
    
    private var items = DataFactory.aboutItems
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundView()
        initQCodeImg()
        initTableView()
        initLbl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "AboutSettingCell"
    
        let cell : AboutSettingCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! AboutSettingCell
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
//        cell.setInco(items[indexPath.row].picUrl)
//        cell.setInfo(items[indexPath.row].desp)
        cell.iconImage.image = UIImage(named: items[indexPath.row].picUrl)
        cell.infoLbl.text = items[indexPath.row].desp
        cell.infoLbl.font = UIFont.systemFontOfSize(11)
        return  cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    
    private func initTableView(){
        infoTable = UITableView(frame: CGRectMake((frame.width - 100)/2, 120, (frame.width + 100)/2, 60))
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.registerNib(UINib(nibName: "AboutSettingCell", bundle: nil), forCellReuseIdentifier: "AboutSettingCell")
        infoTable.backgroundColor = UIColor.clearColor()
        infoTable.separatorStyle = .None
        addSubview(infoTable)
    }
    
    
    
    private func initBackgroundView(){
        backgroundImg = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        backgroundImg.contentMode = .ScaleAspectFill
        backgroundImg.image = UIImage(named: "v2_setting_about_bg")
        addSubview(backgroundImg)
    }
    
    private func initQCodeImg(){
        qCodeImg = UIImageView(frame: CGRectMake((frame.width - 100)/2, 20, 100, 100))
        qCodeImg.image = UIImage(named: "v2_setting_about_qr_code")
        addSubview(qCodeImg)
    }
    
    private func initLbl(){
        aboutLbl = UILabel(frame: CGRectMake(0, frame.height - 20, frame.width/2, 20))
        aboutLbl.textColor = UIColor.whiteColor()
        aboutLbl.text = "关于|升级"
        aboutLbl.textAlignment = .Right
        aboutLbl.font = UIFont.systemFontOfSize(12)
        addSubview(aboutLbl)
        
        versionLbl = UILabel(frame: CGRectMake(frame.width/2 + 5, frame.height - 20, frame.width/2 - 5, 20))
        versionLbl.textColor = UIColor.grayColor()
        versionLbl.text = "1.0.0"
        versionLbl.font = UIFont.systemFontOfSize(11)
        addSubview(versionLbl)
    }
    
    
}
