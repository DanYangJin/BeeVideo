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
import Alamofire
import PopupController

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

public enum Flag{
    case UnKnow
    case Detail
    case History
}

class PlayerViewController: UIViewController, AVPlayerDelegate, UIGestureRecognizerDelegate,VideoMenuDelegate{
    
    enum RequestId {
        case GET_VIDEO_SOURCE
        case GET_VIDEO_PALY_URL
        case GET_VIDEO_DETAIL
    }
    
    var flag:Flag = .Detail
    var videoDetailInfo:VideoDetailInfo!
    var videoHistoryItem:VideoHistoryItem!
    var subjectId = ""
    var videoPlayItem:VideoPlayItem!
    
    private var requestId:RequestId!
    
    private var videoPlayerView:AVPlayerView!
    private var controlView:AVPlayerControlView!
    private var progressView:ProgressView!
    private var volumeViewSlider:UISlider!
    internal var horizontalLabel:UILabel!
    private var netLoadingView:NetSpeedView!
    private var preLoadingView:PreLoadingView!
    private var menuView:VideoMenuViewController!
    
    //临时变量
    private var screenWidth:CGFloat!,screenHeight:CGFloat!
    private var index:Int = 0
    private var isVolumed:Bool = false
    private var moveDirection:PanDirection!
    private var videoStatus:PlayerStatus!
    private var sumTime:CGFloat = 0
    private var lastSlideValue:CGFloat = 0
    private var lastPlayerPosition:Int = 0
    
    //xml临时变量
    private var dramas:[Drama]!
    private var drama:Drama!
    
    private var reachability : Reachability?
    
    var timer:NSTimer!
    
    //xml解析临时变量
    //无源时获取源
    private var videoSource:VideoSourceInfo!
    private var source:Source!
    private var sourceList = [VideoSourceInfo]()
    private var currentDepth = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotifications()
        self.configVolume()
        
