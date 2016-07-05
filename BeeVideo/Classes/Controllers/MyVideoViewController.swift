//
//  MyVideoViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/8.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class MyVideoViewController: BaseHorizontalViewController,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,VideoListViewDelegate {
    
    lazy var menuData:[LeftViewTableData] = [
        LeftViewTableData(title: "观看历史", unSelectPic: "v2_my_video_history_default", selectedPic: "v2_my_video_history_selected"),
        LeftViewTableData(title: "追剧收藏", unSelectPic: "v2_my_video_like_bg_normal", selectedPic: "v2_my_video_like_bg_favorited"),
        LeftViewTableData(title: "我的下载", unSelectPic: "v2_my_video_download_bg_normal", selectedPic: "v2_my_video_download_selected")
    ]
    
    private var menuTable:UITableView!
    private var myHistoryView:MyHistoryView!
    private var myFavoriteView:MyFavoriteView!
    private var myDownloadView:MyDownloadView!
    
    private var viewList:[UIView] = [UIView]()
    private var lastPositon = 0
    
    override func viewDidLoad() {
        leftWidth = Float(self.view.frame.width * 0.2)
        super.viewDidLoad()
        
        titleLbl.text = "我的影视"
        
        menuTable = UITableView()
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.backgroundColor = UIColor.clearColor()
        menuTable.separatorStyle = .None
        menuTable.scrollEnabled = false
        menuTable.registerClass(MyVideoMenuCell.self, forCellReuseIdentifier: "myVideoCell")
        menuTable.selectRowAtIndexPath(NSIndexPath(forRow: 0,inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        self.leftView.addSubview(menuTable)
        menuTable.snp_makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.equalTo(leftView.snp_bottom).multipliedBy(0.2)
            make.bottom.equalTo(leftView)
        }
        
        myHistoryView = MyHistoryView(frame: CGRectZero,controller: self)
        contentView.addSubview(myHistoryView)
        myHistoryView.snp_makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp_bottom)
            make.width.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view)
        }
        myHistoryView.setViewData([VideoBriefItem]())
        
        myFavoriteView = MyFavoriteView()
        myFavoriteView.hidden = true
        myFavoriteView.delegate = self
        contentView.addSubview(myFavoriteView)
        myFavoriteView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(myHistoryView)
            make.right.left.equalTo(myHistoryView)
        }
        
        myDownloadView = MyDownloadView()
        myDownloadView.hidden = true
        contentView.addSubview(myDownloadView)
        myDownloadView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(myHistoryView)
            make.right.left.equalTo(myHistoryView)
        }
        
        viewList.append(myHistoryView)
        viewList.append(myFavoriteView)
        viewList.append(myDownloadView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshFavoriteList), name: "FavoriteChangedNotify", object: nil)
        
        getRecommendData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //uitableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myVideoCell", forIndexPath: indexPath) as! MyVideoMenuCell
        cell.setViewData(menuData[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if lastPositon == indexPath.row {
            return
        }
        viewList[lastPositon].hidden = true
        viewList[indexPath.row].hidden = false
        lastPositon = indexPath.row
        switch indexPath.row {
        case 1:
            myFavoriteView.setVideoList(VideoDBHelper.shareInstance().getFavoriteList())
            break
            
        default:
            break
        }
    }
    
    //xml解析
    private var currentElement = ""
    private var videoList:[VideoBriefItem] = [VideoBriefItem]()
    private var videoItem:VideoBriefItem!
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video_item" {
            videoItem = VideoBriefItem()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty{
            return
        }
        
        if currentElement == "id" {
            videoItem.id = content
        }else if currentElement == "name"{
            videoItem.name = content
        }else if currentElement == "duration"{
            videoItem.duration = content
        }else if currentElement == "smallImg"{
            videoItem.posterImg = content
        }else if currentElement == "most"{
            videoItem.resolutionType = Int(content)
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "video_item"{
            videoList.append(videoItem)
            videoItem = nil
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        myHistoryView.setRecommendData(videoList)
    }
    
    //列表点击事件
    func onVideoListViewItemClick(videoId: String) {
        let controller = VideoDetailViewController()
        var extras:[ExtraData] = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        controller.extras = extras
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshFavoriteList(){
        myFavoriteView.setVideoList(VideoDBHelper.shareInstance().getFavoriteList())
    }
    
    
    func getRecommendData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_HISTORY_RECOMMEND)!, parameters: nil).responseData{
            response in
            switch response.result{
            case .Success(let data):
                let parser = NSXMLParser(data: data)
                parser.delegate = self
                parser.parse()
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func dismissViewController() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.dismissViewController()
    }
}
