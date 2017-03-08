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
    
    fileprivate func initView(){
        
        strinkView = UIImageView()
        strinkView.contentMode = .scaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        self.addSubview(strinkView)
        strinkView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(20)
            make.left.equalTo(self.snp.right)
            make.width.equalTo(20)
        }
        
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .scaleAspectFill
        self.addSubview(backImg)
        backImg.snp.makeConstraints { (make) in
            make.left.equalTo(strinkView.snp.right)
            make.top.equalTo(30)
            make.height.equalTo(20)
            make.width.equalTo(10)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.textColor = UIColor.white
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(backImg.snp.right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.backgroundColor = UIColor(patternImage: UIImage(named: "v2_vod_page_size_bg.9")!)
        countLbl.textColor = UIColor.white
        countLbl.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(countLbl)
        countLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp.right).offset(5)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.frame.height - 80 - (self.frame.width - 80)/6 * 14/5
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        collectionView.register(VideoItemCell.self, forCellWithReuseIdentifier: "collection")
        collectionView.backgroundColor = UIColor.clear
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(backImg.snp.bottom).offset(20)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(strinkView.snp.right)
            make.width.equalTo(self).offset(-20)
        }
    }
    
    
    
    
}
