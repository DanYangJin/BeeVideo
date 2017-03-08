//
//  NetSpeedView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/8.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class NetSpeedView: UIView {

    fileprivate var backgroundView:UIView!
    fileprivate var loadingImg:UIImageView!
    fileprivate var loadingLbl:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView(image: UIImage(named: "v2_video_play_loading_pb_bg"))
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self.snp.width)
        }
        
        let picPreName = "video_loading"
        var picList:[UIImage] = [UIImage]()
        for i in 1...8{
            let img = UIImage(named: picPreName + "\(i)")
            picList.append(img!)
        }
        
        loadingImg = UIImageView()
        loadingImg.animationImages = picList
        loadingImg.animationDuration = 0.7
        loadingImg.startAnimating()
        self.addSubview(loadingImg)
        loadingImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.equalTo(self)
            make.width.equalTo(self.snp.height)
        }
        
        loadingLbl = UILabel()
        loadingLbl.textColor = UIColor.white
        loadingLbl.font = UIFont.systemFont(ofSize: 12)
        loadingLbl.text = "加载中..."
        self.addSubview(loadingLbl)
        loadingLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.right).dividedBy(3)
            make.centerY.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimate(){
        self.isHidden = false
        if !loadingImg.isAnimating {
            loadingImg.startAnimating()
        }
    }
    
    func stopAnimat(){
        self.isHidden = true
        if loadingImg.isAnimating {
            loadingImg.stopAnimating()
        }
    }
    
    
}
