//
//  LivePageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class LivePageView: BasePageView ,UITableViewDataSource, UITableViewDelegate{
    
    private var favChannels:[ChannelInfo]?
    private var livePrograms:[ChannelProgram]?;
    private var dailyPrograms:[ChannelProgram]?
    
    var image:CornerImageView!
    var favTableView:UITableView!
    var liveTableView:UITableView!
    
    
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
        
//        favTableView = UITableView()
//        favTableView.frame = CGRect(x: 205, y: 0, width: 150, height: 210)
//        favTableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        favTableView.backgroundColor = UIColor.grayColor()
//        favTableView.tag = 0
//        favTableView.dataSource = self
//        favTableView.delegate = self
//        favTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FavTableCell")
//        addSubview(favTableView)
        
        liveTableView = UITableView()
        liveTableView.frame = CGRect(x: 325, y: 0, width: 400, height: 210)
        liveTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        liveTableView.tag = 1
        liveTableView.dataSource = self
        liveTableView.delegate = self
        liveTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LiveTableCell")
        addSubview(liveTableView)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favChannels?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let  liveViewCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LiveTableCell", forIndexPath: indexPath)
        liveViewCell.backgroundColor = UIColor.clearColor()
//        liveViewCell.imageView?.sd_setImageWithURL(NSURL(string: favChannels![indexPath.row].channelPic))
//        liveViewCell.textLabel?.text = favChannels![indexPath.row].name
        
        return liveViewCell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    internal func setData(homeSpace: [HomeSpace]?, _ favChannels:[ChannelInfo]?, _ livePrograms:[ChannelProgram]?, _ dailyPrograms:[ChannelProgram]?) {
        super.setData(homeSpace)
        self.favChannels = favChannels
        self.livePrograms = livePrograms
        self.dailyPrograms = dailyPrograms
    }
    
    
    override func getViewWidth() -> CGFloat {
        return 725
    }
    

}
