//
//  PopupChooseDramaController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/28.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import PopupController

@objc protocol ChooseDramaDelegate {
    func onDramaChooseListener(dramaIndex: Int)
}

class PopupChooseDramaController: UIViewController,PopupContentViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZXOptionBarDelegate,ZXOptionBarDataSource {

    var videoDetailInfo:VideoDetailInfo!
    weak var delegate:ChooseDramaDelegate!
    
    private var backgroundImg:UIImageView!
    private var mCollectionView:UICollectionView!
    private var mOptionBar:ZXOptionBar!
    
    private var dramas:[Item] = [Item]() //collectionview 数据源
    private var dramaCollector:[String] = [String]() //optionbar 数据源
    private var startIndex = 0
    private var endIndex = 0
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .ScaleToFill
        backgroundImg.image = UIImage(named: "v2_choose_drama_dlg_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 5,left: 3,bottom: 5,right: 3), resizingMode: .Stretch)
        self.view.addSubview(backgroundImg)
        backgroundImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.view)
            make.left.right.equalTo(self.view)
        }
        
        collectSubDrama()
        calculateDramaCollector()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.clearColor()
        mCollectionView.registerClass(KeyboardCollectionViewCell.self, forCellWithReuseIdentifier: "chooseDrama")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        self.view.addSubview(mCollectionView)
        mCollectionView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(backgroundImg).offset(5)
            make.height.equalTo(self.view).multipliedBy(0.6)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRectZero, barDelegate: self, barDataSource: self,dividerWidth: 5)
        mOptionBar.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mOptionBar)
        mOptionBar.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(mCollectionView.snp_bottom)
            make.height.equalTo(self.view).multipliedBy(0.3)
        }
    
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        return CGSize(width: screenWidth,height: screenHeight/3)
    }
    
    //  collectionView
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dramas.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        let cellWidth = (width - 65)/10
        let cellHeight = (height - 20)/2
        
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:KeyboardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("chooseDrama", forIndexPath: indexPath) as! KeyboardCollectionViewCell
        cell.titleLabel.text = dramas[indexPath.row].dramaReadablePosition
        cell.backgroundView?.hidden = false
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate.onDramaChooseListener(dramas[indexPath.row].dramaIndex)
        }
    }
    
    //optionBar
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return dramaCollector.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        
        var cell:ChooseOptionBarCell? = optionBar.dequeueReusableCellWithIdentifier("chooseDrama") as? ChooseOptionBarCell
        
        if cell == nil {
            cell = ChooseOptionBarCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: "chooseDrama")
        }
        cell?.titleLable.text = dramaCollector[index]
        
        if index == 0 && currentPage == 0 {
            cell?.selected = true
            optionBar.selectedIndex = index
        }
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return (Float(self.view.bounds.width) - 65)/5 + 5
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        currentPage = index
        collectSubDrama()
        mCollectionView.reloadData()
    }
    
    private func collectSubDrama(){
        if !dramas.isEmpty {
            dramas.removeAll()
        }
        startIndex = currentPage * VideoInfoUtils.GRID_ITEM_COUNT
        endIndex = (currentPage + 1) * VideoInfoUtils.GRID_ITEM_COUNT
        let totalSize = videoDetailInfo.dramas.count
        if endIndex > totalSize {
            endIndex = totalSize
        }
        for i in startIndex..<endIndex {
            dramas.append(Item(dramaIndex: i, dramaReadablePosition: String(VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: totalSize, index: i))))
        }
    }
    
    private func calculateDramaCollector(){
        let totalSize = videoDetailInfo.dramas.count
        let dramaCollectorCount = Int(ceilf(Float(totalSize)/Float(VideoInfoUtils.GRID_ITEM_COUNT)))
        for i in 0..<dramaCollectorCount {
            let startPosition = i * VideoInfoUtils.GRID_ITEM_COUNT
            var endPosition = (i + 1) * VideoInfoUtils.GRID_ITEM_COUNT - 1
            if endPosition > totalSize {
                endPosition = totalSize - 1
            }
            let startReadable = String(VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: totalSize, index: startPosition))
            let endReadable = String(VideoInfoUtils.getDramaReadablePosition(videoDetailInfo.dramaOrderFlag, dramaTotalSize: totalSize, index: endPosition))
            dramaCollector.append(startReadable + " - " + endReadable)
        }
    }
    
    private class Item{
        var dramaIndex = 0
        var dramaReadablePosition = ""
        
        init(dramaIndex: Int,dramaReadablePosition: String){
            self.dramaIndex = dramaIndex
            self.dramaReadablePosition = dramaReadablePosition
        }
    }
    
}
