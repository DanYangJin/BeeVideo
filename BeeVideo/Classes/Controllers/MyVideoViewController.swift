//
//  MyVideoViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/8.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class MyVideoViewController: BaseHorizontalViewController,UITableViewDataSource,UITableViewDelegate,XMLParserDelegate,VideoListViewDelegate,HistoryViewDelegate {
    
    lazy var menuData:[LeftViewTableData] = [
        LeftViewTableData(title: "观看历史", unSelectPic: "v2_my_video_history_default", selectedPic: "v2_my_video_history_selected"),
        LeftViewTableData(title: "追剧收藏", unSelectPic: "v2_my_video_like_bg_normal", selectedPic: "v2_my_video_like_bg_favorited"),
        LeftViewTableData(title: "我的下载", unSelectPic: "v2_my_video_download_bg_normal", selectedPic: "v2_my_video_download_selected")
    ]
    
    fileprivate var menuTable:UITableView!
    fileprivate var myHistoryView:MyHistoryView!
    fileprivate var myFavoriteView:MyFavoriteView!
    fileprivate var myDownloadView:MyDownloadView!
    
    fileprivate var viewList:[UIView] = [UIView]()
    fileprivate var lastPositon = 0
    
    override func viewDidLoad() {
        leftWidth = Float(self.view.frame.width * 0.2)
        super.viewDidLoad()
        
        titleLbl.text = "我的影视"
        
        menuTable = UITableView()
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.backgroundColor = UIColor.clear
        menuTable.separatorStyle = .none
        menuTable.isScrollEnabled = false
        menuTable.register(MyVideoMenuCell.self, forCellReuseIdentifier: "myVideoCell")
        menuTable.selectRow(at: IndexPath(row: 0,section: 0), animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        self.leftView.addSubview(menuTable)
        menuTable.snp.makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.equalTo(leftView.snp.bottom).multipliedBy(0.2)
            make.bottom.equalTo(leftView)
        }
        
        myHistoryView = MyHistoryView(frame: CGRect.zero,controller: self)
        contentView.addSubview(myHistoryView)
        myHistoryView.delegate = self
        myHistoryView.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp.bottom)
            make.width.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view)
        }
        
        myFavoriteView = MyFavoriteView(frame: CGRect.zero, controller: self)
        myFavoriteView.isHidden = true
        myFavoriteView.delegate = self
        contentView.addSubview(myFavoriteView)
        myFavoriteView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(myHistoryView)
            make.right.left.equalTo(myHistoryView)
        }
        
        myDownloadView = MyDownloadView()
        myDownloadView.isHidden = true
        contentView.addSubview(myDownloadView)
        myDownloadView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(myHistoryView)
            make.right.left.equalTo(myHistoryView)
        }
        
        viewList.append(myHistoryView)
        viewList.append(myFavoriteView)
        viewList.append(myDownloadView)
        
        selectHistoryData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFavoriteList), name: NSNotification.Name(rawValue: "FavoriteChangedNotify"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectHistoryData), name: NSNotification.Name(rawValue: "HistroyChangedNotify"), object: nil)
    }
    
    func selectHistoryData(){
        let data = VideoDBHelper.shareInstance.getHistoryList()
        if data.isEmpty {
            getRecommendData()
        }else{
            myHistoryView.setViewData(data)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //uitableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myVideoCell", for: indexPath) as! MyVideoMenuCell
        cell.setViewData(menuData[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if lastPositon == (indexPath as NSIndexPath).row {
            return
        }
        viewList[lastPositon].isHidden = true
        viewList[(indexPath as NSIndexPath).row].isHidden = false
        lastPositon = (indexPath as NSIndexPath).row
        switch (indexPath as NSIndexPath).row {
        case 0:
            //myHistoryView.setViewData(VideoDBHelper.shareInstance().getHistoryList())
            selectHistoryData()
        case 1:
            myFavoriteView.setVideoList(VideoDBHelper.shareInstance.getFavoriteList())
    
        default:
            break
        }
    }
    
    //xml解析
    fileprivate var currentElement = ""
    fileprivate var videoList:[VideoBriefItem] = [VideoBriefItem]()
    fileprivate var videoItem:VideoBriefItem!
    
    //列表点击事件
    func onVideoListViewItemClick(_ videoId: String) {
        let controller = VideoDetailViewController()
        var extras:[ExtraData] = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        controller.extras = extras
        self.present(controller, animated: true, completion: nil)
    }
    
    func refreshFavoriteList(){
        myFavoriteView.setVideoList(VideoDBHelper.shareInstance.getFavoriteList())
    }
    
    
    func getRecommendData(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_HISTORY_RECOMMEND)!).responseData{
            response in
            switch response.result{
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func dismissViewController() {
        NotificationCenter.default.removeObserver(self)
        super.dismissViewController()
    }
}


extension MyVideoViewController
{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video_item" {
            videoItem = VideoBriefItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "video_item"{
            videoList.append(videoItem)
            videoItem = nil
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        myHistoryView.setRecommendData(videoList)
    }
    
}
