//
//  MyDownloadView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyDownloadView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    private var mCollectionView:UICollectionView!
    private var videoList:[VideoBriefItem] = [VideoBriefItem]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clearColor()
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        
        let emptyView = MyVideoEmptyView(frame: scrollView.frame)
        emptyView.backgroundColor = UIColor.redColor()
        emptyView.titleLabel.text = "网速太慢，观看太卡？不如离线下载，更清晰更流畅，随时想看就看"
        emptyView.emptyImage.image = UIImage(named: "v2_my_download_empty_bg")
        
        return emptyView
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -scrollView.frame.height/3
    }
    


}
