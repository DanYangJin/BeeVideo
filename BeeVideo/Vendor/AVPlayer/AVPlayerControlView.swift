//
//  AVPlayerControlView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
//import SnapKit

class AVPlayerControlView: UIView {

    fileprivate let AutoFadeOutTimeInterval:Float = 0.5
    fileprivate let AnimationTimeInterval:Float = 7.0
    
    internal var topImageView:UIImageView!
    internal var bottomImageView:UIImageView!
    internal var playButton:UIButton!
    internal var currentTimeLabel:UILabel!
    internal var progressView:UIProgressView!
    internal var videoSlider:UISlider!
    internal var totalTimeLabel:UILabel!
    internal var backButton:UIButton!
    internal var videoNameLabel:UILabel!
    internal var systemTimeLabel:UILabel!
    internal var loadingView:UIActivityIndicatorView!
    internal var nextDramaBtn:UIButton!
    internal var menuButton:UIButton!
    
    //标记
    internal var isShowed:Bool = false
    
    
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
        self.bottomImageView.addSubview(self.initVideoSlider())
        self.bottomImageView.addSubview(self.initNextDramaBtn())
        
        self.topImageView.addSubview(self.initBackButton())
        self.topImageView.addSubview(self.initVideoNameLabel())
        self.topImageView.addSubview(self.initSystemTimeLabel())
        self.topImageView.addSubview(self.initMenuButton())

        self.makeSubViewsConstraints()
        
