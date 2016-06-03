//
//  AppRecommendCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 推荐应用的cell
 */

class AppRecommendCell: UICollectionViewCell {
    
    private var backgroundImg : UIImageView!
    private var titleBkImg : UIImageView!
    var appIconImg : UIImageView!
    var titleLabl : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .Redraw
        backgroundImg.image = UIImage(named: "v2_app_item_background")!.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 20, 20, 20), resizingMode: .Stretch)
        self.contentView.addSubview(backgroundImg)
        
        titleBkImg = UIImageView()
        titleBkImg.contentMode = .Redraw
        titleBkImg.image = UIImage(named: "v2_app_item_text_background")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 40, 30, 40), resizingMode: .Stretch)
        self.contentView.addSubview(titleBkImg)
        
        appIconImg = UIImageView()
        appIconImg.contentMode = .Redraw
        appIconImg.image = UIImage(named: "v2_image_default_bg.9")
        self.contentView.addSubview(appIconImg)
        
        titleLabl = UILabel()
        titleLabl.textColor = UIColor.whiteColor()
        titleLabl.font = UIFont.systemFontOfSize(12)
        //titleLabl.text = "测试测试"
        titleLabl.textAlignment = .Center
        self.contentView.addSubview(titleLabl)
        
        backgroundImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        
        titleBkImg.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(4)
        }
        
        titleLabl.snp_makeConstraints { (make) in
            make.left.right.equalTo(titleBkImg)
            make.top.bottom.equalTo(titleBkImg)
        }
        
        appIconImg.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).multipliedBy(0.75)
            make.height.width.equalTo(contentView).dividedBy(2)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
