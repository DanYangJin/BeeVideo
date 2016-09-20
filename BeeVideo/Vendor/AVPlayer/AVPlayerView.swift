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

public enum PlaybackState:Int, CustomStringConvertible {
    case Stopped = 0
    case Playing
    case Paused
    case Failed
    
    public var description: String {
        get {
            switch self {
            case Stopped:
                return "Stopped"
            case Playing:
                return "Playing"
            case Failed:
                return "Failed"
            case Paused:
                return "Paused"
            }
        }
    }
}

public enum BufferingState: Int, CustomStringConvertible {
    case Unknown = 0
    case Ready
    case Delayed
    
    public var description: String {
        get {
            switch self {
            case Unknown:
                return "Unknown"
            case Ready:
                return "Ready"
            case Delayed:
                return "Delayed"
            }
        }
    }
}

@objc protocol AVPlayerDelegate {
    //播放进度
    func onUpdateProgress(playView:AVPlayerView, currentTime:Int, totalTime:Int)
    //准备完成
    func onPreparedCompetion(playView:AVPlayerView)
    //播放错误
    func onError(playView:AVPlayerView)
    //缓冲变化
    func onUpdateBuffering(playView:AVPlayerView, bufferingValue:Float)
    //加载信息
    func onInfo(playView:AVPlayerView)
    //结束
    func onCompletion(playView:AVPlayerView)
    
}

public class AVPlayerView: UIView {
    
    private var videoUrl:String!
    private var asset:AVAsset!
    internal var playerItem:AVPlayerItem!
    internal var player:AVPlayer!
    
    //private var timeObserver: AnyObject!
    
