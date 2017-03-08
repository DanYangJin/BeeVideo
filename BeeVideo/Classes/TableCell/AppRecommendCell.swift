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
    
    fileprivate var backgroundImg : UIImageView!
    fileprivate var titleBkImg : UIImageView!
    var appIconImg : UIImageView!
    var titleLabl : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .redraw
        backgroundImg.image = UIImage(named: "v2_app_item_background")!.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 40, 20, 40), resizingMode: .stretch)
        self.contentView.addSubview(backgroundImg)
        
        titleBkImg = UIImageView()
        titleBkImg.contentMode = .redraw
        titleBkImg.image = UIImage(named: "v2_app_item_text_background")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 40, 30, 40), resizingMode: .stretch)
        self.contentView.addSubview(titleBkImg)
        
        appIconImg = UIImageView()
        appIconImg.contentMode = .redraw
        appIconImg.image = UIImage(named: "v2_image_default_bg.9")
        self.contentView.addSubview(appIconImg)
        
        titleLabl = UILabel()
        titleLabl.textColor = UIColor.white
        titleLabl.font = UIFont.systemFont(ofSize: 12)
        titleLabl.textAlignment = .center
        self.contentView.addSubview(titleLabl)
        
        backgroundImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        
        titleBkImg.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(4)
        }
        
        titleLabl.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleBkImg)
            make.top.bottom.equalTo(titleBkImg)
        }
        
        appIconImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).multipliedBy(0.75)
            make.height.width.equalTo(contentView).dividedBy(2)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