        self.hideControlView()
    }
    
    func makeSubViewsConstraints(){
        self.topImageView.snp.makeConstraints{ (make) -> Void in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(80)
        }
        self.bottomImageView.snp.makeConstraints{ (make) -> Void in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        self.playButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.bottomImageView).offset(10)
            make.leftMargin.equalTo(self.bottomImageView).offset(5)
            make.width.height.equalTo(30);
        }
        
        self.nextDramaBtn.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right)
            make.width.equalTo(playButton)
            make.top.bottom.equalTo(playButton)
        }
        
        self.currentTimeLabel.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.nextDramaBtn.snp.trailing).offset(0)
            make.centerY.equalTo(self.playButton.snp.centerY)

            make.width.equalTo(80);
        }
        
        self.totalTimeLabel.snp.makeConstraints{ (make) -> Void in
            make.trailing.equalTo(self.bottomImageView.snp.trailing).offset(3)
            make.centerY.equalTo(self.playButton.snp.centerY)
            
            make.width.equalTo(80);
        }
        
        self.progressView.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4);
            //进度条偏移0.5
            make.centerY.equalTo(self.playButton.snp.centerY).offset(0.5)
        }
        
        self.videoSlider.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4);
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4);
            make.centerY.equalTo(self.playButton.snp.centerY)
        }
        
        self.backButton.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.snp.leading).offset(15);
            make.top.equalTo(self.snp.top).offset(15);
            make.width.height.equalTo(30);
        }
        
        self.videoNameLabel.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(self.backButton.snp.trailing).offset(15);
            make.centerY.equalTo(self.backButton)
        }
        
        self.systemTimeLabel.snp.makeConstraints{ (make) -> Void in
            make.trailing.equalTo(self.snp.trailing).offset(-15);
            make.centerY.equalTo(self.backButton)
        }
        
        self.loadingView.snp.makeConstraints{ (make) -> Void in
            make.center.equalTo(self)
        }
        
        self.menuButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(backButton)
            make.right.equalTo(systemTimeLabel.snp.left)
            make.width.equalTo(backButton)
        }
        
    }
    
    func initTopImageView() -> UIImageView {
        if topImageView == nil {
            topImageView                        = UIImageView()
            topImageView.isUserInteractionEnabled = true
            topImageView.image                  = UIImage(named: "top_shadow")
        }
        return topImageView
    }
    
    func initBottomImageView() -> UIImageView {
        if bottomImageView == nil {
            bottomImageView                         = UIImageView()
            bottomImageView.isUserInteractionEnabled  = true
            bottomImageView.image                   = UIImage(named: "bottom_shadow")
        }
        return bottomImageView
    }
    
    func initPlayButton() -> UIButton {
        if playButton == nil {
            playButton = UIButton(type: UIButtonType.custom)
            playButton.setImage(UIImage(named: "kr-video-player-play"), for: UIControlState())
        }
        return playButton
    }
    
    func initCurrentTimeLabel() -> UILabel {
        if currentTimeLabel == nil {
            currentTimeLabel = UILabel()
            currentTimeLabel.textColor          = UIColor.white
            currentTimeLabel.font               = UIFont.boldSystemFont(ofSize: 12.0)
            currentTimeLabel.textAlignment      = NSTextAlignment.center
            currentTimeLabel.text               = "00:00"
        }
        return currentTimeLabel
    }
    
    func initProgressView() -> UIProgressView {
        if progressView == nil {
            progressView                    = UIProgressView(progressViewStyle: .default)
            progressView.progressTintColor = UIColor.blue
//            progressView.progressTintColor  = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
            progressView.trackTintColor     = UIColor.clear
        }
        return progressView
    }
    
    func initVideoSlider() -> UISlider {
        if videoSlider == nil {
            videoSlider = UISlider()
            videoSlider.setThumbImage(UIImage(named: "slider"), for: UIControlState())
            videoSlider.minimumTrackTintColor = UIColor.white
            videoSlider.maximumTrackTintColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.6)
        }
        return videoSlider
    }
    
    func initTotalTimeLabel() -> UILabel {
        if totalTimeLabel == nil {
            totalTimeLabel = UILabel()
            totalTimeLabel.textColor          = UIColor.white
            totalTimeLabel.font               = UIFont.boldSystemFont(ofSize: 12.0)
            totalTimeLabel.textAlignment      = NSTextAlignment.center
            totalTimeLabel.text               = "00:00"
        }
        return totalTimeLabel
    }
    
    func initBackButton() -> UIButton {
        if backButton == nil {
            backButton = UIButton(type: UIButtonType.custom)
            backButton.setImage(UIImage(named: "play_back_full"), for: UIControlState())
        }
        return backButton
    }
    
    func initVideoNameLabel() -> UILabel {
        if videoNameLabel == nil {
            videoNameLabel = UILabel()
            videoNameLabel.textColor          = UIColor.white
            videoNameLabel.font               = UIFont.boldSystemFont(ofSize: 15.0)
            videoNameLabel.textAlignment      = NSTextAlignment.center
           // videoNameLabel.text               = "武神赵子龙"
        }
        return videoNameLabel
    }
    
    func initSystemTimeLabel() -> UILabel {
        if systemTimeLabel == nil {
            systemTimeLabel = UILabel()
            systemTimeLabel.textColor          = UIColor.white
            systemTimeLabel.font               = UIFont.boldSystemFont(ofSize: 15.0)
            systemTimeLabel.textAlignment      = NSTextAlignment.center
            systemTimeLabel.text               = TimeUtils.formatCurrentDate()
        }
        return systemTimeLabel
    }
    
    func initIndicatorView() -> UIActivityIndicatorView{
        if loadingView == nil {
            loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
            //loadingView.startAnimating()
        }
        return loadingView
    }
    
    func initNextDramaBtn() -> UIButton{
        if nextDramaBtn == nil {
            nextDramaBtn = UIButton(type: UIButtonType.custom)
            nextDramaBtn.setImage(UIImage(named: "video_seek_next_bg"), for: UIControlState())
        }
        return nextDramaBtn
    }
    
    func initMenuButton() -> UIButton{
        if menuButton == nil{
            menuButton = UIButton()
            menuButton.setImage(UIImage(named: "video_menu_normal"), for: UIControlState())
            menuButton.setImage(UIImage(named: "video_menu_press"), for: .highlighted)
        }
        return menuButton
    }
    
    func changePlayButtonBg(_ flag:Bool){
        if flag {
            self.playButton.setImage(UIImage(named: "kr-video-player-play"), for: UIControlState())
        } else {
            self.playButton.setImage(UIImage(named: "kr-video-player-pause"), for: UIControlState())
        }
    }
    
    func updateProgress(_ currentTime:Int, totalTime:Int){
        currentTimeLabel.text = TimeUtils.formatTime(currentTime)
        totalTimeLabel.text   = TimeUtils.formatTime(totalTime)
    }
    
    /**
     * 定时隐藏控制条
     */
    func autoFadeOutControlBar(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideControlView), object: nil)
        self.perform(#selector(hideControlView), with: nil, afterDelay: TimeInterval.init(AnimationTimeInterval))
    }
    
    /**
     * 取消隐藏控制条
     */
    func cancelAutoFadeOutControlBar(){
       NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    /**
     * 动画显示控制条
     */
    func animationShow(){
        UIView.animate( withDuration: TimeInterval.init(AutoFadeOutTimeInterval), animations: {
                self.showControlView()
            }, completion: { (flag:Bool) -> Void in
                self.autoFadeOutControlBar()
        })
    }
    
    /**
     * 动画隐藏控制条
     */
    func animationHide(){
        UIView.animate( withDuration: TimeInterval.init(AutoFadeOutTimeInterval),
            animations: {
                self.hideControlView()
            }, completion: nil)
    }
    
    /**
     * 隐藏控制条
     */
    func hideControlView(){
        isShowed = false
        self.topImageView.alpha     = 0
        self.bottomImageView.alpha  = 0
    }
    
    /**
     * 显示控制条
     */
    func showControlView(){
        isShowed = true
        self.topImageView.alpha     = 1
        self.bottomImageView.alpha  = 1
    }
    
    /**
     * 定时刷新当前时间
     */
    func refreshCurrentTime(){
        self.systemTimeLabel.text = TimeUtils.formatCurrentDate()
    }
    
    /**
     * 重置ControlView
     */
    func resetControlView(){
        self.videoSlider.value      = 0;
        self.progressView.progress  = 0;
        self.currentTimeLabel.text  = "00:00";
        self.totalTimeLabel.text    = "00:00";
    }
    
    deinit{
        self.resetControlView()
        
    }
    
}
