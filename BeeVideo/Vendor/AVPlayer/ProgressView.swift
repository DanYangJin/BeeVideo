//
//  ProgressView.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    fileprivate var toolBar:UIToolbar!
    fileprivate var properyImage:UIImageView!
    fileprivate var properyName:UILabel!
    fileprivate var longView:UIView!
    
    //临时变量
    fileprivate var screenWidth:CGFloat!
    fileprivate var screenHeight:CGFloat!
    fileprivate var images:[UIImageView]!
    fileprivate var timer:Timer!
    
    
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
        self.screenWidth     = UIScreen.main.bounds.size.width
        self.screenHeight    = UIScreen.main.bounds.size.height
        //自定义View
        self.frame                  = CGRect(x: screenWidth * 0.36, y: screenHeight * 0.26, width: 155, height: 155)
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
            self.toolBar.frame          = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.toolBar.alpha          = 0.7
        }
        return self.toolBar
    }
    
    //初始化类型（声音或者亮度）
    func initProperyImage() -> UIImageView{
        if self.properyImage == nil {
            self.properyImage       = UIImageView()
            self.properyImage.frame = CGRect(x: 35, y: 40, width: 79, height: 76)
            self.properyImage.image = UIImage(named: "playgesture_BrightnessSun6")
        }
        return self.properyImage
    }
    
    func initProperyName() -> UILabel{
        if self.properyName == nil {
            self.properyName                = UILabel()
            self.properyName.frame          = CGRect(x: 0, y: 5, width: self.frame.width, height: 30)
            self.properyName.font           = UIFont.boldSystemFont(ofSize: 16)
            self.properyName.textColor      = UIColor.white
            self.properyName.textAlignment  = NSTextAlignment.center
            self.properyName.text           = "亮度"
        }
        return self.properyName
    }

    func initLongView() ->UIView {
        if self.longView == nil {
            self.longView                   = UIView()
            self.longView.frame             = CGRect(x: 13, y: 132, width: self.bounds.size.width - 26, height: 7)
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
            image.backgroundColor = UIColor.white
            image.frame           = CGRect(x: CGFloat(i) * (tipW + 1) + 1, y: tipY, width: tipW, height: tipH);
            
            self.longView.addSubview(image)
            self.images.append(image)
        }
        self.updateLongView(UIScreen.main.brightness)
    }
    
    func addObserver(){
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: .new, context: nil)
    }
    
    func updateLongView(_ progress:CGFloat){
        let stage:CGFloat = 1 / 15.0
        let level:Int = Int.init(progress / stage)
        for i in 0 ..< self.images.count {
            let image:UIImageView = self.images[i]
            if i <= level {
                image.isHidden = false
            } else {
                image.isHidden = true
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       // let brightness:CGFloat = CGFloat((change!["new"]?.floatValue)!)
        let brightness: CGFloat = 0.9
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
        self.timer = Timer.scheduledTimer(timeInterval: 1,target:self,selector:#selector(hideProgressView),userInfo:nil,repeats:true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
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
            UIView.animate(withDuration: 0.8, animations: {
                    self.alpha = 0.0
                }, completion: { (falg:Bool) in
            
            })
        }
    }
    
    deinit{
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
    }
    
}
