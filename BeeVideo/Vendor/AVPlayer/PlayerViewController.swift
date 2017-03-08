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
    case `init`
    case play
    case pause
    case error
    case buffering
    case completion
}

public enum PanDirection {
    case panDirectionInit //初始
    case panDirectionHorizontalMoved //横向移动
    case panDirectionVerticalMoved    //纵向移动
}

public enum Flag{
    case unKnow
    case detail
    case history
}

class PlayerViewController: UIViewController, AVPlayerDelegate, UIGestureRecognizerDelegate,VideoMenuDelegate{
    
    enum RequestId {
        case get_VIDEO_SOURCE
        case get_VIDEO_PALY_URL
        case get_VIDEO_DETAIL
    }
    
    var flag:Flag = .detail
    var videoDetailInfo:VideoDetailInfo!
    var videoHistoryItem:VideoHistoryItem!
    var subjectId = ""
    var videoPlayItem:VideoPlayItem!
    
    fileprivate var requestId:RequestId!
    
    fileprivate var videoPlayerView:AVPlayerView!
    fileprivate var controlView:AVPlayerControlView!
    fileprivate var progressView:ProgressView!
    fileprivate var volumeViewSlider:UISlider!
    internal var horizontalLabel:UILabel!
    fileprivate var netLoadingView:NetSpeedView!
    fileprivate var preLoadingView:PreLoadingView!
    fileprivate var menuView:VideoMenuViewController!
    
    //临时变量
    fileprivate var screenWidth:CGFloat!,screenHeight:CGFloat!
    fileprivate var index:Int = 0
    fileprivate var isVolumed:Bool = false
    fileprivate var moveDirection:PanDirection!
    fileprivate var videoStatus:PlayerStatus!
    fileprivate var sumTime:CGFloat = 0
    fileprivate var lastSlideValue:CGFloat = 0
    fileprivate var lastPlayerPosition:Int = 0
    
    //xml临时变量
    fileprivate var dramas:[Drama]!
    fileprivate var drama:Drama!
    
    //fileprivate var reachability : Reachability?
    
    var timer:Timer!
    
    //xml解析临时变量
    //无源时获取源
    fileprivate var videoSource:VideoSourceInfo!
    fileprivate var source:Source!
    fileprivate var sourceList = [VideoSourceInfo]()
    fileprivate var currentDepth = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotifications()
        self.configVolume()
        
