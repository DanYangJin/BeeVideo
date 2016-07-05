//
//  MyFavoriteView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyFavoriteView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    private var mCollectionView:UICollectionView!
    private var videoList:[VideoHistoryItem] = [VideoHistoryItem]()
    var delegate:VideoListViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clearColor()
        mCollectionView.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "favoriteCell")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.emptyDataSetDelegate = self
        mCollectionView.emptyDataSetSource = self
        self.addSubview(mCollectionView)
        mCollectionView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:VideoItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("favoriteCell", forIndexPath: indexPath) as! VideoItemCell
        cell.itemView.setDataFromDataBase(videoList[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate.onVideoListViewItemClick(videoList[indexPath.row].videoId)
        }
    }
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        
        let emptyView = MyVideoEmptyView(frame: scrollView.frame)
        emptyView.backgroundColor = UIColor.redColor()
        emptyView.titleLabel.text = "把喜欢的视频或剧集收藏在这里，下次观看更方便，还能自动追剧"
        emptyView.emptyImage.image = UIImage(named: "v2_my_favorite_empty_bg")
        
        return emptyView
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -scrollView.frame.height/3
    }

    func setVideoList(videoList: [VideoHistoryItem]){
        self.videoList = videoList
        mCollectionView.reloadData()
    }
    
    
}