        self.videoPlayerView.setDataSource(Constants.URLS[index],startTime: 60)
        self.videoPlayerView.playbackLoops = true
        //       // controlView.videoNameLabel.text = videoDetailInfo.currentDrama?.title
        //        getVideoPlayUrl()
        if flag == Flag.Detail {
            controlView.videoNameLabel.text = videoDetailInfo.name
            if videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo() == nil {
                preLoadingView.hidden = true
                getSourceInfo()
            }
        }else if flag == Flag.History{
            getVideoDetail(videoHistoryItem.videoId)
        }
    }
    
    func initUI(){
        self.view.backgroundColor = UIColor.blackColor()
        
        self.screenWidth     = self.view.bounds.size.width
        self.screenHeight    = self.view.bounds.size.height
        
        self.view.addSubview(self.initAVPlayerView())
        self.view.addSubview(self.initControlView())
        self.view.addSubview(self.initHorizontalLabel())
        self.view.addSubview(self.initProgressView())
        self.view.addSubview(self.initNetLoadingView())
        self.view.addSubview(self.initPreLoadingView())
        
        self.videoStatus     = PlayerStatus.INIT
        self.moveDirection   = PanDirection.PanDirectionInit
        
        self.makeSubViewsConstraints()
        
        //self.setTimering(true)
        
    }
    func makeSubViewsConstraints(){
        self.horizontalLabel.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.center.equalTo(self.view)
        }
        self.netLoadingView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(self.view).multipliedBy(0.15)
            make.width.equalTo(self.view).multipliedBy(0.32)
        }
        self.preLoadingView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(80)
            make.width.equalTo(self.view)
        }
    }
    
    func initAVPlayerView() -> AVPlayerView{
        if self.videoPlayerView == nil {
            self.videoPlayerView         = AVPlayerView()
            self.videoPlayerView.frame   = self.view.frame
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
            controlView.hideControlView()
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
    
    func initNetLoadingView() -> NetSpeedView{
        if netLoadingView == nil {
            netLoadingView = NetSpeedView()
        }
        return netLoadingView
    }
    
    func initPreLoadingView() -> PreLoadingView{
        if preLoadingView == nil{
            preLoadingView = PreLoadingView()
            switch self.flag {
            case .Detail:
                preLoadingView.dramaLbl.text = "即将播放：第\(3)集"
                preLoadingView.videoNameLbl.text = videoDetailInfo.name
                preLoadingView.sourceNameLbl.text = videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo()?.source?.name
            case .History:
                preLoadingView.dramaLbl.text = "即将播放：第\(videoHistoryItem.playedDrama)集"
                preLoadingView.videoNameLbl.text = videoHistoryItem.videoName
                preLoadingView.sourceNameLbl.text = videoHistoryItem.sourceName
            case .UnKnow:
                true
            }
            
        }
        return preLoadingView
    }
    
    func initProgressView() -> ProgressView{
        if self.progressView == nil {
            self.progressView = ProgressView()
        }
        return self.progressView
    }
    
    func initMenuView() -> VideoMenuViewController{
        if self.menuView == nil {
            menuView = VideoMenuViewController(frame: CGRectZero, data: videoDetailInfo,currentIndex: index)
            menuView.delegate = self
            menuView.hidden = true
            self.view.addSubview(menuView)
            menuView.snp_makeConstraints { (make) in
                make.left.right.equalTo(self.view)
                make.top.bottom.equalTo(self.view)
            }
        }
        
        return self.menuView
    }
    
    func addNotifications(){
        self.controlView.playButton.addTarget(self, action: (#selector(onPauseOrPlay)), forControlEvents: .TouchUpInside)
        //切换下一集
        self.controlView.nextDramaBtn.addTarget(self, action: #selector(playNextDrama), forControlEvents: .TouchUpInside)
        // slider开始滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), forControlEvents: .TouchDown)
        // slider滑动中事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), forControlEvents: .ValueChanged)
        // slider结束滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchUpInside)
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchUpOutside)
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: .TouchCancel)
        
        self.controlView.backButton.addTarget(self, action: #selector(backButtonAction), forControlEvents: .TouchUpInside)
        
        self.controlView.menuButton.addTarget(self, action: #selector(self.popupMenu), forControlEvents: .TouchUpInside)
        
        self.createGesture()
        
        do{
            try reachability = Reachability.reachabilityForInternetConnection()
        }catch{
            print("reachability start fail")
            return
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        do{
            try reachability?.startNotifier()
        }catch{
            print("notifier can not start")
        }
        
    }
    
    //网络改变
    func reachabilityChanged(nate:NSNotification){
        let reachability = nate.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi(){
                print("wifi connected")
            }else{
                print("mobile connnected")
            }
        }else{
            print("net work disconnected")
        }
    }
    
    
    //创建手势
    func createGesture(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        tap.cancelsTouchesInView = false
        tap.delaysTouchesBegan = false
        tap.delaysTouchesEnded = false
        tap.delegate = self
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
        //print(touch.view?.isDescendantOfView(controlView))
        if touch.view!.isKindOfClass(UISlider) || touch.view!.isKindOfClass(UIButton) {
            return false
        } else {
            return true
        }
    }
    
    //单击
    func tapAction(tap:UITapGestureRecognizer){
        if menuView == nil || menuView.hidden{
            if self.controlView.isShowed {
                self.controlView.animationHide()
            } else {
                self.controlView.animationShow()
            }
        }
    }
    
    /**
     * 双击
     */
    func onPauseOrPlay(){
        switch videoStatus! {
        case .PLAY:
            videoPlayerView.isUserPause = true
            pausePlay()
        case .PAUSE:
            videoPlayerView.isUserPause = false
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
                netLoadingView.startAnimate()
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
        self.setTimering(true)
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
        self.setTimering(false)
        self.controlView.changePlayButtonBg(true)
    }
    
    /**
     *  滑块事件监听
     */
    func progressSliderTouchBegan(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        self.setTimering(false)
        self.lastPlayerPosition = self.videoPlayerView.getCurrentTime()
    }
    
    func progressSliderValueChanged(slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .ReadyToPlay {
            return
        }
        let value:CGFloat = CGFloat(slider.value) - self.lastSlideValue
        var style:String = ""
        if (value < 0) {
            style.appendContentsOf("<<");
        } else if (value >= 0){
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
        self.netLoadingView.startAnimate()
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
    }
    
    //弹出菜单
    func popupMenu(){
        self.controlView.animationHide()
        self.onPauseOrPlay()
        initMenuView()
        menuView.hidden = false
    }
    
    func popupDidDismiss() {
        self.onPauseOrPlay()
    }
    
    //返回按钮操作
    func backButtonAction(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        //videoPlayerView = nil
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.savePlayedDuration()
        self.saveHistory()
        NSNotificationCenter.defaultCenter().postNotificationName("HistroyChangedNotify", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //获取视频详情
    func getVideoDetail(videoId:String){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_DETAIL_INFO_V2)!, parameters: ["videoId": videoId]).responseData { (response) in
            self.requestId = RequestId.GET_VIDEO_DETAIL
            switch response.result {
            case .Failure( _):
                
                break
            case .Success(let data):
                let parse = NSXMLParser(data: data)
                parse.delegate = self
                parse.parse()
                break
                
            }
        }

    }
    
    
    //获取源
    func getSourceInfo(){
        if videoDetailInfo.currentDrama == nil {
            return
        }
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_LIST_VIDEO_SOURCE_INFO)!, parameters: ["videoMergeInfoId" : (videoDetailInfo.currentDrama?.id)!]).responseData{
            response in
            self.requestId = RequestId.GET_VIDEO_SOURCE
            switch response.result{
            case .Success(let data):
                let parser = NSXMLParser(data: data)
                parser.delegate = self
                parser.parse()
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    //获取播放地址
    func getVideoPlayUrl(){
        let sourceInfo = videoDetailInfo.currentDrama?.currentUsedSourceInfo
        if sourceInfo == nil {
            return
        }
        var params:[String:AnyObject] = [String:AnyObject]()
        params["videoInfoId"] = sourceInfo?.id
        params["subjectId"] = self.subjectId
        params["model"] = UIDevice.currentDevice().localizedModel
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_DAILY_PLAY_SOURCE)!, parameters: params).responseData { (response) in
            self.requestId = RequestId.GET_VIDEO_PALY_URL
            
            switch response.result{
            case .Failure(let error):
                print(error)
                break
            case .Success(let data):
                let parser = NSXMLParser(data: data)
                parser.delegate = self
                parser.parse()
                break
            }
        }
    }
    
    //xml解析
    private var currentElement = ""
    
    //更新进度条
    func playerTimeAction(){
        self.onUpdateProgress(videoPlayerView, currentTime: videoPlayerView.getCurrentTime(), totalTime: videoPlayerView.getDuration())
    }
    
    func setTimering(timering:Bool){
        if timering {
            if timer == nil{
                timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:#selector(playerTimeAction),userInfo:nil,repeats:true)
            }
        }else{
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
        }
    }
    
    func changeDrama(index: Int) {
        self.index = index
        let size:Int = Constants.URLS.count
        if index >= size {
            return
        }
        self.controlView.resetControlView()
        self.netLoadingView.startAnimate()
        self.preLoadingView.hidden = false
        self.horizontalLabel.alpha = 0.0
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        
    }
    
    func saveHistory(){
        VideoDBHelper.shareInstance().saveOrUpdate(videoDetailInfo)
    }
    
    func savePlayedDuration(){
        videoDetailInfo.dramaPlayedDuration = videoPlayerView.getCurrentTime()
    }
    
}

extension PlayerViewController{
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
        videoPlayerView.seekToTime(60)
        self.videoStatus = PlayerStatus.PLAY
        self.videoPlayerView.play()
        self.netLoadingView.stopAnimat()
        self.preLoadingView.hidden = true
        controlView.changePlayButtonBg(false)
        if videoHistoryItem != nil{
            videoPlayerView.seekToTime(videoHistoryItem.playedDuration)
        }
    }
    
    //播放错误
    func onError(playView:AVPlayerView) {
        self.videoStatus = PlayerStatus.ERROR
        // self.playNextDrama()
        self.view.makeToast("播放失败")
    }
    
    //缓冲变化
    func onUpdateBuffering(playView:AVPlayerView, bufferingValue:Float) {
        guard controlView != nil else{
            return
        }
        self.controlView.progressView.setProgress(bufferingValue, animated: true)
    }
    
    //加载信息
    func onInfo(playView:AVPlayerView) {
        
        switch playView.bufferingState {
        case .Ready:
            self.setTimering(true)
            self.netLoadingView.stopAnimat()
        case .Delayed:
            self.setTimering(false)
            self.netLoadingView.startAnimate()
        default:
            self.netLoadingView.startAnimate()
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
        //self.controlView.loadingView.startAnimating()
        self.netLoadingView.startAnimate()
        self.preLoadingView.hidden = false
        //self.videoPlayerView.resetPlayer()
        self.horizontalLabel.alpha = 0.0
        let size:Int = Constants.URLS.count
        index  += 1
        if index > size - 1 {
            index = 0
        }
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        //self.videoPlayerView.play()
    }
}


extension PlayerViewController : NSXMLParserDelegate{
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == RequestId.GET_VIDEO_SOURCE {
            if currentElement == "video_source_info" {
                videoSource = VideoSourceInfo()
                currentDepth += 1
            }else if currentElement == "source" {
                source = Source()
                currentDepth += 1
            }
        }else if requestId == RequestId.GET_VIDEO_DETAIL{
            if currentElement == "video" {
                videoDetailInfo = VideoDetailInfo()
                currentDepth += 1
            }else if currentElement == "videoMergeInfoList"{
                dramas = [Drama]()
                currentDepth += 1
            }else if currentElement == "videoMergeInfo"{
                drama = Drama()
                currentDepth += 1
            }else if currentElement == "response"{
                currentDepth += 1
            }

        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if requestId == RequestId.GET_VIDEO_SOURCE {
            if currentElement == "id" {
                if currentDepth == 1 {
                    videoSource.id = content
                }else if currentDepth == 2 {
                    source.id = content
                }
            }else if currentElement == "name"{
                if currentDepth == 1 {
                    videoSource.name = content
                }else if currentDepth == 2 {
                    source.name = content
                }
            }else if currentElement == "duration" {
                //videoSource.
            }else if currentElement == "videoMetaId"{
                videoSource.metaId = content
            }else if currentElement == "playpoint"{
                videoSource.playPointAmount = Int(content)!
            }else if currentElement == "downloadpoint"{
                videoSource.downloadPointAmount = Int(content)!
            }else if currentElement == "otherSource"{
                source.otherSource = content
            }
        }else if requestId == RequestId.GET_VIDEO_DETAIL{
            if currentElement == "id" {
                if currentDepth == 3 {
                    videoDetailInfo.id = content
                }else if currentDepth == 5{
                    drama.id = content
                }
            }else if currentElement == "doubanId"{
                videoDetailInfo.doubanId = content
            }else if currentElement == "doubanAverage"{
                videoDetailInfo.doubanAverage = content
            }else if currentElement == "apikey"{
                videoDetailInfo.doubanKey = content
            }else if currentElement == "name"{
                if currentDepth == 3 {
                    videoDetailInfo.name = content
                }else if currentDepth == 5{
                    drama.title = content
                }
            }else if currentElement == "channel"{
                videoDetailInfo.channel = content
            }else if currentElement == "channelId"{
                videoDetailInfo.channelId = content
            }else if currentElement == "area"{
                videoDetailInfo.area = content
            }else if currentElement == "duration"{
                videoDetailInfo.duration = content
            }else if currentElement == "cate"{
                videoDetailInfo.category = content
            }else if currentElement == "screenTime"{
                videoDetailInfo.publishTime = content
            }else if currentElement == "director"{
                videoDetailInfo.directorString = content
            }else if currentElement == "isEpisode"{
                videoDetailInfo.chooseDramaFlag = Int(content)!
            }else if currentElement == "episodeOrder"{
                videoDetailInfo.dramaOrderFlag = Int(content)!
            }else if currentElement == "performer"{
                videoDetailInfo.actorString = content
            }else if currentElement == "annotation"{
                videoDetailInfo.desc = content
            }else if currentElement == "smallImg"{
                videoDetailInfo.poster = content
            }else if currentElement == "most"{
                if currentDepth == 3 {
                    videoDetailInfo.resolutionType = Int(content)
                }
            }else if currentElement == "totalInfo"{
                videoDetailInfo.count = Int(content)
            }

        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == RequestId.GET_VIDEO_SOURCE {
            if elementName == "video_source_info" {
                currentDepth -= 1
                sourceList.append(videoSource)
                videoSource = nil
            }else if elementName == "source" {
                currentDepth -= 1
                videoSource.source = source
                source = nil
            }
        }else if requestId == RequestId.GET_VIDEO_DETAIL{
            if elementName == "video" {
                currentDepth -= 1
            }else if elementName == "response"{
                currentDepth -= 1
            }else if elementName == "videoMergeInfo"{
                currentDepth -= 1
                dramas.append(drama)
                drama = nil
            }else if elementName == "videoMergeInfoList"{
                currentDepth -= 1
                videoDetailInfo.dramas = dramas
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        currentDepth = 0
        if requestId == RequestId.GET_VIDEO_SOURCE {
            videoDetailInfo.currentDrama?.sources = sourceList
            if videoDetailInfo.currentDrama!.hasSource() {
                let item:VideoHistoryItem? = VideoDBHelper.shareInstance().getHistoryItem(videoDetailInfo.id)
                if item != nil {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(VideoInfoUtils.getSourcePositionBySourceId(videoDetailInfo, sourceId: item!.sourceId))
                }else {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(0)
                }
            }
            preLoadingView.sourceNameLbl.text = videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo()?.source?.name
            let currentReadableDrama = VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: videoDetailInfo.dramas.count, index: videoDetailInfo.lastPlayDramaPosition)
            preLoadingView.setDrama(currentReadableDrama)
            preLoadingView.hidden = false
        }else if requestId == RequestId.GET_VIDEO_DETAIL{
            videoDetailInfo.dramaPlayedDuration = videoHistoryItem.playedDuration
            videoDetailInfo.setLastPlayDramaPosition(videoHistoryItem.playedDrama)
//            videoDetailInfo.currentDrama = videoDetailInfo.dramas[videoHistoryItem.playedDrama]
        }
    }
    
}