        self.videoPlayerView.setDataSource(Constants.URLS[index],startTime: 60)
        self.videoPlayerView.playbackLoops = true
        //       // controlView.videoNameLabel.text = videoDetailInfo.currentDrama?.title
        //        getVideoPlayUrl()
        if flag == Flag.detail {
            controlView.videoNameLabel.text = videoDetailInfo.name
            if videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo() == nil {
                preLoadingView.isHidden = true
                getSourceInfo()
            }
        }else if flag == Flag.history{
            getVideoDetail(videoHistoryItem.videoId)
        }
    }
    
    func initUI(){
        self.view.backgroundColor = UIColor.black
        
        self.screenWidth     = self.view.bounds.size.width
        self.screenHeight    = self.view.bounds.size.height
        
        self.view.addSubview(self.initAVPlayerView())
        self.view.addSubview(self.initControlView())
        self.view.addSubview(self.initHorizontalLabel())
        self.view.addSubview(self.initProgressView())
        self.view.addSubview(self.initNetLoadingView())
        self.view.addSubview(self.initPreLoadingView())
        
        self.videoStatus     = PlayerStatus.init
        self.moveDirection   = PanDirection.panDirectionInit
        
        self.makeSubViewsConstraints()
        
        //self.setTimering(true)
        
    }
    func makeSubViewsConstraints(){
        self.horizontalLabel.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.center.equalTo(self.view)
        }
        self.netLoadingView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(self.view).multipliedBy(0.15)
            make.width.equalTo(self.view).multipliedBy(0.32)
        }
        self.preLoadingView.snp.makeConstraints { (make) in
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
            horizontalLabel.textColor       = UIColor.white
            horizontalLabel.textAlignment   = NSTextAlignment.center
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
            case .detail:
                preLoadingView.dramaLbl.text = "即将播放：第\(3)集"
                preLoadingView.videoNameLbl.text = videoDetailInfo.name
                preLoadingView.sourceNameLbl.text = videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo()?.source?.name
            case .history:
                preLoadingView.dramaLbl.text = "即将播放：第\(videoHistoryItem.playedDrama)集"
                preLoadingView.videoNameLbl.text = videoHistoryItem.videoName
                preLoadingView.sourceNameLbl.text = videoHistoryItem.sourceName
            case .unKnow:
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
            menuView = VideoMenuViewController(frame: CGRect.zero, data: videoDetailInfo,currentIndex: index)
            menuView.delegate = self
            menuView.isHidden = true
            self.view.addSubview(menuView)
            menuView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.view)
                make.top.bottom.equalTo(self.view)
            }
        }
        
        return self.menuView
    }
    
    func addNotifications(){
        self.controlView.playButton.addTarget(self, action: (#selector(onPauseOrPlay)), for: .touchUpInside)
        //切换下一集
        self.controlView.nextDramaBtn.addTarget(self, action: #selector(playNextDrama), for: .touchUpInside)
        // slider开始滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), for: .touchDown)
        // slider滑动中事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), for: .valueChanged)
        // slider结束滑动事件
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchUpInside)
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchUpOutside)
        self.controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchCancel)
        
        self.controlView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        self.controlView.menuButton.addTarget(self, action: #selector(self.popupMenu), for: .touchUpInside)
        
        self.createGesture()
        
//        do{
//            try reachability = Reachability.reachabilityForInternetConnection()
//        }catch{
//            print("reachability start fail")
//            return
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil)
//        do{
//            try reachability?.startNotifier()
//        }catch{
//            print("notifier can not start")
//        }
        
    }
    
    //网络改变
    func reachabilityChanged(_ nate:Notification){
//        let reachability = nate.object as! Reachability
//        if reachability.isReachable() {
//            if reachability.isReachableViaWiFi(){
//                print("wifi connected")
//            }else{
//                print("mobile connnected")
//            }
//        }else{
//            print("net work disconnected")
//        }
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //print(touch.view?.isDescendantOfView(controlView))
        if touch.view!.isKind(of: UISlider.self) || touch.view!.isKind(of: UIButton.self) {
            return false
        } else {
            return true
        }
    }
    
    //单击
    func tapAction(_ tap:UITapGestureRecognizer){
        if menuView == nil || menuView.isHidden{
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
        case .play:
            videoPlayerView.isUserPause = true
            pausePlay()
        case .pause:
            videoPlayerView.isUserPause = false
            resumePlay()
        default:
            break
        }
    }
    
    /**
     * 手势滑动
     */
    func panDirection(_ pan:UIPanGestureRecognizer){
        let locationPoint:CGPoint   = pan.location(in: self.view)
        let veloctyPoint:CGPoint    = pan.velocity(in: self.view)
        switch pan.state {
        case .began:
            judgePanDirection(locationPoint, veloctyPoint: veloctyPoint)
            break
        case .changed:
            switch self.moveDirection! {
            case .panDirectionHorizontalMoved:
                self.horizontalMoved(veloctyPoint.x) // 水平移动的方法只要x方向的值
                break
            case .panDirectionVerticalMoved:
                self.verticalMoved(veloctyPoint.y) // 垂直移动方法只要y方向的值
                break
            default:
                break
            }
            break
        case .ended:
            //滑动结束重置MoveDirection
            switch self.moveDirection! {
            case .panDirectionHorizontalMoved:
                self.horizontalLabel.alpha           = 0.0
                netLoadingView.startAnimate()
                self.videoPlayerView.seekToTime(Int.init(self.sumTime))
                self.sumTime = 0
                break
            case .panDirectionVerticalMoved:
                self.isVolumed = false
                break
            default:
                break
            }
            self.moveDirection = PanDirection.panDirectionInit
            break
        default:
            break
        }
    }
    
    //判断滑动方向
    func judgePanDirection(_ locationPoint:CGPoint, veloctyPoint:CGPoint){
        let x:CGFloat = fabs(veloctyPoint.x);
        let y:CGFloat = fabs(veloctyPoint.y);
        
        if x > y{
            self.horizontalLabel.alpha           = 1.0
            self.moveDirection = PanDirection.panDirectionHorizontalMoved
            self.sumTime = CGFloat.init(self.videoPlayerView.getCurrentTime())
        } else {
            self.moveDirection = PanDirection.panDirectionVerticalMoved
            if locationPoint.x > self.screenWidth! / 2 {
                self.isVolumed = true
            }else {// 状态改为显示亮度调节
                self.isVolumed = false
            }
        }
    }
    
    //水平移动
    func horizontalMoved(_ value:CGFloat){
        // 快进快退的方法
        var style:String = ""
        
        if (value < 0) {
            style.append("<<");
        } else if (value > 0){
            style.append(">>");
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
    func verticalMoved(_ value:CGFloat){
        if self.isVolumed {
            self.volumeViewSlider.value      -=  Float.init(value / 10000)
        }else {
            UIScreen.main.brightness -= value / 10000
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
        self.videoStatus = PlayerStatus.play
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
        self.videoStatus = PlayerStatus.pause
        self.videoPlayerView.pause()
        self.setTimering(false)
        self.controlView.changePlayButtonBg(true)
    }
    
    /**
     *  滑块事件监听
     */
    func progressSliderTouchBegan(_ slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .readyToPlay {
            return
        }
        self.setTimering(false)
        self.lastPlayerPosition = self.videoPlayerView.getCurrentTime()
    }
    
    func progressSliderValueChanged(_ slider:UISlider){
        if self.videoPlayerView.getItemStatus() != .readyToPlay {
            return
        }
        let value:CGFloat = CGFloat(slider.value) - self.lastSlideValue
        var style:String = ""
        if (value < 0) {
            style.append("<<");
        } else if (value >= 0){
            style.append(">>");
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
    
    func progressSliderTouchEnded(_ slider:UISlider){
        
        if self.videoPlayerView.getItemStatus() != .readyToPlay {
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
        menuView.isHidden = false
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
        self.dismiss(animated: true,completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.savePlayedDuration()
        self.saveHistory()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HistroyChangedNotify"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //获取视频详情
    func getVideoDetail(_ videoId:String){
//        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_DETAIL_INFO_V2)!, parameters: ["videoId": videoId]).responseData { (response) in
//            self.requestId = RequestId.get_VIDEO_DETAIL
//            print(response.request?.URLString)
//            switch response.result {
//            case .failure( _):
//                
//                break
//            case .success(let data):
//                let parse = XMLParser(data: data)
//                parse.delegate = self
//                parse.parse()
//                break
//                
//            }
//        }

    }
    
    
    //获取源
    func getSourceInfo(){
        if videoDetailInfo.currentDrama == nil {
            return
        }
//        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_LIST_VIDEO_SOURCE_INFO)!, parameters: ["videoMergeInfoId" : (videoDetailInfo.currentDrama?.id)!]).responseData{
//            response in
//            self.requestId = RequestId.get_VIDEO_SOURCE
//            switch response.result{
//            case .success(let data):
//                let parser = XMLParser(data: data)
//                parser.delegate = self
//                parser.parse()
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }
    }
    
    //获取播放地址
    func getVideoPlayUrl(){
        let sourceInfo = videoDetailInfo.currentDrama?.currentUsedSourceInfo
        if sourceInfo == nil {
            return
        }
        var params:[String:AnyObject] = [String:AnyObject]()
        params["videoInfoId"] = sourceInfo?.id as AnyObject?
        params["subjectId"] = self.subjectId as AnyObject?
        params["model"] = UIDevice.current.localizedModel as AnyObject?
//        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_DAILY_PLAY_SOURCE)!, parameters: params).responseData { (response) in
//            self.requestId = RequestId.get_VIDEO_PALY_URL
//            
//            switch response.result{
//            case .failure(let error):
//                print(error)
//                break
//            case .success(let data):
//                let parser = XMLParser(data: data)
//                parser.delegate = self
//                parser.parse()
//                break
//            }
//        }
    }
    
    //xml解析
    fileprivate var currentElement = ""
    
    //更新进度条
    func playerTimeAction(){
        self.onUpdateProgress(videoPlayerView, currentTime: videoPlayerView.getCurrentTime(), totalTime: videoPlayerView.getDuration())
    }
    
    func setTimering(_ timering:Bool){
        if timering {
            if timer == nil{
                timer = Timer.scheduledTimer(timeInterval: 1,target:self,selector:#selector(playerTimeAction),userInfo:nil,repeats:true)
            }
        }else{
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
        }
    }
    
    func changeDrama(_ index: Int) {
        self.index = index
        let size:Int = Constants.URLS.count
        if index >= size {
            return
        }
        self.controlView.resetControlView()
        self.netLoadingView.startAnimate()
        self.preLoadingView.isHidden = false
        self.horizontalLabel.alpha = 0.0
        self.videoPlayerView.setDataSource(Constants.URLS[index])
        
    }
    
    func saveHistory(){
        VideoDBHelper.shareInstance.saveOrUpdate(videoDetailInfo)
    }
    
    func savePlayedDuration(){
        videoDetailInfo.dramaPlayedDuration = videoPlayerView.getCurrentTime()
    }
    
}

extension PlayerViewController{
    //播放进度
    func onUpdateProgress(_ playView:AVPlayerView, currentTime:Int, totalTime:Int){
        if currentTime == self.lastPlayerPosition {
            return
        }
        self.controlView.updateProgress(currentTime, totalTime: totalTime)
        self.controlView.videoSlider.maximumValue   = 1
        let progress:Float = Float(currentTime) / Float(totalTime)
        self.controlView.videoSlider.setValue(progress, animated: true)
    }
    
    //准备完成
    func onPreparedCompetion(_ playView:AVPlayerView) {
        self.videoStatus = PlayerStatus.play
        self.videoPlayerView.play()
        self.netLoadingView.stopAnimat()
        self.preLoadingView.isHidden = true
        controlView.changePlayButtonBg(false)
        if videoHistoryItem != nil{
            videoPlayerView.seekToTime(videoHistoryItem.playedDuration)
        }
    }
    
    //播放错误
    func onError(_ playView:AVPlayerView) {
        self.videoStatus = PlayerStatus.error
        // self.playNextDrama()
        self.view.makeToast("播放失败")
    }
    
    //缓冲变化
    func onUpdateBuffering(_ playView:AVPlayerView, bufferingValue:Float) {
        guard controlView != nil else{
            return
        }
        self.controlView.progressView.setProgress(bufferingValue, animated: true)
    }
    
    //加载信息
    func onInfo(_ playView:AVPlayerView) {
        
        switch playView.bufferingState {
        case .ready:
            self.setTimering(true)
            self.netLoadingView.stopAnimat()
        case .delayed:
            self.setTimering(false)
            self.netLoadingView.startAnimate()
        default:
            self.netLoadingView.startAnimate()
            break
        }
        
    }
    //结束
    func onCompletion(_ playView:AVPlayerView) {
        self.videoStatus = PlayerStatus.completion
        self.playNextDrama()
    }
    
    //播放下一集
    func playNextDrama(){
        self.controlView.resetControlView()
        //self.controlView.loadingView.startAnimating()
        self.netLoadingView.startAnimate()
        self.preLoadingView.isHidden = false
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


extension PlayerViewController : XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == RequestId.get_VIDEO_SOURCE {
            if currentElement == "video_source_info" {
                videoSource = VideoSourceInfo()
                currentDepth += 1
            }else if currentElement == "source" {
                source = Source()
                currentDepth += 1
            }
        }else if requestId == RequestId.get_VIDEO_DETAIL{
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
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if requestId == RequestId.get_VIDEO_SOURCE {
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
        }else if requestId == RequestId.get_VIDEO_DETAIL{
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == RequestId.get_VIDEO_SOURCE {
            if elementName == "video_source_info" {
                currentDepth -= 1
                sourceList.append(videoSource)
                videoSource = nil
            }else if elementName == "source" {
                currentDepth -= 1
                videoSource.source = source
                source = nil
            }
        }else if requestId == RequestId.get_VIDEO_DETAIL{
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        currentDepth = 0
        if requestId == RequestId.get_VIDEO_SOURCE {
            videoDetailInfo.currentDrama?.sources = sourceList
            if videoDetailInfo.currentDrama!.hasSource() {
                let item:VideoHistoryItem? = VideoDBHelper.shareInstance.getHistoryItem(videoDetailInfo.id)
                if item != nil {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(VideoInfoUtils.getSourcePositionBySourceId(videoDetailInfo, sourceId: item!.sourceId))
                }else {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(0)
                }
            }
            preLoadingView.sourceNameLbl.text = videoDetailInfo.currentDrama?.getCurrentUsedSourceInfo()?.source?.name
            let currentReadableDrama = VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: videoDetailInfo.dramas.count, index: videoDetailInfo.lastPlayDramaPosition)
            preLoadingView.setDrama(currentReadableDrama)
            preLoadingView.isHidden = false
        }else if requestId == RequestId.get_VIDEO_DETAIL{
            videoDetailInfo.dramaPlayedDuration = videoHistoryItem.playedDuration
            videoDetailInfo.setLastPlayDramaPosition(videoHistoryItem.playedDrama)
            print(videoDetailInfo.dramas.count)
            print(videoHistoryItem.playedDrama)
            //videoDetailInfo.currentDrama = videoDetailInfo.dramas[videoHistoryItem.playedDrama]
        }
    }
    
}
