//
//  AVPlayerView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import AVFoundation
//import SnapKit

public enum PlaybackState:Int, CustomStringConvertible {
    case stopped = 0
    case playing
    case paused
    case failed
    
    public var description: String {
        get {
            switch self {
            case .stopped:
                return "Stopped"
            case .playing:
                return "Playing"
            case .failed:
                return "Failed"
            case .paused:
                return "Paused"
            }
        }
    }
}

public enum BufferingState: Int, CustomStringConvertible {
    case unknown = 0
    case ready
    case delayed
    
    public var description: String {
        get {
            switch self {
            case .unknown:
                return "Unknown"
            case .ready:
                return "Ready"
            case .delayed:
                return "Delayed"
            }
        }
    }
}

@objc protocol AVPlayerDelegate {
    //播放进度
    func onUpdateProgress(_ playView:AVPlayerView, currentTime:Int, totalTime:Int)
    //准备完成
    func onPreparedCompetion(_ playView:AVPlayerView)
    //播放错误
    func onError(_ playView:AVPlayerView)
    //缓冲变化
    func onUpdateBuffering(_ playView:AVPlayerView, bufferingValue:Float)
    //加载信息
    func onInfo(_ playView:AVPlayerView)
    //结束
    func onCompletion(_ playView:AVPlayerView)
    
}

open class AVPlayerView: UIView {
    
    fileprivate var videoUrl:String!
    fileprivate var asset:AVAsset!
    internal var playerItem:AVPlayerItem!
    internal var player:AVPlayer!
    
    //private var timeObserver: AnyObject!
    