    internal var playerLayer:AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }
    
    public var muted:Bool {
        get{
            return self.player.muted
        }
        set{
            self.player.muted = newValue
        }
    }
    
    public var fillMode: String {
        get {
            return (self.layer as! AVPlayerLayer).videoGravity
        }
        set {
            (self.layer as! AVPlayerLayer).videoGravity = newValue
        }
    }
    
    public var playbackLoops: Bool {
        get {
            return (self.player.actionAtItemEnd == .None) as Bool
        }
        set {
            if newValue.boolValue {
                self.player.actionAtItemEnd = .None
            } else {
                self.player.actionAtItemEnd = .Pause
            }
        }
    }
    
    public var playbackFreezesAtEnd: Bool = false
    public var isUserPause = false
    
    public var playbackState: PlaybackState = .Stopped {
        didSet {
            if playbackState == .Failed{
                delegate.onError(self)
            }
        }
    }
    
    public var bufferingState: BufferingState = .Unknown {
        didSet {
            guard bufferingState != .Ready else{
                self.delegate?.onInfo(self)
                return
            }
            
            if bufferingState != oldValue || !playbackEdgeTriggered {
                self.delegate?.onInfo(self)
            }
        }
    }
    
    public var bufferSize: Double = 3
    public var playbackEdgeTriggered: Bool = true
    
    public var maximumDuration: NSTimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    public var currentTime: NSTimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    public var naturalSize: CGSize {
        get {
            if let playerItem = self.playerItem {
                let track = playerItem.asset.tracksWithMediaType(AVMediaTypeVideo)[0]
                return track.naturalSize
            } else {
                return CGSizeZero
            }
        }
    }
    
    
    //回调
    private weak var delegate:AVPlayerDelegate!
    
    override public class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    /**
     * 初始化Player
     */
    func initUI(){
        //
        self.player = AVPlayer()
        self.player.actionAtItemEnd = .Pause
        self.playbackLoops = false
        self.playbackFreezesAtEnd = false
        self.fillMode = AVLayerVideoGravityResizeAspect
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.layer.addObserver(self, forKeyPath: PlayerReadyForDisplayKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]), context: &PlayerLayerObserverContext)
        
        self.player.addObserver(self, forKeyPath: PlayerRateKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]) , context: &PlayerObserverContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: UIApplication.sharedApplication())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: UIApplication.sharedApplication())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
    }
    
    func setDataSource(videoUrl:String, startTime: Int = 0){

        if self.playbackState == .Playing{
            self.pause()
        }
        let image:UIImage? = UIImage(named: "loading_bgView")
        self.layer.contents = image?.CGImage
        
        self.setupPlayItem(nil)
        let asset = AVURLAsset(URL: NSURL(string:videoUrl)!, options: .None)
        self.setupAsset(asset,startTime: startTime)
        
    }
    
    //设置监听
    func setDelegate(playerDelegate:AVPlayerDelegate){
        self.delegate = playerDelegate
    }
    
    //从头开始播放
    public func playFromBegining(){
        self.player.seekToTime(kCMTimeZero)
        self.playFromCurrentTime()
    }
    
    public func playFromCurrentTime(){
        self.playbackState = .Playing
        self.player.play()
    }
    
    public func stop(){
        if playbackState == .Stopped{
            return
        }
        self.player.pause()
        self.playbackState = .Stopped
        //self.delegate.onError(self)
    }
    
    
    private func setupAsset(asset: AVAsset, startTime:Int = 0){
        if self.playbackState == .Playing{
            self.pause()
        }
        
        self.bufferingState = .Unknown
        
        self.asset = asset
        if let _ = self.asset{
            self.setupPlayItem(nil)
        }
        
        let keys:[String] = [PlayerTracksKey, PlayerPlayableKey, PlayerDurationKey]
        
        self.asset.loadValuesAsynchronouslyForKeys(keys) {
            dispatch_sync(dispatch_get_main_queue(), {
                for key in keys{
                    var error:NSError?
                    let status = self.asset.statusOfValueForKey(key, error: &error)
                    if status == .Failed{
                        self.playbackState = .Failed
                        return
                    }
                }
                
                if !self.asset.playable.boolValue {
                    self.playbackState = .Failed
                    return
                }
                
                let playItem = AVPlayerItem(asset: self.asset)
                self.setupPlayItem(playItem,startTime: startTime)
            })
        }
        
    }
    
    
    private func setupPlayItem(playerItem: AVPlayerItem?,startTime:Int = 0){
        if self.playerItem != nil{
            self.playerItem?.removeObserver(self, forKeyPath: PlayerEmptyBufferKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerKeepUpKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerStatusKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, context: &PlayerItemObserverContext)
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemFailedToPlayToEndTimeNotification, object: self.playerItem)
        }
        
        self.playerItem = playerItem
        
        if self.playerItem != nil {
            self.playerItem?.addObserver(self, forKeyPath: PlayerEmptyBufferKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerKeepUpKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerStatusKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, options: ([NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old]), context: &PlayerItemObserverContext)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidPlayToEndTime(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerItem)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemFailedToPlayToEndTime(_:)), name: AVPlayerItemFailedToPlayToEndTimeNotification, object: self.playerItem)
        }
        
        self.player.replaceCurrentItemWithPlayerItem(self.playerItem)
        if self.playbackLoops.boolValue{
            self.player.actionAtItemEnd = .None
        }else{
            self.player.actionAtItemEnd = .Pause
        }
       // self.seekToTime(startTime)
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
    
    /**
     * 播放
     */
    func play(){
        guard player != nil else{
            return
        }
        self.player.play()
        self.playbackState = .Playing
    }
    
    /**
     * 暂停
     */
    func pause(){
        // self.setTimering(false)
        guard player != nil else{
            return
        }
        guard self.playbackState == .Playing else{
            return
        }
        self.player.pause()
        self.playbackState = .Paused
    }
    
    /**
     * 快进到某一时间
     */
    func seekToTime(dragedSeconds:Int){

        let dragedCMTime:CMTime  = CMTimeMake(Int64(dragedSeconds), 1);
        if let playerItem = self.playerItem {
            self.bufferingState = .Delayed
            playerItem.seekToTime(dragedCMTime, completionHandler: { (finish) in
                print(finish)
                if finish{
                    //self.bufferingState = .Ready
                }else{
                    self.playFromCurrentTime()
                }
            })
        }
    }
    
    //获取当前时间
    func getCurrentTime() -> Int{
        guard playerItem != nil else{
            return 0
        }
        if playerItem.duration.timescale == 0 {
            return 0
        }
        return Int(CMTimeGetSeconds(player.currentTime()))
    }
    
    //获取总时间
    func getDuration() -> Int{
        guard playerItem != nil else{
            return 0
        }
        if playerItem.duration.timescale == 0 {
            return 0
        }
        return Int(playerItem.duration.value) / Int(playerItem.duration.timescale)
    }
    
    // 获取当前播放状态
    func getItemStatus() -> AVPlayerItemStatus{
        return self.player.currentItem!.status;
    }
    
    deinit {
        //self.player.removeTimeObserver(timeObserver)
        self.delegate = nil
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.layer.removeObserver(self, forKeyPath: PlayerReadyForDisplayKey, context: &PlayerLayerObserverContext)
        
        self.player.removeObserver(self, forKeyPath: PlayerRateKey, context: &PlayerObserverContext)
        
        self.player.pause()
        
        self.setupPlayItem(nil)
        self.player = nil
    }
    
    
}

// MARK: - KVO

// KVO contexts

private var PlayerObserverContext = 0
private var PlayerItemObserverContext = 0
private var PlayerLayerObserverContext = 0

