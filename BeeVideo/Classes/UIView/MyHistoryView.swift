//
//  MyHistoryView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import PopupController

protocol HistoryViewDelegate:class {
    func getRecommendData()
}

class MyHistoryView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,ZXOptionBarDelegate,ZXOptionBarDataSource,ClearDelegate {

    private var collentionView:UICollectionView!
    private var loadingView:LoadingView!
    private var recommendLbl:UILabel!
    private var mOptionBar:ZXOptionBar!
    private weak var appearController:UIViewController?
    private var longSelectIndex : NSIndexPath?
    
    private var viewData:[VideoHistoryItem] = [VideoHistoryItem]()
    private var recommendData:[VideoBriefItem] = [VideoBriefItem]()
    private var popup:PopupController!
    
    weak var delegate:HistoryViewDelegate!
    
    init(frame: CGRect,controller: UIViewController) {
        
        self.appearController = controller
        super.init(frame: frame)
        initUI()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPress.minimumPressDuration = 1
        collentionView.addGestureRecognizer(longPress)
    }
    
    func longPress(gesture:UILongPressGestureRecognizer){
        if gesture.state != .Began{
            return
        }
        print("long press")
        let point = gesture.locationInView(collentionView)
        longSelectIndex = collentionView.indexPathForItemAtPoint(point)
        guard longSelectIndex != nil else{
            return
        }
        popup = PopupController.create(appearController!).customize([.Layout(.Bottom)])
        let viewController = PopupClearViewController()
        viewController.delegate = self
        popup.show(viewController)
    }
    
    func initUI(){
        let layout = UICollectionViewFlowLayout()
        collentionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collentionView.hidden = true
        collentionView.backgroundColor = UIColor.clearColor()
        collentionView.delaysContentTouches = false
        collentionView.dataSource = self
        collentionView.delegate = self
        collentionView.emptyDataSetSource = self
        collentionView.emptyDataSetDelegate = self
        collentionView.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "history")
        self.addSubview(collentionView)
        collentionView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        recommendLbl = UILabel()
        recommendLbl.text = "随便看看"
        //recommendLbl.hidden = true
        recommendLbl.textColor = UIColor.whiteColor()
        recommendLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(recommendLbl)
        recommendLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_bottom).offset(-UIScreen.mainScreen().bounds.height/2)
            make.left.equalTo(self)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRectZero, barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clearColor()
        mOptionBar.hidden = true
        mOptionBar.setDividerWidth(dividerWidth: 5)
        self.addSubview(mOptionBar)
        mOptionBar.snp_makeConstraints { (make) in
            make.centerY.equalTo(self).multipliedBy(1.5)
            make.left.right.equalTo(self)
            make.height.equalTo(self).dividedBy(3)
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
    
    //collectionview
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("history", forIndexPath: indexPath) as! VideoItemCell
        cell.itemView.setDataFromDataBase(viewData[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = PlayerViewController()
        controller.videoHistoryItem = viewData[indexPath.row]
        controller.flag = .History
        self.appearController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyMessage = "暂无观看记录，快去观看吧"
        let attributes:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFontOfSize(12),
                                       NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        return NSAttributedString(string: emptyMessage, attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return  -scrollView.frame.height/3
    }
    
    //optionbar
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return recommendData.count
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(optionBar.frame.height * 5/7)
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        var cell:VideoCategoryCell? = optionBar.dequeueReusableCellWithIdentifier("historyCell") as? VideoCategoryCell
        if cell == nil {
         cell = VideoCategoryCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: "historyCell")
        }
        cell!.itemView.setData(recommendData[index])
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        var extras = [ExtraData]()
        let videoId = recommendData[index].id
        extras.append(ExtraData(name: "videoId", value: videoId))
        let controller = VideoDetailViewController()
        controller.extras = extras
        appearController!.presentViewController(controller, animated: true, completion: nil)
    }
    
    func setViewData(viewData:[VideoHistoryItem]){
        self.viewData = viewData
        loadingView.stopAnimat()
        collentionView.hidden = false
        hiddenOptionBar()
        collentionView.reloadData()
    }
    
    func setRecommendData(data: [VideoBriefItem]){
        self.recommendData = data
        loadingView.stopAnimat()
        collentionView.hidden = false
        showOptionBar()
        mOptionBar.reloadData()
    }
    
    func showOptionBar(){
        recommendLbl.hidden = false
        mOptionBar.hidden = false
    }
    
    func hiddenOptionBar(){
        recommendLbl.hidden = true
        mOptionBar.hidden = true
    }
    
    func clearAll() {
        if viewData.isEmpty{
            return
        }
        for item in viewData {
            VideoDBHelper.shareInstance().deleteHistory(item)
        }
        viewData.removeAll()
        collentionView.reloadData()
        showOptionBar()
        popup.dismiss()
        if delegate != nil {
            loadingView.startAnimat()
            collentionView.hidden = true
            delegate.getRecommendData()
        }
    }
    
    func clearSelect() {
        if longSelectIndex == nil{
            return
        }
        let cell = collentionView.cellForItemAtIndexPath(longSelectIndex!) as! VideoItemCell
        let item = cell.itemView.getDataFromDatabase()
        VideoDBHelper.shareInstance().deleteHistory(item)
        viewData = VideoDBHelper.shareInstance().getHistoryList()
        collentionView.reloadData()
        popup.dismiss()
        if viewData.isEmpty && delegate != nil{
            loadingView.startAnimat()
            collentionView.hidden = true
            delegate.getRecommendData()
        }
    }
}
