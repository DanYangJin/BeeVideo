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

    fileprivate var collentionView:UICollectionView!
    fileprivate var loadingView:LoadingView!
    fileprivate var recommendLbl:UILabel!
    fileprivate var mOptionBar:ZXOptionBar!
    fileprivate weak var appearController:UIViewController?
    fileprivate var longSelectIndex : IndexPath?
    
    fileprivate var viewData:[VideoHistoryItem] = [VideoHistoryItem]()
    fileprivate var recommendData:[VideoBriefItem] = [VideoBriefItem]()
    fileprivate var popup:PopupController!
    
    weak var delegate:HistoryViewDelegate!
    
    init(frame: CGRect,controller: UIViewController) {
        
        self.appearController = controller
        super.init(frame: frame)
        initUI()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPress.minimumPressDuration = 0.5
        collentionView.addGestureRecognizer(longPress)
    }
    
    func longPress(_ gesture:UILongPressGestureRecognizer){
        if gesture.state != .began{
            return
        }
        print("long press")
        let point = gesture.location(in: collentionView)
        longSelectIndex = collentionView.indexPathForItem(at: point)
        guard longSelectIndex != nil else{
            return
        }
        popup = PopupController.create(appearController!).customize([.layout(.bottom)])
        let viewController = PopupClearViewController()
        viewController.delegate = self
        let _ = popup.show(viewController)
    }
    
    func initUI(){
        let layout = UICollectionViewFlowLayout()
        collentionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collentionView.isHidden = true
        collentionView.backgroundColor = UIColor.clear
        collentionView.delaysContentTouches = false
        collentionView.dataSource = self
        collentionView.delegate = self
        collentionView.emptyDataSetSource = self
        collentionView.emptyDataSetDelegate = self
        collentionView.register(VideoItemCell.self, forCellWithReuseIdentifier: "history")
        self.addSubview(collentionView)
        collentionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        recommendLbl = UILabel()
        recommendLbl.text = "随便看看"
        //recommendLbl.hidden = true
        recommendLbl.textColor = UIColor.white
        recommendLbl.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(recommendLbl)
        recommendLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.bottom).offset(-UIScreen.main.bounds.height/2)
            make.left.equalTo(self)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRect.zero, barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clear
        mOptionBar.isHidden = true
        mOptionBar.setDividerWidth(dividerWidth: 5)
        self.addSubview(mOptionBar)
        mOptionBar.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).multipliedBy(1.5)
            make.left.right.equalTo(self)
            make.height.equalTo(self).dividedBy(3)
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
    
    //collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history", for: indexPath) as! VideoItemCell
        cell.itemView.setDataFromDataBase(viewData[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let superWidth = collectionView.frame.width
        let width = (superWidth - 50) / 6
        return CGSize(width: width, height: width * 7/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PlayerViewController()
        controller.videoHistoryItem = viewData[(indexPath as NSIndexPath).row]
        controller.flag = .history
        self.appearController?.present(controller, animated: true, completion: nil)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyMessage = "暂无观看记录，快去观看吧"
        let attributes:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 12),
                                       NSForegroundColorAttributeName: UIColor.white
        ]
        
        return NSAttributedString(string: emptyMessage, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return  -scrollView.frame.height/3
    }
    
    //optionbar
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        return recommendData.count
    }
    
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(optionBar.frame.height * 5/7)
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        var cell:VideoCategoryCell? = optionBar.dequeueReusableCellWithIdentifier("historyCell") as? VideoCategoryCell
        if cell == nil {
         cell = VideoCategoryCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: "historyCell")
        }
        cell!.itemView.setData(recommendData[index])
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        var extras = [ExtraData]()
        let videoId = recommendData[index].id
        extras.append(ExtraData(name: "videoId", value: videoId))
        let controller = VideoDetailViewController()
        controller.extras = extras
        appearController!.present(controller, animated: true, completion: nil)
    }
    
    func setViewData(_ viewData:[VideoHistoryItem]){
        self.viewData = viewData
        loadingView.stopAnimat()
        collentionView.isHidden = false
        hiddenOptionBar()
        collentionView.reloadData()
    }
    
    func setRecommendData(_ data: [VideoBriefItem]){
        self.recommendData = data
        loadingView.stopAnimat()
        collentionView.isHidden = false
        showOptionBar()
        mOptionBar.reloadData()
    }
    
    func showOptionBar(){
        recommendLbl.isHidden = false
        mOptionBar.isHidden = false
    }
    
    func hiddenOptionBar(){
        recommendLbl.isHidden = true
        mOptionBar.isHidden = true
    }
    
    func clearAll() {
        if viewData.isEmpty{
            return
        }
        for item in viewData {
            VideoDBHelper.shareInstance.deleteHistory(item)
        }
        viewData.removeAll()
        collentionView.reloadData()
        showOptionBar()
        popup.dismiss()
        if delegate != nil {
            loadingView.startAnimat()
            collentionView.isHidden = true
            delegate.getRecommendData()
        }
    }
    
    func clearSelect() {
        if longSelectIndex == nil{
            return
        }
        let cell = collentionView.cellForItem(at: longSelectIndex!) as! VideoItemCell
        let item = cell.itemView.getDataFromDatabase()
        VideoDBHelper.shareInstance.deleteHistory(item)
        viewData = VideoDBHelper.shareInstance.getHistoryList()
        collentionView.reloadData()
        popup.dismiss()
        if viewData.isEmpty && delegate != nil{
            loadingView.startAnimat()
            collentionView.isHidden = true
            delegate.getRecommendData()
        }
    }
}
