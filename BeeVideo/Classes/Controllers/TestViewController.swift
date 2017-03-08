//
//  ViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import PopupController

class TestViewController: BaseViewController ,TableTitleViewDelegate, UIScrollViewDelegate{
    
    
    fileprivate var mTableTitleView:TableTitleView!
    fileprivate var mContentScrollView:UIScrollView!
    fileprivate var remmondedPageView:RemmondedPageView!
    fileprivate var livePageView:LivePageView!
    fileprivate var videoPageView:VideoPageView!
    fileprivate var settingPageView:SettingPageView!
    fileprivate var searchImage:UIButton!
    
    fileprivate var mPagesWidth:[CGFloat] = Array()
    
    fileprivate var recommondScrollerView : UIScrollView!//首页
    fileprivate var liveScrollerView : UIScrollView!//直播
    fileprivate var videoScrollerView : UIScrollView!//点播
    fileprivate var settingScrollerView : UIScrollView!//设置
    
    internal var homeData:HomeData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        mTableTitleView = TableTitleView()
        mTableTitleView.mDelegate = self
        //mTableTitleView.initTitleData()
        self.view.addSubview(mTableTitleView)
        
        mTableTitleView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view).dividedBy(2)
            make.height.equalTo(40)
            make.top.equalTo(30)
            make.leftMargin.equalTo(20)
        }
        
        searchImage = UIButton()
        searchImage.setImage(UIImage(named: "v2_launch_search"), for: UIControlState())
        searchImage.setImage(UIImage(named: "v2_launch_search_select"), for: .highlighted)
        searchImage.addTarget(self, action: #selector(self.toSearchViewController), for: .touchUpInside)
        self.view.addSubview(searchImage)
        searchImage.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(mTableTitleView)
            make.right.equalTo(self.view).offset(-30)
            make.width.equalTo(40)
        }
        
        let scrollerHeight = self.view.frame.height * 0.9 - 70
        
        mContentScrollView = UIScrollView()
        setScrollCommen(mContentScrollView)
        mContentScrollView.isPagingEnabled = true
        mContentScrollView.delegate = self
        mContentScrollView.delaysContentTouches = false
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
        self.remmondedPageView.height = scrollerHeight
        self.remmondedPageView.initView()
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
        
        mContentScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 4, height: self.view.frame.height - 120)
        recommondScrollerView.contentSize = CGSize(width: mPagesWidth[0],height: scrollerHeight)
        videoScrollerView.contentSize = CGSize(width: mPagesWidth[1],height: scrollerHeight)
        liveScrollerView.contentSize = CGSize(width: mPagesWidth[2],height: scrollerHeight)
    }
    
    func selectButtonIndex(_ index: Int) {
        let width = UIScreen.main.bounds.width
        if mContentScrollView == nil {
            return
        }
        mContentScrollView.setContentOffset(CGPoint(x: width * CGFloat(index), y: 0), animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index:Int = getScrollViewIndex(scrollView.contentOffset.x)
        mTableTitleView.setOnSelectButtonByPosition(index)
    }
    
    //获取当前滚动属于第几页
    func getScrollViewIndex(_ contentOffset:CGFloat) -> Int {
        let width = UIScreen.main.bounds.width
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
    func calcTotalSizeByIndex(_ index: Int) -> CGFloat{
        var totalSize:CGFloat = 0
        for i in 0 ..< index {
            totalSize += mPagesWidth[i]
        }
        return totalSize
    }
    
    func setScrollCommen(_ scrollerView:UIScrollView){
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        
        //scrollerView.delegate = self
    }
    
    func toSearchViewController(){
                let searchViewController = SearchViewController()
                self.present(searchViewController, animated: true, completion: nil)
        //self.dismissViewController()
    }
    
    func setConstraints(){
        mContentScrollView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.bottom.equalTo(self.view).multipliedBy(0.9)
            make.top.equalTo(self.mTableTitleView.snp.bottom)
            make.left.equalTo(self.view)
        }
        
        recommondScrollerView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(mContentScrollView)
        }
        
        videoScrollerView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(recommondScrollerView.snp.trailing)
        }
        
        liveScrollerView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(mContentScrollView)
            make.top.equalTo(mContentScrollView)
            make.leading.equalTo(videoScrollerView.snp.trailing)
        }
        
        self.remmondedPageView.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(self.recommondScrollerView)
            make.top.equalTo(self.recommondScrollerView)
            make.leftMargin.equalTo(self.recommondScrollerView).offset(30)
            make.width.equalTo(self.remmondedPageView.getViewWidth())
        }
        
        self.videoPageView.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(self.videoScrollerView)
            make.top.equalTo(self.videoScrollerView).offset(0)
            make.leftMargin.equalTo(self.videoScrollerView).offset(30)
            make.width.equalTo(self.videoPageView.getViewWidth());
        }
        
        self.livePageView.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(self.liveScrollerView)
            make.top.equalTo(self.liveScrollerView)
            make.leftMargin.equalTo(self.liveScrollerView).offset(30)
            make.width.equalTo(self.livePageView.getViewWidth());
        }
        
        self.settingPageView.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(self.liveScrollerView)
            make.top.equalTo(self.liveScrollerView)
            make.leftMargin.equalTo(self.liveScrollerView.snp.right).offset(30)
            make.width.equalTo(liveScrollerView)
        }
    }
    
    deinit{
        print("----->fagewgewdeinit")
    }
    
}
    


