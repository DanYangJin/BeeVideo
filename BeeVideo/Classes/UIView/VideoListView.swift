//
//  VideoListView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/13.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import ESPullToRefresh

protocol VideoListViewDelegate{
    func onVideoListViewItemClick(videoId: String)
    func onLoadMoreListener()
}


class VideoListView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var collectionView:UICollectionView!
    var loadingView:LoadingView!
    
    var delegate:VideoListViewDelegate!
    
    private var viewData:[VideoBriefItem] = [VideoBriefItem]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "searchCell")
        self.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(40)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! VideoItemCell
        cell.itemView.setData(viewData[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.delegate != nil {
            delegate.onVideoListViewItemClick(viewData[indexPath.row].id)
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cellNum = indexPath.row
        if cellNum == viewData.count - 1 {
            if self.delegate != nil {
                delegate.onLoadMoreListener()
            }
        }
    }
    
    func setViewData(viewData: [VideoBriefItem]){
        self.viewData = viewData
        collectionView.reloadData()
        loadingView.stopAnimat()
    }
    
    func removeViewData(){
        self.viewData.removeAll()
        collectionView.reloadData()
    }
    
}
