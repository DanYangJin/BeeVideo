//
//  LoadingView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/7.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 加载等待视图
 */

class LoadingView: UIView {

    private var animaImg:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        animaImg = UIImageView()
        animaImg.contentMode = .ScaleAspectFit
        self.addSubview(animaImg)
        animaImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        let picPreName = "progress"
        var picList:[UIImage] = [UIImage]()
        for i in 1...10{
            let img = UIImage(named: picPreName + "\(i)")
            picList.append(img!)
        }
        animaImg.animationImages = picList
        animaImg.animationRepeatCount = 0
        animaImg.animationDuration = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimat(){
        if self.hidden {
            self.hidden = false
        }
        animaImg.startAnimating()
    }
    
    func stopAnimat(){
        if animaImg.isAnimating(){
            self.hidden = true
            animaImg.stopAnimating()
        }
    }
    
}
