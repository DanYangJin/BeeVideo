//
//  LivePageView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/4.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class LivePageView: BasePageView,UITableViewDataSource, UITableViewDelegate, ZXOptionBarDelegate, ZXOptionBarDataSource {
    
    fileprivate var favChannels:[ChannelInfo]?
    fileprivate var livePrograms:[ChannelProgram]?;
    fileprivate var dailyPrograms:[ChannelProgram]?
    
    var image:CornerImageView!
    var favTableView:UITableView!
    var liveTableView : ZXOptionBar!
    
    fileprivate var blockView1 : BlockView!
    fileprivate var blockView2 : BlockView!
    fileprivate var blockView3 : BlockView!
    
    
    override func initView(){
        super.initView()
        
        image = CornerImageView()
        image.setCorner(4.0)
        image.sd_setImage(with: URL(string: "http://img.beevideo.tv/filestore/1354/baanvuf78.jpg"), placeholderImage: UIImage(named: "girl"))
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
        favTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        favTableView.backgroundColor = UIColor.clear
        favTableView.backgroundView = UIImageView(image: UIImage(named: "v2_live_fav_list_bg"))
        favTableView.tag = 0
        favTableView.dataSource = self
        favTableView.delegate = self
        favTableView.register(UINib(nibName: "FavTableViewCell", bundle: nil), forCellReuseIdentifier: "FavTableCell")
        addSubview(favTableView)
        
        liveTableView = ZXOptionBar(frame: CGRect(x: 350, y: 0, width: 360, height: 210), barDelegate: self, barDataSource: self)
        liveTableView.backgroundColor = UIColor.clear
        addSubview(liveTableView)
        
        setConstraint()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favChannels?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height/6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  favTableView:FavTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavTableCell", for: indexPath) as! FavTableViewCell
        favTableView.backgroundColor = UIColor.clear
        favTableView.selectionStyle = .none
        favTableView.setImageView(favChannels![(indexPath as NSIndexPath).row].channelPic)
        favTableView.setLabel(favChannels![(indexPath as NSIndexPath).row].name)
        return favTableView
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
    //横向TableView
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        return 3
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "liveCell"
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
        
//        cell?.videoNameLbl.text = livePrograms![index].name
//        cell?.icon.sd_setImage(with: URL(string: livePrograms![index].iconId))
//        cell?.durationLbl.text = livePrograms![index].timeStart
//        cell?.averageLbl.isHidden = true
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(height * 2/3)
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        //
    }
    
    func setConstraint(){
        image.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(height)
            make.height.equalTo(height * 0.65)
        }
        blockView1.snp.makeConstraints { (make) in
            make.left.equalTo(image)
            make.height.width.equalTo(height * 0.32)
            make.bottom.equalTo(self)
        }
        blockView2.snp.makeConstraints { (make) in
            make.top.equalTo(blockView1)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(height * 0.34)
            make.width.equalTo(blockView1)
        }
        
        blockView3.snp.makeConstraints { (make) in
            make.top.equalTo(blockView1)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(height * 0.68)
            make.width.equalTo(blockView1)
        }
        favTableView.snp.makeConstraints { (make) in
            make.top.equalTo(image)
            make.bottom.equalTo(blockView1)
            make.left.equalTo(image.snp.right).offset(10)
            make.width.equalTo(height * 2/3)
        }
        liveTableView.snp.makeConstraints { (make) in
            make.top.equalTo(favTableView)
            make.bottom.equalTo(favTableView)
            make.left.equalTo(favTableView.snp.right).offset(10)
            make.width.equalTo(2 * height)
        }
        
    }
    
    
    internal func setData(_ homeSpace: [HomeSpace]?, _ favChannels:[ChannelInfo]?, _ livePrograms:[ChannelProgram]?, _ dailyPrograms:[ChannelProgram]?) {
        super.setData(homeSpace)
        self.favChannels = favChannels
        self.livePrograms = livePrograms
        self.dailyPrograms = dailyPrograms
    }
    
    
    override func getViewWidth() -> CGFloat {
        return height * 11/3 + 80
    }
    
    
}
