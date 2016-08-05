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
    private var searchImage:UIButton!
    
    private var mPagesWidth:[CGFloat] = Array()
    
    private var recommondScrollerView : UIScrollView!//首页
    private var liveScrollerView : UIScrollView!//直播
    private var videoScrollerView : UIScrollView!//点播
    private var settingScrollerView : UIScrollView!//设置
    
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
        
        searchImage = UIButton()
        searchImage.setImage(UIImage(named: "v2_launch_search"), forState: .Normal)
        searchImage.setImage(UIImage(named: "v2_launch_search_select"), forState: .Highlighted)
        searchImage.addTarget(self, action: #selector(self.toSearchViewController), forControlEvents: .TouchUpInside)
        self.view.addSubview(searchImage)
        searchImage.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(mTableTitleView)
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(40)
        }
        
        let scrollerHeight = self.view.frame.height * 0.9 - 70
        
        mContentScrollView = UIScrollView()
        setScrollCommen(mContentScrollView)
        mContentScrollView.pagingEnabled = true
        mContentScrollView.delegate = self
        mContentScrollView.delaysContentTouches = false
        //mContentScrollView.canCancelContentTouches = false
        //mContentScrollView.backgroundColor = UIColor.redColor()
        self.view.addSubview(mContentScrollView)
        
        recommondScrollerView = UIScrollView()
        recommondScrollerView.delaysContentTouches = false
        //recommondScrollerView.canCancelContentTouches = false
        setScrollCommen(recommondScrollerView)
        self.mContentScrollView.addSubview(recommondScrollerView)
        
        videoScrollerView = UIScrollView()
        videoScrollerView.delaysContentTouches = false
        setScrollCommen(videoScrollerView)
        self.mContentScrollView.addSubview(videoScrollerView)
        
        liveScrollerView = UIScrollView()
        liveScrollerView.delaysContentTouches = false
        setScrollCommen(liveScrollerView)
        self.mContentScrollView.addSubview(liveScrollerView)
        
        self.remmondedPageView = RemmondedPageView()
        self.remmondedPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_HOME])
        self.remmondedPageView.setController(self)
        self.remmondedPageView.initView()
        self.remmondedPageView.becomeFirstResponder()
        self.remmondedPageView.height = scrollerHeight
        self.mPagesWidth.append(self.remmondedPageView.getViewWidth())
        self.recommondScrollerView.addSubview(self.remmondedPageView)
        
        self.videoPageView = VideoPageView()
        self.videoPageView.height = scrollerHeight
        self.videoPageView.setData(homeData.blockDatas[Constants.TABLE_NAME_VIDEO])
        self.videoPageView.initView()
        self.videoPageView.setController(self)
        self.mPagesWidth.append(self.videoPageView.getViewWidth())
        self.videoScrollerView.addSubview(self.videoPageView)
        
        self.livePageView = LivePageView()
        self.livePageView.height = scrollerHeight
        self.livePageView.setData(homeData.blockDatas[Constants.TABLE_NAME_LIVE], homeData.favChannels, homeData.livePrograms, homeData.dailyPrograms)
        self.livePageView.initView()
        self.mPagesWidth.append(self.livePageView.getViewWidth())
        self.liveScrollerView.addSubview(self.livePageView)
        
        
        self.settingPageView = SettingPageView()
        self.settingPageView.height = scrollerHeight
        self.settingPageView.initView()
        settingPageView.viewController = self
        self.mPagesWidth.append(self.settingPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.settingPageView)
        
        self.setConstraints()
        
        mContentScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width * 4, height: self.view.frame.height - 120)
        recommondScrollerView.contentSize = CGSize(width: mPagesWidth[0],height: scrollerHeight)
        videoScrollerView.contentSize = CGSize(width: mPagesWidth[1],height: scrollerHeight)
        liveScrollerView.contentSize = CGSize(width: mPagesWidth[2],height: scrollerHeight)
        //settingScrollerView.contentSize = CGSize(width: mPagesWidth[3],height: scrollerHeight)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectButtonIndex(index: Int) {
       // NSLog("select button index : %d",index)
        let width = UIScreen.mainScreen().bounds.width
        if mContentScrollView == nil {
            return
        }
        //mContentScrollView.contentOffset = CGPoint(x: width * CGFloat(index), y: 0)
        mContentScrollView.setContentOffset(CGPoint(x: width * CGFloat(index), y: 0), animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
       // NSLog("scrollViewDidEndDecelerating........%f",scrollView.contentOffset.x)
        //TODO当达到整屏时手动设置contentOffset
        // mContentScrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        let index:Int = getScrollViewIndex(scrollView.contentOffset.x)
        mTableTitleView.setOnSelectButtonByPosition(index)
    }
    
    //获取当前滚动属于第几页
    func getScrollViewIndex(contentOffset:CGFloat) -> Int {
        let width = UIScreen.mainScreen().bounds.width
        if contentOffset < width {
            return 0
        } else if contentOffset < 2 * width {
            return 1
        } else if contentOffset < 3 * width {
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
        
        //scrollerView.delegate = self
    }
    
    func toSearchViewController(){
        let searchViewController = SearchViewController()
        self.presentViewController(searchViewController, animated: true, completion: nil)
    }
    
    func setConstraints(){
        mContentScrollView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.bottom.equalTo(self.view).multipliedBy(0.9)
            make.top.equalTo(self.mTableTitleView.snp_bottom)
            make.left.equalTo(self.view)
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
        
        self.remmondedPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.recommondScrollerView)
            make.topMargin.equalTo(self.recommondScrollerView)
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
            make.topMargin.equalTo(self.liveScrollerView)
            make.leftMargin.equalTo(self.liveScrollerView).offset(30)
            make.width.equalTo(self.livePageView.getViewWidth());
        }
        
        self.settingPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.liveScrollerView)
            make.topMargin.equalTo(self.liveScrollerView)
            make.leftMargin.equalTo(self.liveScrollerView.snp_right).offset(30)
            make.width.equalTo(liveScrollerView)
        }
    }
}

