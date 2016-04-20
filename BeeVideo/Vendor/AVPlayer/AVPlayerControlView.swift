//
//  AVPlayerControlView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SnapKit

class AVPlayerControlView: UIView {

    internal var topImageView:UIImageView!
    internal var bottomImageView:UIImageView!
    internal var playButton:UIButton!
    internal var currentTimeLabel:UILabel!
    internal var progressView:UIProgressView!
    internal var videoSlider:UISlider!
    internal var totalTimeLabel:UILabel!
    internal var backButton:UIButton!
    internal var loadingView:UIActivityIndicatorView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         initUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         initUI()
    }

    func initUI(){
        self.addSubview(self.initTopImageView())
        self.addSubview(self.initBottomImageView())
        self.addSubview(self.initIndicatorView())
        
        self.bottomImageView.addSubview(self.initPlayButton())
        self.bottomImageView.addSubview(self.initCurrentTimeLabel())
        self.bottomImageView.addSubview(self.initProgressView())
        self.bottomImageView.addSubview(self.initTotalTimeLabel())
        self.bottomImageView.addSubview(self.initVideoSlider());
        
        
        self.topImageView.addSubview(self.initBackButton())

        
        self.makeSubViewsConstraints()
    }
    
    func makeSubViewsConstraints(){
        self.topImageView.snp_makeConstraints{ (make) -> Void in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(80)
        }
        self.bottomImageView.snp_makeConstraints{ (make) -> Void in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        self.playButton.snp_makeConstraints{ (make) -> Void in
            make.topMargin.equalTo(self.bottomImageView).offset(10)
            make.leftMargin.equalTo(self.bottomImageView).offset(5)
            make.width.height.equalTo(30);
        }
        
        self.currentTimeLabel.snp_makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.playButton.snp_trailing).offset(0)
            make.centerY.equalTo(self.playButton.snp_centerY)

            make.width.equalTo(80);
        }
        
        self.totalTimeLabel.snp_makeConstraints{ (make) -> Void in
            make.trailing.equalTo(self.bottomImageView.snp_trailing).offset(3)
            make.centerY.equalTo(self.playButton.snp_centerY)
            
            make.width.equalTo(80);
        }
        
        self.progressView.snp_makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.currentTimeLabel.snp_trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.snp_leading).offset(-4);
            
            make.centerY.equalTo(self.playButton.snp_centerY)
        }
        
        self.videoSlider.snp_makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.currentTimeLabel.snp_trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.snp_leading).offset(-4);
            
            make.centerY.equalTo(self.playButton.snp_centerY)
        }
        
        self.backButton.snp_makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(15);
            make.top.equalTo(self.snp_top).offset(15);
            make.width.height.equalTo(30);
        }
        
        self.loadingView.snp_makeConstraints{ (make) -> Void in
            make.center.equalTo(self)
        }
        
    }
    
    func initTopImageView() -> UIImageView {
        if topImageView == nil {
            topImageView                        = UIImageView()
            topImageView.userInteractionEnabled = true
            topImageView.image                  = UIImage(named: "top_shadow")
        }
        return topImageView
    }
    
    func initBottomImageView() -> UIImageView {
        if bottomImageView == nil {
            bottomImageView                         = UIImageView()
            bottomImageView.userInteractionEnabled  = true
            bottomImageView.image                   = UIImage(named: "bottom_shadow")
        }
        return bottomImageView
    }
    
    func initPlayButton() -> UIButton {
        if playButton == nil {
            playButton = UIButton(type: UIButtonType.Custom)
            playButton.setImage(UIImage(named: "kr-video-player-play"), forState: .Normal)
        }
        return playButton
    }
    
    func initCurrentTimeLabel() -> UILabel {
        if currentTimeLabel == nil {
            currentTimeLabel = UILabel()
            currentTimeLabel.textColor          = UIColor.whiteColor()
            currentTimeLabel.font               = UIFont.boldSystemFontOfSize(12.0)
            currentTimeLabel.textAlignment      = NSTextAlignment.Center
            currentTimeLabel.text               = "00:00:00"
        }
        return currentTimeLabel
    }
    
    func initProgressView() -> UIProgressView {
        if progressView == nil {
            progressView                    = UIProgressView(progressViewStyle: .Default)
        }
        return progressView
    }
    
    func initVideoSlider() -> UISlider {
        if videoSlider == nil {
            videoSlider = UISlider()
            videoSlider.setThumbImage(UIImage(named: "slider"), forState: .Normal)
            videoSlider.minimumTrackTintColor = UIColor.whiteColor()
            videoSlider.maximumTrackTintColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.6)
        }
        return videoSlider
    }
    
    func initTotalTimeLabel() -> UILabel {
        if totalTimeLabel == nil {
            totalTimeLabel = UILabel()
            totalTimeLabel.textColor          = UIColor.whiteColor()
            totalTimeLabel.font               = UIFont.boldSystemFontOfSize(12.0)
            totalTimeLabel.textAlignment      = NSTextAlignment.Center
            totalTimeLabel.text               = "00:00:00"
        }
        return totalTimeLabel
    }
    
    func initBackButton() -> UIButton {
        if backButton == nil {
            backButton = UIButton(type: UIButtonType.Custom)
            backButton.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        }
        return backButton
    }
    
    func initIndicatorView() -> UIActivityIndicatorView{
        if loadingView == nil {
            loadingView = UIActivityIndicatorView(activityIndicatorStyle: .White)
            loadingView.startAnimating()
        }
        return loadingView
    }
    
    func changePlayButtonBg(flag:Bool){
        if flag {
            self.playButton.setImage(UIImage(named: "kr-video-player-play"), forState: .Normal)
        } else {
            self.playButton.setImage(UIImage(named: "kr-video-player-pause"), forState: .Normal)
        }
    }
    
    func updateProgress(currentTime:Int, totalTime:Int){
        currentTimeLabel.text = TimeUtils.formatTime(currentTime)
        totalTimeLabel.text   = TimeUtils.formatTime(totalTime)
    }
    
    
    
}
