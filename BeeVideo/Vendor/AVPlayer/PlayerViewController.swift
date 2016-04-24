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

public enum PanDirection {
    case PanDirectionInit //初始
    case PanDirectionHorizontalMoved //横向移动
    case PanDirectionVerticalMoved    //纵向移动
}

class PlayerViewController: UIViewController, AVPlayerDelegate{
    
    private var videoPlayerView:AVPlayerView!
    private var controlView:AVPlayerControlView!
    private var progressView:ProgressView!
    
    //临时变量
    private var screenWidth:CGFloat?,screenHeight:CGFloat?
    private var index:Int = 0
    private var isVolumed:Bool = false
    private var moveDirection:PanDirection!
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
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        self.videoPlayerView.setDelegate(self)
        self.videoPlayerView.play()
        self.view.addSubview(videoPlayerView)
        
        self.controlView         = AVPlayerControlView()
        self.controlView.frame   = self.view.frame
        self.controlView.animationShow()
        self.controlView.changePlayButtonBg(false)
        self.view.addSubview(controlView)
        
        self.progressView = ProgressView()
        self.view.addSubview(progressView)
        
        self.screenWidth     = self.view.bounds.size.width
        self.screenHeight    = self.view.bounds.size.height
        
        self.videoStatus     = PlayerStatus.INIT
        self.moveDirection   = PanDirection.PanDirectionInit

    }
    
    
    func addNotifications(){
        //APP进入前台
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidEnterPlayGround), name: UIApplicationDidBecomeActiveNotification, object: nil)
        //APP退到后台
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        
        self.controlView.playButton.addTarget(self, action: (#selector(onPauseOrPlay)), forControlEvents: .TouchUpInside)
        // slider开始滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), forControlEvents: .TouchDown)
        // slider滑动中事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), forControlEvents: .ValueChanged)
        // slider结束滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchUpInside)
        self.controlView.backButton.addTarget(self, action: #selector(backButtonAction), forControlEvents: .TouchUpInside)
        
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
        //平移手势
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panDirection))
        self.view.addGestureRecognizer(pan)
    }
    
    //单击
    func tapAction(){
        if self.controlView.isShowed {
            self.controlView.animationHide()
        } else {
            self.controlView.animationShow()
        }
    }
    
    
    /**
     * 双击
     */
    func onPauseOrPlay(){
        switch videoStatus! {
        case .PLAY:
            pausePlay()
        case .PAUSE:
            resumePlay()
        default:
            break
        }
    }
    
    /**
     * 手势滑动
     */
    func panDirection(pan:UIPanGestureRecognizer){
        let locationPoint:CGPoint   = pan.locationInView(self.view)
        let veloctyPoint:CGPoint    = pan.velocityInView(self.view)
        switch pan.state {
        case .Began:
            judgePanDirection(locationPoint, veloctyPoint: veloctyPoint)
            break
        case .Changed:
            switch self.moveDirection! {
            case .PanDirectionHorizontalMoved:
                self.horizontalMoved(veloctyPoint.x) // 水平移动的方法只要x方向的值
                break
                
            case .PanDirectionVerticalMoved:
                self.verticalMoved(veloctyPoint.y) // 垂直移动方法只要y方向的值
                break
            default:
                break
            }
            break
        case .Ended:
            //滑动结束重置MoveDirection
            self.moveDirection = PanDirection.PanDirectionInit
            switch self.moveDirection! {
            case .PanDirectionHorizontalMoved:
                self.resumePlay()
                break
            case .PanDirectionVerticalMoved:
                self.isVolumed = false
                break
            default:
                break
            }
            break
        default:
            break
        }

    }
    
    //判断滑动方向
    func judgePanDirection(locationPoint:CGPoint, veloctyPoint:CGPoint){
        let x:CGFloat = fabs(veloctyPoint.x);
        let y:CGFloat = fabs(veloctyPoint.y);
        
        if x > y{ 
            moveDirection = PanDirection.PanDirectionHorizontalMoved
            self.pausePlay()
        } else {
            moveDirection = PanDirection.PanDirectionVerticalMoved
            if locationPoint.x > self.screenWidth! / 2 {
                self.isVolumed = true
            }else {// 状态改为显示亮度调节
                self.isVolumed = false
            }
        }
    }
    
    //水平移动
    func horizontalMoved(value:CGFloat){
    
    }
    
    //垂直移动 
    func verticalMoved(value:CGFloat){
        if self.isVolumed {
            //
        }else {
            //
            let progress:CGFloat = UIScreen.mainScreen().brightness - value/10000
            UIScreen.mainScreen().brightness = progress
            self.progressView.updateLongView(progress)
        }
    }
    
    /**
     * 播放
     */
    func resumePlay(){
        if self.videoPlayerView == nil {
            return
        }
        self.videoStatus = PlayerStatus.PLAY
        self.videoPlayerView.play()
        self.videoPlayerView.setTimering(true)
        self.controlView.changePlayButtonBg(false)
    }
    
    /**
     * 暂停
     */
    func pausePlay(){
        if self.videoPlayerView == nil {
            return
        }
        self.videoStatus = PlayerStatus.PAUSE
        self.videoPlayerView.pause()
        self.videoPlayerView.setTimering(false)
        self.controlView.changePlayButtonBg(true)
    }
    
    /**
     * APP进入前台相应事件
     */
    func appDidEnterPlayGround(){
        resumePlay()
    }
    
    /**
     * APP进入后台相应事件
     */
    func appDidEnterBackground(){
        pausePlay()
    }
    
    /**
     *  滑块事件监听
     */
    func progressSliderTouchBegan(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        self.pausePlay()

    }
    
    func progressSliderValueChanged(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        let currentTime:Int = self.videoPlayerView.getCurrentTime()
        self.controlView.currentTimeLabel.text = TimeUtils.formatTime(currentTime)
    }
    
    func progressSliderTouchEnded(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        self.resumePlay()
        let duration:Int = self.videoPlayerView.getDuration()
        //计算出拖动的当前秒数
        let dragedSeconds:Int = lrintf(Float(duration) * slider.value);
        if dragedSeconds >= duration {
            onCompletion(self.videoPlayerView)
            return
        }
        self.videoPlayerView.seekToTime(dragedSeconds)
    }
    
    //返回按钮操作
    func backButtonAction(){
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
        self.controlView.loadingView.stopAnimating()
        self.videoStatus = PlayerStatus.PLAY
    }
    
    //播放错误
    func onError(playView:AVPlayerView) {
        self.videoStatus = PlayerStatus.ERROR
        self.playNextDrama()
    }
    
    //缓冲变化
    func onUpdateBuffering(playView:AVPlayerView, bufferingValue:Float) {
        self.controlView.progressView.setProgress(bufferingValue, animated: true)
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
        self.videoStatus = PlayerStatus.COMPLETION
        self.playNextDrama()
    }
    
    //播放下一集
    func playNextDrama(){
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
    
    func removeNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.removeNotifications()
        self.videoPlayerView.resetPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
