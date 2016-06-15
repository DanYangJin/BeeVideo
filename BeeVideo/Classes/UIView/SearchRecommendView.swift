//
//  SearchRecommendView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

protocol SearchRecommendViewItemClickDelegate {
    func onSearchRecommendViewItemClick(title: String)
}

/**
    搜索推荐列表
 */

class SearchRecommendView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private var mCollectionView:UICollectionView!
    private var dataList:[String] = [String]()
    private var loadingView:LoadingView!
    var itemClickDelegate:SearchRecommendViewItemClickDelegate!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.registerClass(SearchRecomCollectionViewCell.self, forCellWithReuseIdentifier: "recomCell")
        mCollectionView.backgroundColor = UIColor.clearColor()
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        self.addSubview(mCollectionView)
        mCollectionView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.center.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViewData(data: [String]){
        self.dataList = data
        loadingView.stopAnimat()
        mCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recomCell", forIndexPath: indexPath) as! SearchRecomCollectionViewCell
        cell.titleLable.text = dataList[indexPath.row]
        
        let index = indexPath.row
        if index == 0 {
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_first)
        }else if index == 2{
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_second)
        }else if index == 4{
            cell.titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_third)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width * 0.48
        
        return CGSize(width: width, height: 25)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.itemClickDelegate != nil {
            itemClickDelegate.onSearchRecommendViewItemClick(dataList[indexPath.row])
        }
    }
    
    
    
}
