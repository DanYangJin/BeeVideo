//
//  ViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: BaseViewController ,TableTitleViewDelegate, UIScrollViewDelegate{

    private var mTableTitleView:TableTitleView!
    private var mContentScrollView:UIScrollView!
    private var remmondedPageView:RemmondedPageView!
    private var livePageView:LivePageView!
    private var videoPageView:VideoPageView!
    private var settingPageView:SettingPageView!
    private var mPagesWidth:[CGFloat] = Array()
    
    internal var homeData:HomeData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableTitleView = TableTitleView()
        mTableTitleView.mDelegate = self
        mTableTitleView.initTitleData()
        self.view.addSubview(mTableTitleView)
        
        mTableTitleView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.topMargin.equalTo(30)
            make.leftMargin.equalTo(20)
        }

        mContentScrollView = UIScrollView()
        mContentScrollView.showsHorizontalScrollIndicator = false
        mContentScrollView.showsVerticalScrollIndicator = false
        mContentScrollView.pagingEnabled = true
        mContentScrollView.delegate = self
        mContentScrollView.backgroundColor = UIColor.redColor()
        self.view.addSubview(mContentScrollView)
        
        mContentScrollView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height - 110)
            make.topMargin.equalTo(self.mTableTitleView).offset(50)
        }
        
        self.remmondedPageView = RemmondedPageView()
        self.remmondedPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_HOME])
        self.remmondedPageView.setController(self)
        self.remmondedPageView.initView()
        self.remmondedPageView.backgroundColor = UIColor.blueColor()
        self.mPagesWidth.append(self.remmondedPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.remmondedPageView)
        
        
        self.remmondedPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.mContentScrollView).offset(30)
            make.width.equalTo(self.remmondedPageView.getViewWidth());
        }
        
        self.videoPageView = VideoPageView()
        self.videoPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_VIDEO])
        self.videoPageView.initView()
        self.mPagesWidth.append(self.videoPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.videoPageView)
        
        self.videoPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.remmondedPageView).offset(mPagesWidth[0] + 30)
            make.width.equalTo(self.videoPageView.getViewWidth());
        }
        
        self.livePageView = LivePageView()
        self.livePageView.setData(homeData.blockDatas[Constants.TABLE_NAME_LIVE], homeData.favChannels, homeData.livePrograms, homeData.dailyPrograms)
        self.livePageView.initView()
        self.mPagesWidth.append(self.livePageView.getViewWidth())
        self.mContentScrollView.addSubview(self.livePageView)
        
        self.livePageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.videoPageView).offset(mPagesWidth[1] + 30)
            make.width.equalTo(self.livePageView.getViewWidth());
        }
        
        self.settingPageView = SettingPageView()
        self.settingPageView.initView()
        self.mPagesWidth.append(self.settingPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.settingPageView)
        
        self.settingPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.livePageView).offset(mPagesWidth[2] + 30)
        }
        
        mContentScrollView.contentSize = CGSize(width: calcTotalSizeByIndex(4), height: self.view.frame.height - 110)
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func selectButtonIndex(index: Int) {
        NSLog("select button index : %d",index)
        if mContentScrollView == nil {
            return
        }
        mContentScrollView.contentOffset = CGPoint(x: calcTotalSizeByIndex(index), y: 0)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        NSLog("scrollViewDidEndDecelerating........%f",scrollView.contentOffset.x)
        let index:Int = getScrollViewIndex(scrollView.contentOffset.x)
        mTableTitleView.setOnSelectButtonByPosition(index)
        //TODO当达到整屏时手动设置contentOffset
        mContentScrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        
    }
    
    //获取当前滚动属于第几页
    func getScrollViewIndex(contentOffset:CGFloat) -> Int {
        if contentOffset < calcTotalSizeByIndex(1) {
            return 0
        } else if contentOffset < calcTotalSizeByIndex(2) {
            return 1
        } else if contentOffset < calcTotalSizeByIndex(3) {
            return 2
        } else {
            return 3
        }
    }
    
    //获取当前滚动的偏移量
    func calcTotalSizeByIndex(index: Int) -> CGFloat{
        var totalSize:CGFloat = 0
        for i in 0 ..< index {
            totalSize += mPagesWidth[i]
        }
        return totalSize
    }

}

