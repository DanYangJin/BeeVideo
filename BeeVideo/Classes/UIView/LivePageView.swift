//
//  LivePageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class LivePageView: BasePageView ,UITableViewDataSource, UITableViewDelegate, ZXOptionBarDelegate, ZXOptionBarDataSource{
    
    private var favChannels:[ChannelInfo]?
    private var livePrograms:[ChannelProgram]?;
    private var dailyPrograms:[ChannelProgram]?
    
    var image:CornerImageView!
    var favTableView:UITableView!
    var liveTableView : ZXOptionBar!
    
    
    override func initView(){
        super.initView()
        
        image = CornerImageView(frame: CGRectMake(0, 0, 205, 140))
        image.sd_setImageWithURL(NSURL(string: "http://img.beevideo.tv/filestore/1354/baanvuf78.jpg"), placeholderImage: UIImage(named: "girl"))
        addSubview(image)
        
        for index in 0 ..< 3 {
            let blockView = BlockView()
            blockView.initFrame(CGFloat(70 * index), y: 150, width: 65, height: 60)
            blockView.initView(super.homeSpace![index + 1])
            
            addSubview(blockView)
        }
        
        favTableView = UITableView()
        favTableView.frame = CGRect(x: 205, y: 0, width: 140, height: 210)
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
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favChannels?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35.0
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
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return 120
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        //
    }
    
    
    internal func setData(homeSpace: [HomeSpace]?, _ favChannels:[ChannelInfo]?, _ livePrograms:[ChannelProgram]?, _ dailyPrograms:[ChannelProgram]?) {
        super.setData(homeSpace)
        self.favChannels = favChannels
        self.livePrograms = livePrograms
        self.dailyPrograms = dailyPrograms
    }
    
    
    override func getViewWidth() -> CGFloat {
        return 770
    }
    

}