    internal var playerLayer:AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }
    
    open var muted:Bool {
        get{
            return self.player.isMuted
        }
        set{
            self.player.isMuted = newValue
        }
    }
    
    open var fillMode: String {
        get {
            return (self.layer as! AVPlayerLayer).videoGravity
        }
        set {
            (self.layer as! AVPlayerLayer).videoGravity = newValue
        }
    }
    
    open var playbackLoops: Bool {
        get {
            return (self.player.actionAtItemEnd == .none) as Bool
        }
        set {
            if newValue {
                self.player.actionAtItemEnd = .none
            } else {
                self.player.actionAtItemEnd = .pause
            }
        }
    }
    
    open var playbackFreezesAtEnd: Bool = false
    open var isUserPause = false
    
    open var playbackState: PlaybackState = .stopped {
        didSet {
            if playbackState == .failed{
                delegate.onError(self)
            }
        }
    }
    
    open var bufferingState: BufferingState = .unknown {
        didSet {
            guard bufferingState != .ready else{
                self.delegate?.onInfo(self)
                return
            }
            
            if bufferingState != oldValue || !playbackEdgeTriggered {
                self.delegate?.onInfo(self)
            }
        }
    }
    
    open var bufferSize: Double = 3
    open var playbackEdgeTriggered: Bool = true
    
    open var maximumDuration: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    open var currentTime: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    open var naturalSize: CGSize {
        get {
            if let playerItem = self.playerItem {
                let track = playerItem.asset.tracks(withMediaType: AVMediaTypeVideo)[0]
                return track.naturalSize
            } else {
                return CGSize.zero
            }
        }
    }
    
    
    //回调
    fileprivate weak var delegate:AVPlayerDelegate!
    
    override open class var layerClass : AnyClass {
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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    /**
     * 初始化Player
     */
    func initUI(){
        //
        self.player = AVPlayer()
        self.player.actionAtItemEnd = .pause
        self.playbackLoops = false
        self.playbackFreezesAtEnd = false
        self.fillMode = AVLayerVideoGravityResizeAspect
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.layer.addObserver(self, forKeyPath: PlayerReadyForDisplayKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: &PlayerLayerObserverContext)
        
        self.player.addObserver(self, forKeyPath: PlayerRateKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]) , context: &PlayerObserverContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    func setDataSource(_ videoUrl:String, startTime: Int = 0){

        if self.playbackState == .playing{
            self.pause()
        }
        let image:UIImage? = UIImage(named: "loading_bgView")
        self.layer.contents = image?.cgImage
        
        self.setupPlayItem(nil)
        let asset = AVURLAsset(url: URL(string:videoUrl)!, options: .none)
        self.setupAsset(asset,startTime: startTime)
        
    }
    
    //设置监听
    func setDelegate(_ playerDelegate:AVPlayerDelegate){
        self.delegate = playerDelegate
    }
    
    //从头开始播放
    open func playFromBegining(){
        self.player.seek(to: kCMTimeZero)
        self.playFromCurrentTime()
    }
    
    open func playFromCurrentTime(){
        self.playbackState = .playing
        self.player.play()
    }
    
    open func stop(){
        if playbackState == .stopped{
            return
        }
        self.player.pause()
        self.playbackState = .stopped
        //self.delegate.onError(self)
    }
    
    
    fileprivate func setupAsset(_ asset: AVAsset, startTime:Int = 0){
        if self.playbackState == .playing{
            self.pause()
        }
        
        self.bufferingState = .unknown
        
        self.asset = asset
        if let _ = self.asset{
            self.setupPlayItem(nil)
        }
        
        let keys:[String] = [PlayerTracksKey, PlayerPlayableKey, PlayerDurationKey]
        
        self.asset.loadValuesAsynchronously(forKeys: keys) {
            DispatchQueue.main.sync(execute: {
                for key in keys{
                    var error:NSError?
                    let status = self.asset.statusOfValue(forKey: key, error: &error)
                    if status == .failed{
                        self.playbackState = .failed
                        return
                    }
                }
                
                if !self.asset.isPlayable {
                    self.playbackState = .failed
                    return
                }
                
                let playItem = AVPlayerItem(asset: self.asset)
                self.setupPlayItem(playItem,startTime: startTime)
            })
        }
        
    }
    
    
    fileprivate func setupPlayItem(_ playerItem: AVPlayerItem?,startTime:Int = 0){
        if self.playerItem != nil{
            self.playerItem?.removeObserver(self, forKeyPath: PlayerEmptyBufferKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerKeepUpKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerStatusKey, context: &PlayerItemObserverContext)
            self.playerItem?.removeObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, context: &PlayerItemObserverContext)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: self.playerItem)
        }
        
        self.playerItem = playerItem
        
        if self.playerItem != nil {
            self.playerItem?.addObserver(self, forKeyPath: PlayerEmptyBufferKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerKeepUpKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerStatusKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: &PlayerItemObserverContext)
            self.playerItem?.addObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, options: ([NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]), context: &PlayerItemObserverContext)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEndTime(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: self.playerItem)
        }
        
        self.player.replaceCurrentItem(with: self.playerItem)
        if self.playbackLoops{
            self.player.actionAtItemEnd = .none
        }else{
            self.player.actionAtItemEnd = .pause
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
        self.playbackState = .playing
    }
    
    /**
     * 暂停
     */
    func pause(){
        // self.setTimering(false)
        guard player != nil else{
            return
        }
        guard self.playbackState == .playing else{
            return
        }
        self.player.pause()
        self.playbackState = .paused
    }
    
    /**
     * 快进到某一时间
     */
    func seekToTime(_ dragedSeconds:Int){

        let dragedCMTime:CMTime  = CMTimeMake(Int64(dragedSeconds), 1);
        if let playerItem = self.playerItem {
            self.bufferingState = .delayed
            playerItem.seek(to: dragedCMTime, completionHandler: { (finish) in
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
        
        NotificationCenter.default.removeObserver(self)
        
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
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath! {
        case PlayerRateKey:
            break
        case PlayerStatusKey:
            if self.player.currentItem?.status == .failed{
                guard delegate != nil else {
                    return
                }
                self.layer.contents = nil
                delegate.onError(self)
            }
        case PlayerKeepUpKey:
            if let item = self.playerItem {
                print(playbackState)
                if item.isPlaybackLikelyToKeepUp{
                    self.bufferingState = .ready
                    if isUserPause{
                        return
                    }
                    self.playFromCurrentTime()
                }
            }
            
            let status = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).intValue as AVPlayerStatus.RawValue
            
            switch (status) {
            case AVPlayerStatus.readyToPlay.rawValue:
                self.playerLayer.player = self.player
                self.play()
                break
            case AVPlayerStatus.failed.rawValue:
                self.playbackState = PlaybackState.failed
            default:
                true
            }
        case PlayerEmptyBufferKey:
            if let item = self.playerItem {
                if item.isPlaybackBufferEmpty {
                    self.bufferingState = .delayed
                    self.playbackState = .stopped
                }
            }
            
            let status = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).intValue as AVPlayerStatus.RawValue
            
            switch (status) {
            case AVPlayerStatus.readyToPlay.rawValue:
                self.playerLayer.player = self.player
                self.playerLayer.isHidden = false
            case AVPlayerStatus.failed.rawValue:
                self.playbackState = PlaybackState.failed
            default:
                true
            }
        case PlayerLoadedTimeRangesKey:
            guard let item = self.playerItem else {
                return
            }
            let timerange = ((change?[NSKeyValueChangeKey.newKey] as! NSArray)[0] as AnyObject).timeRangeValue
            let bufferedTime = CMTimeGetSeconds(CMTimeAdd((timerange?.start)!, (timerange?.duration)!))
            let currentTime = CMTimeGetSeconds(item.currentTime())
            
            if bufferedTime - currentTime >= self.bufferSize && self.playbackState != .playing {
                if !isUserPause{
                    self.bufferingState = .ready
                    self.playFromCurrentTime()
                }
            }
            
            guard delegate != nil else{
                return
            }
            
            delegate.onUpdateBuffering(self, bufferingValue: Float(bufferedTime)/Float(self.getDuration()))
            
        case PlayerReadyForDisplayKey:
            if self.playerLayer.isReadyForDisplay {
                self.layer.contents = nil
                self.delegate?.onPreparedCompetion(self)
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            
        }
    }
}


// MARK:  Notifictaion
extension AVPlayerView{
    
    public func playerItemDidPlayToEndTime(_ aNotification: Notification) {
        if self.playbackLoops == true {
            self.delegate?.onCompletion(self)
            self.player.seek(to: kCMTimeZero)
        } else {
            if self.playbackFreezesAtEnd == true {
                self.stop()
            } else {
                self.player.seek(to: kCMTimeZero, completionHandler: { _ in
                    self.stop()
                })
            }
        }
    }
    
    public func playerItemFailedToPlayToEndTime(_ aNotification: Notification) {
        self.playbackState = .failed
    }
    
    public func applicationWillResignActive(_ aNotification: Notification) {
        if self.playbackState == .playing {
            self.pause()
        }
    }
    
    public func applicationDidEnterBackground(_ aNotification: Notification) {
        if self.playbackState == .playing {
            self.pause()
        }
    }
    
    public func applicationWillEnterForeground(_ aNoticiation: Notification) {
        if self.playbackState == .paused {
            self.playFromCurrentTime()
        }
    }
    
}


