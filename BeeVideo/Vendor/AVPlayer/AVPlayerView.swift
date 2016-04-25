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
    //播放进度
    func onUpdateProgress(playView:AVPlayerView, currentTime:Int, totalTime:Int)
    //准备完成
    func onPreparedCompetion(playView:AVPlayerView)
    //播放错误
    func onError(playView:AVPlayerView)
    //缓冲变化
    func onUpdateBuffering(playView:AVPlayerView, bufferingValue:Float)
    //加载信息
    func onInfo(playView:AVPlayerView, value:Int)
    //结束
    func onCompletion(playView:AVPlayerView)
    
}

//滑动屏幕协议
protocol SliderViewDelegate {
    
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

    //标记
//    private var isReadyed:Bool = false
    
    //回调
    private var delegate:AVPlayerDelegate!
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
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
    
    /**
     * 初始化Player
     */
    func initUI(){
        //
    }
    
    func setDataSource(videoUrl:String){
        self.videoUrl = videoUrl
        let image:UIImage? = UIImage(named: "loading_bgView")
        self.layer.contents = image?.CGImage
        self.configPlayer()
    }
    
    //设置监听
    func setDelegate(playerDelegate:AVPlayerDelegate){
        self.delegate = playerDelegate
    }
    
    /**
     * 重置Player
     */
    func resetPlayer(){
        self.playerItem.removeObserver(self, forKeyPath: "status")
        self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
        // 关闭定时器
        self.setTimering(false)
        // 暂停
        self.pause()
        // 替换PlayerItem为nil
        self.player.replaceCurrentItemWithPlayerItem(nil);
        // 把player置为nil
        self.player = nil;
        self.playerItem = nil;
    }
    
    /**
     * 配置Player相关参数
     */
    func configPlayer(){
        self.playerItem = AVPlayerItem(URL: NSURL(string: self.videoUrl)!)
        //添加播放状态监听
        self.playerItem.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
        //播放结束监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerFinished), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
        
        self.player     = AVPlayer(playerItem: playerItem)
        self.playerLayer = self.layer as! AVPlayerLayer
        self.playerLayer.player = player
        
        // 此处为默认视频填充模式
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === self.player.currentItem {
            switch keyPath! {
            case "status":
                if self.player.currentItem!.status == .ReadyToPlay {
//                    print("onPreparedCompetion : ReadyToPlay")
                    if delegate != nil {
                        self.layer.contents = nil
                        delegate.onPreparedCompetion(self)
                    }
                } else if self.player.currentItem!.status == .Failed {
//                    print("onPreparedCompetion : Failed")
                    if delegate != nil {
                        delegate.onError(self)
                    }
                }
            case "loadedTimeRanges":
                if delegate != nil {
//                    print("loadedTimeRanges")
                    let timeInterval:Float        = Float.init(self.calcBufferingData())
                    let duration:CMTime           = self.playerItem.duration;
                    let totalDuration:Float       = Float.init(CMTimeGetSeconds(duration));
                    delegate.onUpdateBuffering(self, bufferingValue: timeInterval / totalDuration)
                }
                break
            case "playbackBufferEmpty":
//                print("playbackBufferEmpty")
                if delegate != nil {
                    delegate.onInfo(self, value: 701)
                }
                break;
            case "playbackLikelyToKeepUp":
//                print("playbackLikelyToKeepUp")
                if delegate != nil {
                    delegate.onInfo(self, value: 702)
                }
                break;
            default:
                print("key path is error")
            }
        
        }
    }
    
    func bufferingSomeSecond(){
        self.pause()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC)), dispatch_get_main_queue(), {
            if !self.playerItem.playbackLikelyToKeepUp {
                self.bufferingSomeSecond()
            }
        });
    }
    
    //播放进度
    func playerTimeAction(){
        if playerItem == nil || playerItem.duration.timescale == 0 {
            return
        }
        if delegate != nil {
            delegate.onUpdateProgress(self, currentTime: self.getCurrentTime(), totalTime: self.getDuration())
        }
    }
    
    //播放结束
    func playerFinished(){
        if delegate != nil {
            delegate.onCompletion(self)
        }
    }
    
    func setTimering(isTimering:Bool){
        self.isTimering = isTimering
    }
    
    /**
     * 播放
     */
    func play(){
        self.setTimering(true)
        self.player.play()
    }
    
    /**
     * 暂停
     */
    func pause(){
        self.setTimering(false)
        self.player.pause()
    }
    
    /**
     * 快进到某一时间
     */
    func seekToTime(dragedSeconds:Int){
        if self.getItemStatus() != .ReadyToPlay {
            return
        }
        let dragedCMTime:CMTime  = CMTimeMake(Int64(dragedSeconds), 1);
        self.player.seekToTime(dragedCMTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    /**
     *  计算缓冲进度
     */
    func calcBufferingData() -> NSTimeInterval{
        let loadedTimeRanges:[NSValue]  = (self.player.currentItem?.loadedTimeRanges)!
        if loadedTimeRanges.count == 0 {
            return 0
        }
        let timeRange:CMTimeRange       = loadedTimeRanges[0].CMTimeRangeValue
        let startSeconds:Float64        = CMTimeGetSeconds(timeRange.start);
        let durationSeconds:Float64     = CMTimeGetSeconds(timeRange.duration);
        let result:NSTimeInterval       = startSeconds + durationSeconds;// 计算缓冲总进度
        return result
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
    
    // 获取当前播放状态
    func getItemStatus() -> AVPlayerItemStatus{
        return self.player.currentItem!.status;
    }
    
}
