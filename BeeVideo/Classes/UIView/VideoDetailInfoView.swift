//
//  VideoDetailInfoView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoDetailInfoView: UIView {
    
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
    var playBtn : ImageButton!
    var chooseBtn : ImageButton!
    var downloadBtn : ImageButton!
    var faviBtn : ImageButton!
    
    
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
        //videoTitleLbl.text = "测试信息122113414143121"
        //setCommenAttr(videoTitleLbl)
        videoTitleLbl.textColor = UIColor.whiteColor()
        //videoTitleLbl.backgroundColor = UIColor.redColor()
        self.addSubview(videoTitleLbl)
        
        directorLbl = UILabel()
        setCommenAttr(directorLbl)
        //directorLbl.backgroundColor = UIColor.redColor()
        directorLbl.text = "导演:"
        self.addSubview(directorLbl)
        
        videoDirectorLbl = UILabel()
        setCommenAttr(videoDirectorLbl)
        //videoDirectorLbl.backgroundColor = UIColor.redColor()
        //videoDirectorLbl.text = "测试信息"
        self.addSubview(videoDirectorLbl)
        
        cateLbl = UILabel()
        setCommenAttr(cateLbl)
        cateLbl.text = "类型:"
        self.addSubview(cateLbl)
        //cateLbl = UILabel
        
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
        //videoAreaLbl.backgroundColor = UIColor.redColor()
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
        //videoDescLbl.backgroundColor = UIColor.yellowColor()
        videoDescLbl.setVerticalAlignmentMode(VerticalAlignmentLabel.VerticalAlignmentMode.VerticalAlignmentTop)
        videoDescLbl.numberOfLines = 0
        self.addSubview(videoDescLbl)
        
        playBtn = ImageButton()
        playBtn.setImage("v2_video_detail_op_play_bg_normal")
        playBtn.setTitle("第1集")
        self.addSubview(playBtn)
        
        chooseBtn = ImageButton()
        chooseBtn.setImage("v2_video_detail_op_choose_drama_bg_normal")
        chooseBtn.setTitle("选集")
        self.addSubview(chooseBtn)
        
        downloadBtn = ImageButton()
        downloadBtn.setImage("v2_my_video_download_bg_normal")
        downloadBtn.setTitle("下载")
        self.addSubview(downloadBtn)
        
        faviBtn = ImageButton()
        faviBtn.setImage("v2_my_video_like_bg_normal")
        faviBtn.setTitle("收藏")
        self.addSubview(faviBtn)
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
            make.bottom.equalTo(playBtn.snp_top).offset(-5)
        }
        playBtn.snp_makeConstraints { (make) in
            make.left.equalTo(backBtn)
            make.height.equalTo(30)
            make.bottom.equalTo(self)
            make.width.equalTo(80)
        }
        chooseBtn.snp_makeConstraints { (make) in
            make.left.equalTo(playBtn.snp_right).offset(10)
            make.top.equalTo(playBtn)
            make.bottom.equalTo(playBtn)
            make.width.equalTo(80)
        }
        downloadBtn.snp_makeConstraints { (make) in
            make.left.equalTo(chooseBtn.snp_right).offset(10)
            make.top.equalTo(playBtn)
            make.bottom.equalTo(playBtn)
            make.width.equalTo(80)
        }
        faviBtn.snp_makeConstraints { (make) in
            make.left.equalTo(downloadBtn.snp_right).offset(10)
            make.top.equalTo(playBtn)
            make.bottom.equalTo(playBtn)
            make.width.equalTo(80)
        }
        
    }
    
    private func setCommenAttr(label:UILabel){
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(12)
    }
    
    func setData(videoDetailInfo: VideoDetailInfo){
        //        videoNameLbl.text = videoDetailInfo.name
        //        directorNameLbl.text = videoDetailInfo.directorString
        //        cateDetailLbl.text = videoDetailInfo.category
        //        areaDetailLbl.text = videoDetailInfo.area
        //        publishTimeLbl.text = videoDetailInfo.publishTime
        //        durationDetailLbl.text = videoDetailInfo.duration
        //        actorNameLbl.text = videoDetailInfo.actorString
        //        descDetailLbl.text = videoDetailInfo.desc
        videoTitleLbl.text = videoDetailInfo.name
        videoDirectorLbl.text = videoDetailInfo.directorString
        videoCateLbl.text = videoDetailInfo.category
        videoAreaLbl.text = videoDetailInfo.area
        videoPublishLbl.text = videoDetailInfo.publishTime
        videoDramaLbl.text = videoDetailInfo.duration
        videoActorLbl.text = videoDetailInfo.actorString
        videoDescLbl.text = videoDetailInfo.desc
    }
    
    
}