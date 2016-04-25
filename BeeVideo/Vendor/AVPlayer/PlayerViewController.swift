//
//  PlayerViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

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

class PlayerViewController: UIViewController, AVPlayerDelegate, UIGestureRecognizerDelegate{
    
    private var videoPlayerView:AVPlayerView!
    private var controlView:AVPlayerControlView!
    private var progressView:ProgressView!
    private var volumeViewSlider:UISlider!
    internal var horizontalLabel:UILabel!
    
    //临时变量
    private var screenWidth:CGFloat!,screenHeight:CGFloat!
    private var index:Int = 0
    private var isVolumed:Bool = false
    private var moveDirection:PanDirection!
    private var videoStatus:PlayerStatus!
    private var sumTime:CGFloat = 0
    private var lastSlideValue:CGFloat = 0
    private var lastPlayerPosition:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotifications()
        self.configVolume()
    }
    
    func initUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.screenWidth     = self.view.bounds.size.width
        self.screenHeight    = self.view.bounds.size.height
        
        self.view.addSubview(self.initAVPlayerView())
        self.view.addSubview(self.initControlView())
        self.view.addSubview(self.initHorizontalLabel())
        self.view.addSubview(self.initProgressView())
    
        self.videoStatus     = PlayerStatus.INIT
        self.moveDirection   = PanDirection.PanDirectionInit
        
        self.makeSubViewsConstraints()
        
        self.videoPlayerView.play()

    }
    func makeSubViewsConstraints(){
        self.horizontalLabel.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.center.equalTo(self.view)
        }
    }

    func initAVPlayerView() -> AVPlayerView{
        if self.videoPlayerView == nil {
            self.videoPlayerView         = AVPlayerView()
            self.videoPlayerView.frame   = self.view.frame
            self.videoPlayerView.setDataSource(Constants.URLS[index])
            self.videoPlayerView.setDelegate(self)
        }
        return self.videoPlayerView
    }
    
    func initControlView() -> AVPlayerControlView{
        if self.controlView == nil {
            self.controlView         = AVPlayerControlView()
            self.controlView.frame   = self.view.frame
            self.controlView.animationShow()
            self.controlView.changePlayButtonBg(false)
        }
        return self.controlView
    }
    
    func initHorizontalLabel() -> UILabel{
        if horizontalLabel == nil {
            horizontalLabel                 = UILabel()
            horizontalLabel.textColor       = UIColor.whiteColor()
            horizontalLabel.textAlignment   = NSTextAlignment.Center
            horizontalLabel.backgroundColor = UIColor.init(patternImage: UIImage(named: "Management_Mask")!)
            horizontalLabel.alpha           = 0.0
        }
        return horizontalLabel
    }
    
    func initProgressView() -> ProgressView{
        if self.progressView == nil {
            self.progressView = ProgressView()
        }
        return self.progressView
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
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isKindOfClass(UISlider) {
            return false
        } else {
            return true
        }
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
            switch self.moveDirection! {
            case .PanDirectionHorizontalMoved:
                self.horizontalLabel.alpha           = 0.0
                self.resumePlay()
                self.videoPlayerView.seekToTime(Int.init(self.sumTime))
                self.sumTime = 0
                break
            case .PanDirectionVerticalMoved:
                self.isVolumed = false
                break
            default:
                break
            }
            self.moveDirection = PanDirection.PanDirectionInit
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
            self.horizontalLabel.alpha           = 1.0
            self.moveDirection = PanDirection.PanDirectionHorizontalMoved
            self.sumTime = CGFloat.init(self.videoPlayerView.getCurrentTime())
            self.pausePlay()
        } else {
            self.moveDirection = PanDirection.PanDirectionVerticalMoved
            if locationPoint.x > self.screenWidth! / 2 {
                self.isVolumed = true
            }else {// 状态改为显示亮度调节
                self.isVolumed = false
            }
        }
    }
    
    //水平移动
    func horizontalMoved(value:CGFloat){
    
        // 快进快退的方法
        var style:String = ""
        
        if (value < 0) {
            style.appendContentsOf("<<");
        } else if (value > 0){
            style.appendContentsOf(">>");
        }
        // 每次滑动需要叠加时间
        self.sumTime += value / 200
        
        // 需要限定sumTime的范围
        let totalTime:CGFloat = CGFloat.init(self.videoPlayerView.getDuration())
        if (self.sumTime > totalTime) {
            self.sumTime = totalTime
        }else if (self.sumTime < 0){
            self.sumTime = 0;
        }
        
        let nowTime:String = TimeUtils.formatTime(Int.init(self.sumTime))
        let durationTime:String = TimeUtils.formatTime(Int.init(totalTime))
        self.horizontalLabel.text = String.init(format: "%@ %@ / %@", style, nowTime, durationTime)
        self.controlView.currentTimeLabel.text = nowTime
    }
    
    //垂直移动 
    func verticalMoved(value:CGFloat){
        if self.isVolumed {
            self.volumeViewSlider.value      -=  Float.init(value / 10000)
        }else {
            UIScreen.mainScreen().brightness -= value / 10000
        }
    }
    
    func configVolume(){
        let volumeView:MPVolumeView = MPVolumeView()
        volumeViewSlider = nil;
        for view in volumeView.subviews{
            if view is UISlider {
                volumeViewSlider = view as! UISlider
                break;
            }
        }
        // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
        do {
            try  AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
           //
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
        self.lastPlayerPosition = self.videoPlayerView.getCurrentTime()
        self.pausePlay()
    }
    
    func progressSliderValueChanged(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        let value:CGFloat = CGFloat(slider.value) - self.lastSlideValue
        var style:String = ""
        if (value < 0) {
            style.appendContentsOf("<<");
        } else if (value > 0){
            style.appendContentsOf(">>");
        }
        self.lastSlideValue = CGFloat(slider.value)
        let duration:Int = self.videoPlayerView.getDuration()
        var dragedSeconds:Int = lrintf(Float(duration) * slider.value);
        if dragedSeconds >= duration {
            dragedSeconds = duration
        }
        self.horizontalLabel.alpha = 1.0
        self.horizontalLabel.text = String.init(format: "%@ %@ / %@", style, TimeUtils.formatTime(dragedSeconds), TimeUtils.formatTime(duration))
        self.controlView.currentTimeLabel.text = TimeUtils.formatTime(dragedSeconds)
    }
    
    func progressSliderTouchEnded(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        self.lastSlideValue = 0
        let duration:Int = self.videoPlayerView.getDuration()
        //计算出拖动的当前秒数
        let dragedSeconds:Int = lrintf(Float(duration) * slider.value);
        if dragedSeconds >= duration {
            onCompletion(self.videoPlayerView)
            return
        }
        self.horizontalLabel.alpha = 0.0
        self.videoPlayerView.seekToTime(dragedSeconds)
        self.resumePlay()
    }
    
    //返回按钮操作
    func backButtonAction(){
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    //播放进度
    func onUpdateProgress(playView:AVPlayerView, currentTime:Int, totalTime:Int){
        if currentTime == self.lastPlayerPosition {
            return
        }
        self.controlView.updateProgress(currentTime, totalTime: totalTime)
        self.controlView.videoSlider.maximumValue   = 1
        let progress:Float = Float(currentTime) / Float(totalTime)
        self.controlView.videoSlider.setValue(progress, animated: true)
    }
    
    //准备完成
    func onPreparedCompetion(playView:AVPlayerView) {
        self.controlView.loadingView.stopAnimating()
        self.videoStatus = PlayerStatus.PLAY
        self.videoPlayerView.play()
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
        self.horizontalLabel.alpha = 0.0
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
