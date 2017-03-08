//
//  VideoListView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/13.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

@objc
protocol VideoListViewDelegate{
    func onVideoListViewItemClick(_ videoId: String)
    @objc optional func onLoadMoreListener()
}


class VideoListView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    var collectionView:UICollectionView!
    var loadingView:LoadingView!
    
    weak var delegate:VideoListViewDelegate!
    
    fileprivate var viewData:[VideoBriefItem] = [VideoBriefItem]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.isHidden = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(VideoItemCell.self, forCellWithReuseIdentifier: "searchCell")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(40)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? VideoItemCell
        if cell == nil {
            cell = VideoItemCell()
        }
        cell!.itemView.setData(viewData[(indexPath as NSIndexPath).row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            delegate.onVideoListViewItemClick(viewData[(indexPath as NSIndexPath).row].id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellNum = (indexPath as NSIndexPath).row
        if cellNum == viewData.count - 1 {
            if self.delegate != nil {
                delegate.onLoadMoreListener!()
            }
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyMessage = "没有找到相关内容"
        let attributes:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 12),
                                             NSForegroundColorAttributeName: UIColor.white
        ]
        return NSAttributedString(string: emptyMessage, attributes: attributes)
    }
    
    func setViewData(_ viewData: [VideoBriefItem]){
        self.viewData = viewData
        collectionView.reloadData()
        loadingView.stopAnimat()
    }
    
    func removeViewData(){
        self.viewData.removeAll()
        collectionView.reloadData()
    }
    
}