// KVO player keys

private let PlayerTracksKey = "tracks"
private let PlayerPlayableKey = "playable"
private let PlayerDurationKey = "duration"
private let PlayerRateKey = "rate"

// KVO player item keys

private let PlayerStatusKey = "status"
private let PlayerEmptyBufferKey = "playbackBufferEmpty"
private let PlayerKeepUpKey = "playbackLikelyToKeepUp"
private let PlayerLoadedTimeRangesKey = "loadedTimeRanges"

// KVO player layer keys

private let PlayerReadyForDisplayKey = "readyForDisplay"

extension AVPlayerView{
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        switch (keyPath, context) {
        case (.Some(PlayerRateKey), &PlayerObserverContext):
            true
        case (.Some(PlayerStatusKey), &PlayerItemObserverContext):
            if self.player.currentItem?.status == .Failed{
                guard delegate != nil else {
                    return
                }
                self.layer.contents = nil
                delegate.onError(self)
            }
        case (.Some(PlayerKeepUpKey), &PlayerItemObserverContext):
            if let item = self.playerItem {
                print(playbackState)
                if item.playbackLikelyToKeepUp{
                    self.bufferingState = .Ready
                    if isUserPause{
                        return
                    }
                    self.playFromCurrentTime()
                }
            }
            
            let status = (change?[NSKeyValueChangeNewKey] as! NSNumber).integerValue as AVPlayerStatus.RawValue
            
            switch (status) {
            case AVPlayerStatus.ReadyToPlay.rawValue:
                self.playerLayer.player = self.player
                self.play()
                break
            case AVPlayerStatus.Failed.rawValue:
                self.playbackState = PlaybackState.Failed
            default:
                true
            }
        case (.Some(PlayerEmptyBufferKey), &PlayerItemObserverContext):
            if let item = self.playerItem {
                if item.playbackBufferEmpty {
                    self.bufferingState = .Delayed
                    self.playbackState = .Stopped
                }
            }
            
            let status = (change?[NSKeyValueChangeNewKey] as! NSNumber).integerValue as AVPlayerStatus.RawValue
            
            switch (status) {
            case AVPlayerStatus.ReadyToPlay.rawValue:
                self.playerLayer.player = self.player
                self.playerLayer.hidden = false
            case AVPlayerStatus.Failed.rawValue:
                self.playbackState = PlaybackState.Failed
            default:
                true
            }
        case (.Some(PlayerLoadedTimeRangesKey), &PlayerItemObserverContext):
            guard let item = self.playerItem else {
                return
            }
            let timerange = (change?[NSKeyValueChangeNewKey] as! NSArray)[0].CMTimeRangeValue
            let bufferedTime = CMTimeGetSeconds(CMTimeAdd(timerange.start, timerange.duration))
            let currentTime = CMTimeGetSeconds(item.currentTime())
            
            if bufferedTime - currentTime >= self.bufferSize && self.playbackState != .Playing {
                if !isUserPause{
                    self.bufferingState = .Ready
                    self.playFromCurrentTime()
                }
            }
            
            guard delegate != nil else{
                return
            }
            
            delegate.onUpdateBuffering(self, bufferingValue: Float(bufferedTime)/Float(self.getDuration()))
            
        case (.Some(PlayerReadyForDisplayKey), &PlayerLayerObserverContext):
            if self.playerLayer.readyForDisplay {
                self.layer.contents = nil
                self.delegate?.onPreparedCompetion(self)
            }
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            
        }
    }
}


// MARK:  Notifictaion
extension AVPlayerView{
    
    public func playerItemDidPlayToEndTime(aNotification: NSNotification) {
        if self.playbackLoops.boolValue == true {
            self.delegate?.onCompletion(self)
            self.player.seekToTime(kCMTimeZero)
        } else {
            if self.playbackFreezesAtEnd.boolValue == true {
                self.stop()
            } else {
                self.player.seekToTime(kCMTimeZero, completionHandler: { _ in
                    self.stop()
                })
            }
        }
    }
    
    public func playerItemFailedToPlayToEndTime(aNotification: NSNotification) {
        self.playbackState = .Failed
    }
    
    public func applicationWillResignActive(aNotification: NSNotification) {
        if self.playbackState == .Playing {
            self.pause()
        }
    }
    
    public func applicationDidEnterBackground(aNotification: NSNotification) {
        if self.playbackState == .Playing {
            self.pause()
        }
    }
    
    public func applicationWillEnterForeground(aNoticiation: NSNotification) {
        if self.playbackState == .Paused {
            self.playFromCurrentTime()
        }
    }
    
}


