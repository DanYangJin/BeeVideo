//
//  AVPlayerView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

protocol AVPlayerDelegate {
    func onPlayProgress(playView:AVPlayerView, currentTime:Int, totalTime:Int)
}

class AVPlayerView: UIView {

    private var videoUrl:String!
    internal var playerItem:AVPlayerItem!
    internal var player:AVPlayer!
    internal var playerLayer:AVPlayerLayer!
    
    //定时器
    internal var timer:NSTimer!
    private var isTimering:Bool {
        get{
            return self.isTimering
        }
        set{
            if newValue {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:#selector(playerTimeAction),userInfo:nil,repeats:true)
                NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
            } else {
                if timer != nil {
                    timer.invalidate()
                    timer = nil
                }
            }
        }
        
    }

    
    //回调
    private var playerDelegate:AVPlayerDelegate!
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeThePlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeThePlayer()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeThePlayer()
    }
    
    /**
     * 初始化Player
     */
    func initializeThePlayer(){
        //
    }
    
    func setVideoUrl(videoUrl:String){
        self.videoUrl = videoUrl
        self.configPlayer()
    }
    
    //设置监听
    func setDelegate(playerDelegate:AVPlayerDelegate){
        self.playerDelegate = playerDelegate
    }
    
    /**
     * 配置Player相关参数
     */
    func configPlayer(){
        self.playerItem = AVPlayerItem(URL: NSURL(string: self.videoUrl)!)
        self.player     = AVPlayer(playerItem: playerItem)
        self.playerLayer = self.layer as! AVPlayerLayer
        self.playerLayer.player = player
        // 此处为默认视频填充模式
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        // 计时器
        self.setTimering(true)
        self.play()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    //回调播放进度
    func playerTimeAction(){
        if playerItem.duration.timescale != 0 {
            if playerDelegate != nil {
                playerDelegate.onPlayProgress(self, currentTime: self.getCurrentTime(), totalTime: self.getDuration())
            }
        }
        
    }
    
    func setTimering(isTimering:Bool){
        self.isTimering = isTimering
    }
    
    /**
     * 播放
     */
    func play(){
        self.player.play()
    }
    
    /**
     * 暂停
     */
    func pause(){
        self.player.pause()
    }
    
    /**
     * seek
     */
    func seekToTime(dragedSeconds:Int){
        if self.player.currentItem!.status.hashValue == AVPlayerItemStatus.ReadyToPlay.hashValue {
            let dragedCMTime:CMTime  = CMTimeMake(Int64(dragedSeconds), 1);
            self.player.seekToTime(dragedCMTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    //获取当前时间
    func getCurrentTime() -> Int{
        if playerItem.duration.timescale == 0 {
            return 0
        }
        return Int(CMTimeGetSeconds(player.currentTime()))
    }
    
    //获取总时间
    func getDuration() -> Int{
        if playerItem.duration.timescale == 0 {
            return 0
        }
        return Int(playerItem.duration.value) / Int(playerItem.duration.timescale)
    }
    
    
}
