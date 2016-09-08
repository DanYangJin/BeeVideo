//
//  VodRightView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class VodRightView: UIView,UICollectionViewDelegateFlowLayout {
    
    var backImg : UIImageView!
    var titleLbl : UILabel!
    var countLbl : UILabel!
    var strinkView : UIImageView!
    var collectionView : UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        
        strinkView = UIImageView()
        strinkView.contentMode = .ScaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        self.addSubview(strinkView)
        strinkView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(20)
            make.left.equalTo(self.snp_right)
            make.width.equalTo(20)
        }
        
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .ScaleAspectFill
        self.addSubview(backImg)
        backImg.snp_makeConstraints { (make) in
            make.left.equalTo(strinkView.snp_right)
            make.topMargin.equalTo(30)
            make.height.equalTo(20)
            make.width.equalTo(10)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backImg.snp_right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.backgroundColor = UIColor(patternImage: UIImage(named: "v2_vod_page_size_bg.9")!)
        countLbl.textColor = UIColor.whiteColor()
        countLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(countLbl)
        countLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp_right).offset(5)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.frame.height - 80 - (self.frame.width - 80)/6 * 14/5
        collectionView = UICollectionView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), collectionViewLayout: layout)
        collectionView.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "collection")
        collectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(backImg.snp_bottom).offset(20)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(self).offset(-20)
        }
    }
    
    
    
    
}
