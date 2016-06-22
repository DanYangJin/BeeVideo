//
//  LivePageView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/4.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class LivePageView: BasePageView,UITableViewDataSource, UITableViewDelegate, ZXOptionBarDelegate, ZXOptionBarDataSource {
    
    private var favChannels:[ChannelInfo]?
    private var livePrograms:[ChannelProgram]?;
    private var dailyPrograms:[ChannelProgram]?
    
    var image:CornerImageView!
    var favTableView:UITableView!
    var liveTableView : ZXOptionBar!
    
    private var blockView1 : BlockView!
    private var blockView2 : BlockView!
    private var blockView3 : BlockView!
    
    
    override func initView(){
        super.initView()
        
        image = CornerImageView()
        image.setCorner(4.0)
        image.sd_setImageWithURL(NSURL(string: "http://img.beevideo.tv/filestore/1354/baanvuf78.jpg"), placeholderImage: UIImage(named: "girl"))
        addSubview(image)
        
        blockView1 = BlockView()
        blockView1.setData(homeSpace[1])
        addSubview(blockView1)
        
        blockView2 = BlockView()
        blockView2.setData(homeSpace[2])
        addSubview(blockView2)
        
        blockView3 = BlockView()
        blockView3.setData(homeSpace[3])
        addSubview(blockView3)
        
        
        favTableView = UITableView()
        // favTableView.frame = CGRect(x: 205, y: 0, width: 140, height: 210)
        favTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        favTableView.backgroundColor = UIColor.clearColor()
        favTableView.backgroundView = UIImageView(image: UIImage(named: "v2_live_fav_list_bg"))
        favTableView.tag = 0
        favTableView.dataSource = self
        favTableView.delegate = self
        favTableView.registerNib(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "FavTableCell")
        addSubview(favTableView)
        
        liveTableView = ZXOptionBar(frame: CGRectMake(350, 0, 360, 210), barDelegate: self, barDataSource: self)
        liveTableView.backgroundColor = UIColor.clearColor()
        addSubview(liveTableView)
        
        setConstraint()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favChannels?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return height/6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  favTableView:FavTableViewCell = tableView.dequeueReusableCellWithIdentifier("FavTableCell", forIndexPath: indexPath) as! FavTableViewCell
        favTableView.backgroundColor = UIColor.clearColor()
        favTableView.selectionStyle = .None
        favTableView.setImageView(favChannels![indexPath.row].channelPic)
        favTableView.setLabel(favChannels![indexPath.row].name)
        return favTableView
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    
    //横向TableView
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return 3
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "liveCell"
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
        
        cell?.videoNameLbl.text = livePrograms![index].name
        cell?.icon.sd_setImageWithURL(NSURL(string: livePrograms![index].iconId))
        cell?.durationLbl.text = livePrograms![index].timeStart
        cell?.averageLbl.hidden = true
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(height * 2/3)
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        //
    }
    
    func setConstraint(){
        image.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(height)
            make.height.equalTo(height * 0.65)
        }
        blockView1.snp_makeConstraints { (make) in
            make.left.equalTo(image)
            make.height.width.equalTo(height * 0.32)
            make.bottom.equalTo(self)
        }
        blockView2.snp_makeConstraints { (make) in
            make.top.equalTo(blockView1)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(height * 0.34)
            make.width.equalTo(blockView1)
        }
        
        blockView3.snp_makeConstraints { (make) in
            make.top.equalTo(blockView1)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(height * 0.68)
            make.width.equalTo(blockView1)
        }
        favTableView.snp_makeConstraints { (make) in
            make.top.equalTo(image)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(image.snp_right).offset(10)
            make.width.equalTo(height * 2/3)
        }
        liveTableView.snp_makeConstraints { (make) in
            make.top.equalTo(favTableView)
            make.bottom.equalTo(favTableView)
            make.left.equalTo(favTableView.snp_right).offset(10)
            make.width.equalTo(2 * height)
        }
        
    }
    
    
    internal func setData(homeSpace: [HomeSpace]?, _ favChannels:[ChannelInfo]?, _ livePrograms:[ChannelProgram]?, _ dailyPrograms:[ChannelProgram]?) {
        super.setData(homeSpace)
        self.favChannels = favChannels
        self.livePrograms = livePrograms
        self.dailyPrograms = dailyPrograms
    }
    
    
    override func getViewWidth() -> CGFloat {
        return height * 11/3 + 80
    }
    
    
}
