//
//  VideoDetailInfoView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol DetailBtnClickDelegate {
    func detailBtnClick(index: Int)
}


class VideoDetailInfoView: UIView,ZXOptionBarDataSource,ZXOptionBarDelegate {
    
    var backBtn : UIButton!
    private var videoTitleLbl : UILabel!
    private var directorLbl : UILabel!
    private var videoDirectorLbl : UILabel!
    private var cateLbl : UILabel!
    private var videoCateLbl : UILabel!
    private var areaLbl : UILabel!
    private var videoAreaLbl : UILabel!
    private var publishLbl : UILabel!
    private var videoPublishLbl : UILabel!
    private var dramaLbl : UILabel! // 集数 ，时长
    private var videoDramaLbl : UILabel!
    private var actorLbl : UILabel!
    private var videoActorLbl : UILabel!
    private var descLbl : UILabel!
    private var videoDescLbl : VerticalAlignmentLabel!
    var mOptionBar:ZXOptionBar!
    
    weak var delegate:DetailBtnClickDelegate!
    
    var btnItems:[Item] = [Item]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initView(){
        backBtn = UIButton()
        backBtn.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        self.addSubview(backBtn)
        
        videoTitleLbl = UILabel()
        videoTitleLbl.textColor = UIColor.whiteColor()
        self.addSubview(videoTitleLbl)
        
        directorLbl = UILabel()
        setCommenAttr(directorLbl)
        directorLbl.text = "导演:"
        self.addSubview(directorLbl)
        
        videoDirectorLbl = UILabel()
        setCommenAttr(videoDirectorLbl)
        self.addSubview(videoDirectorLbl)
        
        cateLbl = UILabel()
        setCommenAttr(cateLbl)
        cateLbl.text = "类型:"
        self.addSubview(cateLbl)
        
        videoCateLbl = UILabel()
        setCommenAttr(videoCateLbl)
        videoCateLbl.text = "测试"
        self.addSubview(videoCateLbl)
        
        areaLbl = UILabel()
        setCommenAttr(areaLbl)
        areaLbl.text = "地区:"
        self.addSubview(areaLbl)
        
        videoAreaLbl = UILabel()
        setCommenAttr(videoAreaLbl)
        videoAreaLbl.text = "测试"
        self.addSubview(videoAreaLbl)
        
        publishLbl = UILabel()
        setCommenAttr(publishLbl)
        publishLbl.text = "年代:"
        self.addSubview(publishLbl)
        
        videoPublishLbl = UILabel()
        setCommenAttr(videoPublishLbl)
        videoPublishLbl.text = "测试"
        self.addSubview(videoPublishLbl)
        
        dramaLbl = UILabel()
        setCommenAttr(dramaLbl)
        dramaLbl.text = "时长:"
        self.addSubview(dramaLbl)
        
        videoDramaLbl = UILabel()
        videoDramaLbl.textColor = UIColor.orangeColor()
        videoDramaLbl.text = "测试"
        videoDramaLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(videoDramaLbl)
        
        actorLbl = UILabel()
        setCommenAttr(actorLbl)
        actorLbl.text = "演员:"
        self.addSubview(actorLbl)
        
        videoActorLbl = UILabel()
        setCommenAttr(videoActorLbl)
        self.addSubview(videoActorLbl)
        
        descLbl = UILabel()
        setCommenAttr(descLbl)
        descLbl.text = "剧情介绍:"
        self.addSubview(descLbl)
        
        videoDescLbl = VerticalAlignmentLabel()
        setCommenAttr(videoDescLbl)
        videoDescLbl.setVerticalAlignmentMode(VerticalAlignmentLabel.VerticalAlignmentMode.VerticalAlignmentTop)
        videoDescLbl.numberOfLines = 0
        self.addSubview(videoDescLbl)
        
        mOptionBar = ZXOptionBar(frame: CGRectZero, barDelegate: self, barDataSource: self)
        mOptionBar.setDividerWidth(dividerWidth: 5)
        mOptionBar.backgroundColor = UIColor.clearColor()
        self.addSubview(mOptionBar)
    }
    
