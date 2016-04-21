//
//  PlayerViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import AVFoundation

public enum PlayerStatus {
    case INIT
    case PLAY
    case PAUSE
}

class PlayerViewController: UIViewController, AVPlayerDelegate{
    
    private var videoPlayerView:AVPlayerView!
    private var controlView:AVPlayerControlView!
    private var videoStatus:PlayerStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotifications()
    }
    
    func initUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.videoPlayerView         = AVPlayerView()
        self.videoPlayerView.frame   = self.view.frame
        self.videoPlayerView.setVideoUrl("http://hot.vrs.sohu.com/ipad2982428_4671293813186_5193749.m3u8?plat=6&vid=2960257&pg=1&pt=5&cv=5.0.1&qd=680&uid=f1220d01d51c10c457fca7ba87d61746&sver=5.0.1&plat=6&ca=3&prod=app")
        self.videoPlayerView.setDelegate(self)
        self.view.addSubview(videoPlayerView)
        
        self.controlView         = AVPlayerControlView()
        self.controlView.frame   = self.view.frame
        self.controlView.animationShow()
        self.view.addSubview(controlView)
        
        videoStatus = PlayerStatus.PLAY

    }
    
    
    func addNotifications(){
        self.controlView.playButton.addTarget(self, action: (#selector(onPauseOrPlay)), forControlEvents: .TouchUpInside)
        // slider开始滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), forControlEvents: .TouchDown)
        // slider滑动中事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), forControlEvents: .ValueChanged)
        // slider结束滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchUpInside)
        self.createGesture()
    }

    //创建手势
    func createGesture(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap);
        //双击(播放/暂停)
        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPauseOrPlay))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap);
    }
    
    //单击
    func tapAction(){
        self.controlView.animationShow()
    }
    
    /**
     * 暂停或者播放
     */
    func onPauseOrPlay(){
        switch videoStatus! {
        case .PLAY:
            self.videoStatus = PlayerStatus.PAUSE
            self.videoPlayerView.pause()
            self.videoPlayerView.setTimering(false)
            self.controlView.changePlayButtonBg(false)
        case .PAUSE:
            self.videoStatus = PlayerStatus.PLAY
            self.videoPlayerView.play()
            self.videoPlayerView.setTimering(true)
            self.controlView.changePlayButtonBg(true)
        default:
            print("playstatus is error")
        }
    }
    
    /**
     *  滑块事件监听
     */
    func progressSliderTouchBegan(slider:UISlider){
        if self.videoPlayerView.player.currentItem!.status.rawValue == AVPlayerItemStatus.ReadyToPlay.hashValue {
            self.videoPlayerView.setTimering(false)
        }
    }
    
    func progressSliderValueChanged(slider:UISlider){
       if self.videoPlayerView.player.currentItem!.status.rawValue == AVPlayerItemStatus.ReadyToPlay.hashValue {
            let currentTime:Int = self.videoPlayerView.getCurrentTime()
            self.controlView.currentTimeLabel.text = TimeUtils.formatTime(currentTime)
        }
        
    }
    
    func progressSliderTouchEnded(slider:UISlider){
        if self.videoPlayerView.player.currentItem!.status.rawValue == AVPlayerItemStatus.ReadyToPlay.hashValue {
            self.videoPlayerView.setTimering(true)
            let duration:Int = self.videoPlayerView.getDuration()
            //计算出拖动的当前秒数
            let dragedSeconds:Int = lrintf(Float(duration) * slider.value);
            self.videoPlayerView.seekToTime(dragedSeconds)
        }
    }
    
    func onPlayProgress(playView: AVPlayerView, currentTime: Int, totalTime: Int) {
        self.controlView.updateProgress(currentTime, totalTime: totalTime)
        self.controlView.videoSlider.maximumValue   = 1
        let progress:Float = Float(currentTime) / Float(totalTime)
        self.controlView.videoSlider.setValue(progress, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
