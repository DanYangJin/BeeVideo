//
//  MyFavoriteView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import PopupController

class MyFavoriteView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ClearDelegate {
    
    fileprivate var mCollectionView:UICollectionView!
    fileprivate var videoList:[VideoHistoryItem] = [VideoHistoryItem]()
    weak var delegate:VideoListViewDelegate!
    fileprivate var longPressIndex:IndexPath?
    fileprivate weak var appearController:UIViewController!
    
    fileprivate var popup:PopupController!

    init(frame: CGRect,controller:UIViewController) {
        super.init(frame: frame)
        
        self.appearController = controller
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clear
        mCollectionView.register(VideoItemCell.self, forCellWithReuseIdentifier: "favoriteCell")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.emptyDataSetDelegate = self
        mCollectionView.emptyDataSetSource = self
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        mCollectionView.addGestureRecognizer(longPress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:VideoItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! VideoItemCell
        cell.itemView.setDataFromDataBase(videoList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate.onVideoListViewItemClick(videoList[indexPath.row].videoId)
        }
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let emptyView = MyVideoEmptyView(frame: scrollView.frame)
        emptyView.backgroundColor = UIColor.red
        emptyView.titleLabel.text = "把喜欢的视频或剧集收藏在这里，下次观看更方便，还能自动追剧"
        emptyView.emptyImage.image = UIImage(named: "v2_my_favorite_empty_bg")
        
        return emptyView
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -scrollView.frame.height/3
    }

    func setVideoList(_ videoList: [VideoHistoryItem]){
        self.videoList = videoList
        mCollectionView.reloadData()
    }
    
    func onLongPress(_ gesture:UILongPressGestureRecognizer){
        
        if gesture.state != .began{
            return 
        }
        
        let location = gesture.location(in: mCollectionView)
        longPressIndex = mCollectionView.indexPathForItem(at: location)
        
        guard longPressIndex != nil else{
            return
        }
        
//        popup = PopupController.create()
        
    }
    
    func clearAll() {
        
    }
    
    func clearSelect() {
        
    }
    
    
}
