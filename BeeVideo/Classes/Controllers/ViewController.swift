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
    
    private var recommondScrollerView : UIScrollView!
    private var liveScrollerView : UIScrollView!
    private var videoScrollerView : UIScrollView!
    private var settingScrollerView : UIScrollView!
    
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
        setScrollCommen(mContentScrollView)
        mContentScrollView.pagingEnabled = true
        mContentScrollView.delegate = self
        //mContentScrollView.backgroundColor = UIColor.redColor()
        self.view.addSubview(mContentScrollView)
        
        
        
        recommondScrollerView = UIScrollView()
        setScrollCommen(recommondScrollerView)
        self.mContentScrollView.addSubview(recommondScrollerView)
        
        liveScrollerView = UIScrollView()
        setScrollCommen(liveScrollerView)
        self.mContentScrollView.addSubview(liveScrollerView)
        
        videoScrollerView = UIScrollView()
        setScrollCommen(videoScrollerView)
        self.mContentScrollView.addSubview(videoScrollerView)
        
        settingScrollerView = UIScrollView()
        setScrollCommen(settingScrollerView)
        self.mContentScrollView.addSubview(settingScrollerView)
        
        self.remmondedPageView = RemmondedPageView()
        self.remmondedPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_HOME])
        self.remmondedPageView.setController(self)
        self.remmondedPageView.initView()
        //remmondedPageView.backgroundColor = UIColor.blueColor()
        self.mPagesWidth.append(self.remmondedPageView.getViewWidth())
        self.recommondScrollerView.addSubview(self.remmondedPageView)
        
        self.videoPageView = VideoPageView()
        self.videoPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_VIDEO])
        self.videoPageView.initView()
        self.mPagesWidth.append(self.videoPageView.getViewWidth())
        self.videoScrollerView.addSubview(self.videoPageView)
        
        
        
        self.livePageView = LivePageView()
        self.livePageView.setData(homeData.blockDatas[Constants.TABLE_NAME_LIVE], homeData.favChannels, homeData.livePrograms, homeData.dailyPrograms)
        self.livePageView.initView()
        self.mPagesWidth.append(self.livePageView.getViewWidth())
        self.liveScrollerView.addSubview(self.livePageView)
        
        
        
        self.settingPageView = SettingPageView()
        self.settingPageView.initView()
        self.mPagesWidth.append(self.settingPageView.getViewWidth())
        self.settingScrollerView.addSubview(self.settingPageView)
        
        
        setConstraints()
        
        mContentScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width * 4, height: self.view.frame.height - 110)
        
        recommondScrollerView.contentSize = CGSize(width: mPagesWidth[0],height: self.view.frame.height - 110)
        videoScrollerView.contentSize = CGSize(width: mPagesWidth[1],height: self.view.frame.height - 110)
        liveScrollerView.contentSize = CGSize(width: mPagesWidth[2],height: self.view.frame.height - 110)
        settingScrollerView.contentSize = CGSize(width: mPagesWidth[3],height: self.view.frame.height - 110)
        
        
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
        //        NSLog("scrollViewDidEndDecelerating........%f",scrollView.contentOffset.x)
        //        let index:Int = getScrollViewIndex(scrollView.contentOffset.x)
        //        mTableTitleView.setOnSelectButtonByPosition(index)
        //        //TODO当达到整屏时手动设置contentOffset
        //        mContentScrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        
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
    
    func setScrollCommen(scrollerView:UIScrollView){
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.delegate = self
    }
    
    func setConstraints(){
        mContentScrollView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height - 60)
            make.topMargin.equalTo(self.mTableTitleView).offset(50)
        }
        
        recommondScrollerView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(mContentScrollView)
        }
        
        videoScrollerView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(recommondScrollerView.snp_trailing)
        }
        
        liveScrollerView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(videoScrollerView.snp_trailing)
        }
        
        settingScrollerView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(liveScrollerView.snp_trailing)
        }
        
        self.remmondedPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.recommondScrollerView)
            make.topMargin.equalTo(self.recommondScrollerView).offset(0)
            make.leftMargin.equalTo(self.recommondScrollerView).offset(30)
            make.width.equalTo(self.remmondedPageView.getViewWidth())
        }
        
        self.videoPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.videoScrollerView)
            make.topMargin.equalTo(self.videoScrollerView).offset(0)
            make.leftMargin.equalTo(self.videoScrollerView).offset(30)
            make.width.equalTo(self.videoPageView.getViewWidth());
        }
        
        self.livePageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.liveScrollerView)
            make.topMargin.equalTo(self.liveScrollerView).offset(0)
            make.leftMargin.equalTo(self.liveScrollerView).offset(30)
            make.width.equalTo(self.livePageView.getViewWidth());
        }
        
        
        self.settingPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.settingScrollerView)
            make.topMargin.equalTo(self.settingScrollerView).offset(0)
            make.leftMargin.equalTo(self.settingScrollerView).offset(30)
        }
        
        
    }

}