    private func setConstraint(){
        backBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        videoTitleLbl.snp_makeConstraints { (make) in
            make.top.equalTo(backBtn)
            make.bottom.equalTo(backBtn)
            make.leading.equalTo(backBtn.snp_trailing).offset(5)
            make.trailing.equalTo(self).offset(-5)
        }
        directorLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backBtn)
            make.top.equalTo(backBtn.snp_bottom).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(16)
        }
        videoDirectorLbl.snp_makeConstraints { (make) in
            make.top.equalTo(directorLbl)
            make.bottom.equalTo(directorLbl)
            make.leading.equalTo(directorLbl.snp_trailing).offset(2)
            make.width.equalTo(self.frame.width * 1/3 - 30)
            //make.trailing.equalTo(self).offset(-(self.frame.width * 2/3))
        }
        cateLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(videoDirectorLbl.snp_trailing).offset(2)
            make.top.equalTo(videoDirectorLbl)
            make.bottom.equalTo(videoDirectorLbl)
            make.width.equalTo(30)
        }
        videoCateLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(cateLbl.snp_trailing).offset(2)
            make.top.equalTo(cateLbl)
            make.bottom.equalTo(cateLbl)
            make.width.equalTo(self.frame.width * 1/3 - 30)
        }
        areaLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(videoCateLbl.snp_trailing).offset(2)
            make.top.equalTo(cateLbl)
            make.bottom.equalTo(cateLbl)
            make.width.equalTo(30)
        }
        videoAreaLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(areaLbl.snp_trailing).offset(2)
            make.top.equalTo(cateLbl)
            make.bottom.equalTo(cateLbl)
            make.trailing.equalTo(self).offset(-5)
        }
        publishLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(directorLbl)
            make.trailing.equalTo(directorLbl)
            make.top.equalTo(directorLbl.snp_bottom).offset(5)
            make.height.equalTo(16)
        }
        videoPublishLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(videoDirectorLbl)
            make.trailing.equalTo(videoDirectorLbl)
            make.top.equalTo(publishLbl)
            make.bottom.equalTo(publishLbl)
        }
        dramaLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(cateLbl)
            make.trailing.equalTo(cateLbl)
            make.top.equalTo(publishLbl)
            make.bottom.equalTo(publishLbl)
        }
        videoDramaLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(videoCateLbl)
            make.trailing.equalTo(videoCateLbl)
            make.top.equalTo(publishLbl)
            make.bottom.equalTo(publishLbl)
        }
        actorLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(directorLbl)
            make.trailing.equalTo(directorLbl)
            make.top.equalTo(publishLbl.snp_bottom).offset(5)
            make.height.equalTo(16)
        }
        videoActorLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(videoDirectorLbl)
            make.trailing.equalTo(self).offset(-5)
            make.top.equalTo(actorLbl)
            make.bottom.equalTo(actorLbl)
        }
        descLbl.snp_makeConstraints { (make) in
            make.leading.equalTo(actorLbl)
            make.top.equalTo(actorLbl.snp_bottom).offset(5)
            make.height.equalTo(16)
        }
        videoDescLbl.snp_makeConstraints { (make) in
            make.left.equalTo(descLbl)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(descLbl.snp_bottom)
            make.bottom.equalTo(mOptionBar.snp_top)
            //make.bottom.equalTo(playBtn.snp_top).offset(-5)
        }
        mOptionBar.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(30)
        }
        
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(self.frame.width * 3/4)/4
    }
    
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return btnItems.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        
        var cell:VideoDetailBtnCell? = optionBar.dequeueReusableCellWithIdentifier("detailCell") as? VideoDetailBtnCell
        
        if cell == nil {
            cell = VideoDetailBtnCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: "detailCell")
        }
        cell?.setViewData(btnItems[index])
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        if delegate != nil {
            delegate.detailBtnClick(index)
        }
    }
    
    private func setCommenAttr(label:UILabel){
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(12)
    }
    
    func setData(videoDetailInfo: VideoDetailInfo){
        videoTitleLbl.text = videoDetailInfo.name
        videoDirectorLbl.text = videoDetailInfo.directorString
        videoCateLbl.text = videoDetailInfo.category
        videoAreaLbl.text = videoDetailInfo.area
        videoPublishLbl.text = videoDetailInfo.publishTime
        videoDramaLbl.text = videoDetailInfo.duration
        videoActorLbl.text = videoDetailInfo.actorString
        videoDescLbl.text = videoDetailInfo.desc
        collectDramaList(videoDetailInfo)
    }
    
    private func collectDramaList(videoDetailInfo: VideoDetailInfo){
        let isChooseDramaNeeded = VideoInfoUtils.isChooseDramaNeeded(videoDetailInfo)
        if isChooseDramaNeeded {
            let totalSize = videoDetailInfo.dramas.count
            let readablePositon = VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: totalSize, index: videoDetailInfo.lastPlayDramaPosition)
            let playItem = Item(icon: "v2_video_detail_op_play_bg_normal", title: "第\(readablePositon)集", position: VideoInfoUtils.OP_POSITION_PLAY)
            btnItems.append(playItem)
        }else{
            btnItems.append(Item(icon: "v2_video_detail_op_play_bg_normal", title: "播放", position: VideoInfoUtils.OP_POSITION_PLAY))
        }
        if isChooseDramaNeeded {
            btnItems.append(Item(icon: "v2_video_detail_op_choose_drama_bg_normal", title: "选集", position: VideoInfoUtils.OP_POSITION_CHOOSE))
        }
        btnItems.append(Item(icon: "v2_my_video_download_bg_normal", title: "下载", position: VideoInfoUtils.OP_POSITION_DOWNLOAD))
        if videoDetailInfo.isFavorite {
            btnItems.append(Item(icon: "v2_my_video_like_bg_favorited", title: "收藏", position: VideoInfoUtils.OP_POSITION_FAV))
        }else{
            btnItems.append(Item(icon: "v2_my_video_like_bg_normal", title: "收藏", position: VideoInfoUtils.OP_POSITION_FAV))
        }
        mOptionBar.reloadData()
    }
    
    class Item{
        var icon:String!
        var title:String!
        var position:Int!
        
        init(icon: String,title: String,position: Int){
            self.icon = icon
            self.title = title
            self.position = position
        }
    }
    
}
