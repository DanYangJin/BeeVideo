//
//  SearchRecommendView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

@objc protocol SearchRecommendViewItemClickDelegate {
    func onSearchRecommendViewItemClick(_ title: String)
}

/**
    搜索推荐列表
 */

class SearchRecommendView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    fileprivate var mCollectionView:UICollectionView!
    fileprivate var dataList:[String] = [String]()
    var loadingView:LoadingView!
    weak var itemClickDelegate:SearchRecommendViewItemClickDelegate!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mCollectionView.register(SearchRecomCollectionViewCell.self, forCellWithReuseIdentifier: "recomCell")
        mCollectionView.backgroundColor = UIColor.clear
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.center.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViewData(_ data: [String]){
        self.dataList = data
        loadingView.stopAnimat()
        mCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! SearchRecomCollectionViewCell
        cell.titleLable.text = dataList[(indexPath as NSIndexPath).row]
        
        let index = (indexPath as NSIndexPath).row
        if index == 0 {
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_first)
        }else if index == 2{
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_second)
        }else if index == 4{
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_third)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width * 0.48
        
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.itemClickDelegate != nil {
            itemClickDelegate.onSearchRecommendViewItemClick(dataList[(indexPath as NSIndexPath).row])
        }
    }
    
    
    
}
