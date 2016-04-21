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
    case ERROR
    case BUFFERING
    case COMPLETION
}

class PlayerViewController: UIViewController, AVPlayerDelegate{
    
    private var videoPlayerView:AVPlayerView!
    private var controlView:AVPlayerControlView!
    private var videoStatus:PlayerStatus!
    
    //临时变量
    private var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotifications()
    }
    
    func initUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.videoPlayerView         = AVPlayerView()
        self.videoPlayerView.frame   = self.view.frame
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        self.videoPlayerView.setDelegate(self)
        self.videoPlayerView.play()
        self.view.addSubview(videoPlayerView)
        
        self.controlView         = AVPlayerControlView()
        self.controlView.frame   = self.view.frame
        self.controlView.animationShow()
        self.view.addSubview(controlView)
        
        videoStatus = PlayerStatus.INIT

    }
    
    
    func addNotifications(){
        self.controlView.playButton.addTarget(self, action: (#selector(onPauseOrPlay)), forControlEvents: .TouchUpInside)
        // slider开始滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), forControlEvents: .TouchDown)
        // slider滑动中事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), forControlEvents: .ValueChanged)
        // slider结束滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchUpInside)
        self.controlView.backButton.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
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
            self.controlView.changePlayButtonBg(false)
        case .PAUSE:
            self.videoStatus = PlayerStatus.PLAY
            self.videoPlayerView.play()
            self.controlView.changePlayButtonBg(true)
        default:
            break
        }
    }
    
    /**
     *  滑块事件监听
     */
    func progressSliderTouchBegan(slider:UISlider){
        self.videoPlayerView.setTimering(false)
    }
    
    func progressSliderValueChanged(slider:UISlider){
        let currentTime:Int = self.videoPlayerView.getCurrentTime()
        self.controlView.currentTimeLabel.text = TimeUtils.formatTime(currentTime)
    }
    
    func progressSliderTouchEnded(slider:UISlider){
        self.videoPlayerView.setTimering(true)
        let duration:Int = self.videoPlayerView.getDuration()
        //计算出拖动的当前秒数
        let dragedSeconds:Int = lrintf(Float(duration) * slider.value);
        if dragedSeconds >= duration {
            onCompletion(self.videoPlayerView)
            return
        }
        self.videoPlayerView.seekToTime(dragedSeconds)
    }
    
    func backAction(){
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    //播放进度
    func onUpdateProgress(playView:AVPlayerView, currentTime:Int, totalTime:Int){
        self.controlView.updateProgress(currentTime, totalTime: totalTime)
        self.controlView.videoSlider.maximumValue   = 1
        let progress:Float = Float(currentTime) / Float(totalTime)
        self.controlView.videoSlider.setValue(progress, animated: true)
    }
    
    //准备完成
    func onPreparedCompetion(playView:AVPlayerView) {
        print("onPreparedCompetion")
        self.controlView.loadingView.stopAnimating()
        self.videoStatus = PlayerStatus.PLAY
    }
    
    //播放错误
    func onError(playView:AVPlayerView) {
        print("onError")
        self.videoStatus = PlayerStatus.ERROR
    }
    
    //缓冲变化
    func onUpdateBuffering(playView:AVPlayerView, bufferingValue:Int) {
        print("onUpdateBuffering")
    }
    
    //加载信息
    func onInfo(playView:AVPlayerView, value:Int) {
        switch value {
        case 701:
            self.videoStatus = PlayerStatus.BUFFERING
            self.controlView.loadingView.startAnimating()
        case 702:
            self.videoStatus = PlayerStatus.PLAY
            self.controlView.loadingView.stopAnimating()
        default:
            break
        }
    }
    //结束
    func onCompletion(playView:AVPlayerView) {
        print("onCompletion")
        self.videoStatus = PlayerStatus.COMPLETION
        self.controlView.resetControlView()
        self.controlView.loadingView.startAnimating()
        self.videoPlayerView.resetPlayer()
        let size:Int = Constants.URLS.count
        index  += 1
        if index > size - 1 {
            index = 0
        }
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        self.videoPlayerView.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.videoPlayerView.resetPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
