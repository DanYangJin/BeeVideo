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

    fileprivate var mCollectionView:UICollectionView!
    fileprivate var videoList:[VideoBriefItem] = [VideoBriefItem]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clear
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.emptyDataSetDelegate = self
        mCollectionView.emptyDataSetSource = self
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let emptyView = MyVideoEmptyView(frame: scrollView.frame)
        emptyView.backgroundColor = UIColor.red
        emptyView.titleLabel.text = "网速太慢，观看太卡？不如离线下载，更清晰更流畅，随时想看就看"
        emptyView.emptyImage.image = UIImage(named: "v2_my_download_empty_bg")
        
        return emptyView
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -scrollView.frame.height/3
    }
    


}
