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

class ViewController: BaseViewController ,TableTitleViewDelegate, UIScrollViewDelegate,NSXMLParserDelegate{

    private var mTableTitleView:TableTitleView!
    private var mContentScrollView:UIScrollView!
    private var remmondedPageView:RemmondedPageView!
    private var livePageView:LivePageView!
    private var videoPageView:VideoPageView!
    private var settingPageView:SettingPageView!
    private var mPagesWidth:[CGFloat] = Array()
    
    
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
        mContentScrollView.backgroundColor = UIColor.redColor()
        mContentScrollView.showsHorizontalScrollIndicator = false
        mContentScrollView.showsVerticalScrollIndicator = false
        mContentScrollView.pagingEnabled = true
        mContentScrollView.delegate = self
        self.view.addSubview(mContentScrollView)
        
        mContentScrollView.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height - 100)
            make.topMargin.equalTo(self.mTableTitleView).offset(40)
            make.leftMargin.equalTo(self.mTableTitleView).offset(-10)
        }
        
        self.remmondedPageView = RemmondedPageView()
        self.mPagesWidth.append(self.remmondedPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.remmondedPageView)
        
        self.remmondedPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.mContentScrollView).offset(0)
        }
        
        self.videoPageView = VideoPageView()
        self.mPagesWidth.append(self.videoPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.videoPageView)
        
        self.videoPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.remmondedPageView).offset(mPagesWidth[0])
        }
        
        self.livePageView = LivePageView()
        self.mPagesWidth.append(self.livePageView.getViewWidth())
        self.mContentScrollView.addSubview(self.livePageView)
        
        self.livePageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.videoPageView).offset(mPagesWidth[1])
        }
        
        self.settingPageView = SettingPageView()
        self.mPagesWidth.append(self.settingPageView.getViewWidth())
        self.mContentScrollView.addSubview(self.settingPageView)
        
        self.settingPageView.snp_makeConstraints{ (make) -> Void in
            make.height.equalTo(self.mContentScrollView)
            make.topMargin.equalTo(self.mContentScrollView).offset(0)
            make.leftMargin.equalTo(self.livePageView).offset(mPagesWidth[2])
        }
        
        mContentScrollView.contentSize = CGSize(width: calcTotalSizeByIndex(4), height: self.view.frame.height - 100)
        
        Alamofire.request(.GET, "http://www.beevideo.tv/api/hometv2.0/listBlockByVersion.action?borqsPassport=3p3kgHRqy244-VwtggWOVCAQEkAsn3SyyqGnCWqhScQNC_vyA9wYQ18Vvq7XJl8U&sdkLevel=19&version=2")
            .response { request, response, data, error in
                if error != nil {
                    print(error)
                    return
                }
                self.parseXml(data!)
        }

    }
    
    func parseXml(data:NSData){
        let parse = NSXMLParser(data: data)
        parse.delegate = self
        parse.parse()
    }
    
    
    var homeData:HomeData!
    var currentName:String!
    var blockDatas:Dictionary<String,[HomeSpace]>!
    var homeSpaceList:[HomeSpace]!
    var tableName:String!
    var homeItem:HomeItem!
    var position:Int = 0
    var space:HomeSpace!
    var channelInfo:ChannelInfo!
    var favChannels:[ChannelInfo]!
    var channelProgram:ChannelProgram!
    var livePrograms:[ChannelProgram]!
    var dailyPrograms:[ChannelProgram]!
    var formBills:Bool = false
    
    //开始解析
    func parserDidStartDocument(parser: NSXMLParser) {
        print("parserDidStartDocument")
    }
    // 监听解析节点的属性
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        self.currentName = elementName
        if currentName == "result" {
            homeData = HomeData()
        } else if currentName == "tabs" {
            blockDatas = Dictionary<String,[HomeSpace]>()
        } else if currentName == "tab" {
            homeSpaceList = Array()
        } else if currentName == "tabname" {
            //
        } else if currentName == "blocks" {
        
        } else if currentName == "block" {
            homeItem  = HomeItem()
        } else if currentName == "title" {
            //
        } else if currentName == "channels" {
            favChannels = Array()
        } else if currentName == "channel" {
            channelInfo = ChannelInfo()
        } else if currentName == "schedules" {
            livePrograms = Array()
        } else if currentName == "schedule" {
            channelProgram = ChannelProgram()
        } else if currentName == "bills" {
            dailyPrograms = Array()
            formBills = true
        } else if currentName == "bill" {
            channelProgram = ChannelProgram()
        }
    }
    
    // 监听解析节点的内容
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content:String = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if currentName == nil{
            return
        }
        if currentName == "tabname" {
            self.tableName = content
        } else if currentName == "title" {
            homeItem.name = content
        } else if currentName == "position" {
            if content.isEmpty {
                return
            }
            let cp:Int = Int.init(content)!
            if cp != position {
                space = HomeSpace()
                homeSpaceList.append(space)
                space.tableName = tableName
                space.position = cp
                position = cp
            }
        } else if currentName == "type"{
            if content.isEmpty {
                return
            }
            homeItem.type = Int.init(content)!
        } else if currentName == "img" {
            homeItem.icon = content
        } else if currentName == "channelId" {
            if channelInfo != nil {
                channelInfo.id = content
            } else {
                channelProgram.channelId = content
            }
        } else if currentName == "channeName" {
            if channelInfo != nil {
                channelInfo.name = content
            } else {
                channelProgram.channelName = content
            }
        } else if currentName == "channelPic" {
            if channelInfo != nil {
                channelInfo.channelPic = content
            } else {
                channelProgram.channelPic = content
            }
        } else if currentName == "id" {
            if formBills {
                channelProgram.channelId = content
            }
        } else if currentName == "name" {
            if formBills {
                channelProgram.channelName = content
            }
        } else if currentName == "timeStart" {
            if content.isEmpty {
                channelProgram.timeStart = content
            }
        } else if currentName == "timeEnd" {
            if content.isEmpty {
                channelProgram.timeEnd = content
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "block" {
            space.items.append(homeItem)
            homeItem = nil
        } else if elementName == "blocks" {
            space = nil
        } else if elementName == "tab" {
            blockDatas[tableName] = homeSpaceList
            homeSpaceList = nil
            tableName = nil
        } else if elementName == "channel"{
            favChannels.append(channelInfo)
            channelInfo = nil
        } else if elementName == "schedule"{
            livePrograms.append(channelProgram)
            channelProgram = nil
        } else if elementName == "bill"{
            dailyPrograms.append(channelProgram)
            channelProgram = nil
        } else if elementName == "result" {
            homeData.blockDatas = blockDatas
            homeData.favChannels = favChannels
            homeData.livePrograms = livePrograms
            homeData.dailyPrograms = dailyPrograms
        }
        self.currentName = nil
    }
    //解析结束
    func parserDidEndDocument(parser: NSXMLParser) {
        var homeSpaceList = homeData.blockDatas["home"]
        for var index = 0; index < homeSpaceList?.count; index++ {
            let items = homeSpaceList![index]
            for var i = 0; i < items.items.count; i++ {
                let homeItem = items.items[i]
                print("\(index)#####\(i)######\(homeItem.name)")
            }
        }

        for var i = 0; i < homeData.favChannels.count; i++ {
            let channelInfo = homeData.favChannels[i]
            print("喜欢频道 ： \(channelInfo.name)")
        }
        
        for var i = 0; i < homeData.livePrograms.count; i++ {
            let channelProgram = homeData.livePrograms[i]
            print("直播频道 ： \(channelProgram.channelName)")
        }
        
        for var i = 0; i < homeData.dailyPrograms.count; i++ {
            let channelProgram = homeData.dailyPrograms[i]
            print("轮播频道 ： \(channelProgram.channelName)")
        }
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
        for var i = 0; i < index; i++ {
            totalSize += mPagesWidth[i]
        }
        return totalSize
    }


}

