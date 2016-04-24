//
//  ProgressView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    private var toolBar:UIToolbar!
    private var properyImage:UIImageView!
    private var properyName:UILabel!
    private var longView:UIView!
    
    //临时变量
    private var screenWidth:CGFloat!
    private var screenHeight:CGFloat!
    private var images:[UIImageView]!
    private var timer:NSTimer!
    
    
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
    
    func initUI(){
        self.screenWidth     = UIScreen.mainScreen().bounds.size.width
        self.screenHeight    = UIScreen.mainScreen().bounds.size.height
        //自定义View
        self.frame                  = CGRectMake(screenWidth * 0.36, screenHeight * 0.26, 155, 155)
        self.layer.cornerRadius     = 10;
        self.layer.masksToBounds    = true;
        self.alpha                  = 0.0
        //使用UIToolbar实现毛玻璃效果
        self.addSubview(self.initToolBar())
        self.addSubview(self.initProperyName())
        self.addSubview(self.initProperyImage())
        self.addSubview(self.initLongView())
        //
        self.createImages()
        self.addObserver()
        
    }
    
    //初始化UIToolBar
    func initToolBar() -> UIToolbar{
        if self.toolBar == nil {
            self.toolBar                = UIToolbar()
            self.toolBar.frame          = CGRectMake(0, 0, self.frame.width, self.frame.height)
            self.toolBar.alpha          = 0.7
        }
        return self.toolBar
    }
    
    //初始化类型（声音或者亮度）
    func initProperyImage() -> UIImageView{
        if self.properyImage == nil {
            self.properyImage       = UIImageView()
            self.properyImage.frame = CGRectMake(35, 40, 79, 76)
            self.properyImage.image = UIImage(named: "playgesture_BrightnessSun6")
        }
        return self.properyImage
    }
    
    func initProperyName() -> UILabel{
        if self.properyName == nil {
            self.properyName                = UILabel()
            self.properyName.frame          = CGRectMake(0, 5, self.frame.width, 30)
            self.properyName.font           = UIFont.boldSystemFontOfSize(16)
            self.properyName.textColor      = UIColor.whiteColor()
            self.properyName.textAlignment  = NSTextAlignment.Center
            self.properyName.text           = "亮度"
        }
        return self.properyName
    }

    func initLongView() ->UIView {
        if self.longView == nil {
            self.longView                   = UIView()
            self.longView.frame             = CGRectMake(13, 132, self.bounds.size.width - 26, 7)
            self.longView.backgroundColor   = UIColor.init(red: 0.25, green: 0.22, blue: 0.21, alpha: 1.00)
        }
        return self.longView
    }
    
    func createImages(){
        self.images = Array()
        
        let tipW:CGFloat  = (self.longView.bounds.size.width - 17) / 16;
        let tipH:CGFloat  = 5;
        let tipY:CGFloat  = 1;
        
        for i in 0..<16 {
            let image:UIImageView = UIImageView()
            image.backgroundColor = UIColor.whiteColor()
            image.frame           = CGRectMake(CGFloat(i) * (tipW + 1) + 1, tipY, tipW, tipH);
            
            self.longView.addSubview(image)
            self.images.append(image)
        }
        self.updateLongView(UIScreen.mainScreen().brightness)
    }
    
    func addObserver(){
        UIScreen.mainScreen().addObserver(self, forKeyPath: "brightness", options: .New, context: nil)
    }
    
    func updateLongView(progress:CGFloat){
        let stage:CGFloat = 1 / 15.0
        let level:Int = Int.init(progress / stage)
        for i in 0 ..< self.images.count {
            let image:UIImageView = self.images[i]
            if i <= level {
                image.hidden = false
            } else {
                image.hidden = true
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let brightness:CGFloat = CGFloat((change!["new"]?.floatValue)!)
        self.showProgressView()
        self.updateLongView(brightness)
    }
    
    func showProgressView(){
        if self.alpha == 0.0 {
            self.alpha = 1.0
            self.updateTimer()
        }
    }
    
    func addTimer(){
        if self.timer != nil {
            return
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:#selector(hideProgressView),userInfo:nil,repeats:true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer(){
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func updateTimer(){
        self.removeTimer()
        self.addTimer()
    }
    
    func hideProgressView(){
        if self.alpha == 1.0 {
            UIView.animateWithDuration(0.8, animations: {
                    self.alpha = 0.0
                }, completion: { (falg:Bool) in
            
            })
        }
    }
    
    deinit{
        UIScreen.mainScreen().removeObserver(self, forKeyPath: "brightness")
    }
    
}
