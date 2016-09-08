//
//  SearchViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class SearchViewController: BaseHorizontalViewController,IKeyboardDelegate,SearchRecommendViewItemClickDelegate,VideoListViewDelegate{
    
    private enum NetRequestId{
        case RECOMMEND_SEARCH_REQUEST
        case SEARCH_VIDEO_REQUEST
    }
    private var requestId:NetRequestId!
    
    private var leftContentView:SearchLeftView!
    private var searchRecomView:SearchRecommendView!
    private var videoListView:VideoListView!
    private var byVideoNameBtn:KeyBoardViewButton!
    private var byActorBtn:KeyBoardViewButton!
    
    private var searchPageData:SearchVideoPageData = SearchVideoPageData()
    private var videoItem:VideoBriefItem!
    private var videoList:[VideoBriefItem]!
    
    //XML解析
    private var currentElement:String!
    
    var keyString:String = ""
    var keyWord:String!
    var keyWords:[String]!
    
    override func viewDidLoad() {
        leftWidth = Float(self.view.frame.width * 0.35)
        super.viewDidLoad()
        
        initUI()
        
        getRecommendData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI(){
        strinkView.hidden = true
        titleLbl.text = "热门搜索"
        
        byVideoNameBtn = KeyBoardViewButton()
        byVideoNameBtn.buttonMode = .Text
        byVideoNameBtn.textLbl.text = "搜片名"
        byVideoNameBtn.textLbl.font = UIFont.systemFontOfSize(13)
        byVideoNameBtn.addTarget(self, action: #selector(self.searchByVideoName), forControlEvents: .TouchUpInside)
        leftView.addSubview(byVideoNameBtn)
        byVideoNameBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(leftView).offset(-10)
            make.left.equalTo(leftView.snp_right).multipliedBy(0.1)
            make.height.equalTo(leftView).multipliedBy(0.08)
            make.width.equalTo(leftView).multipliedBy(0.8 * 0.48)
        }
        
        byActorBtn = KeyBoardViewButton()
        byActorBtn.buttonMode = .Text
        byActorBtn.textLbl.text = "搜演员"
        byActorBtn.textLbl.font = UIFont.systemFontOfSize(13)
        byActorBtn.addTarget(self, action: #selector(self.searchByActor), forControlEvents: .TouchUpInside)
        leftView.addSubview(byActorBtn)
        byActorBtn.snp_makeConstraints { (make) in
            make.right.equalTo(leftView.snp_right).multipliedBy(0.9)
            make.top.bottom.equalTo(byVideoNameBtn)
            make.width.equalTo(byVideoNameBtn)
        }
        
        leftContentView = SearchLeftView()
        leftContentView.fullKeyboard.keyboardDelegate = self
        leftContentView.t9Keyboard.keyboardDelegate = self
        leftView.addSubview(leftContentView)
        leftContentView.snp_makeConstraints { (make) in
            make.left.equalTo(leftView.snp_right).multipliedBy(0.1)
            make.right.equalTo(leftView).multipliedBy(0.9)
            make.top.equalTo(leftView).offset(20)
            make.bottom.equalTo(byVideoNameBtn.snp_top)
        }
        
        searchRecomView = SearchRecommendView()
        searchRecomView.itemClickDelegate = self
        self.contentView.addSubview(searchRecomView)
        searchRecomView.snp_makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp_bottom)
            make.width.equalTo(view.snp_width).dividedBy(2)
            make.bottom.equalTo(view)
        }
        
        videoListView = VideoListView()
        videoListView.hidden = true
        videoListView.delegate = self
        videoListView.collectionView.tag = 4
        self.contentView.addSubview(videoListView)
        videoListView.snp_makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp_bottom)
            make.bottom.equalTo(view)
            make.width.equalTo(contentView).offset(-20)
        }
    }
    
    
    
    private func getRecommendData(){
        hiddenErrorView()
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_RECOMMAND_KEY_ACTION)!, parameters: nil).response{ [weak self]
            _,_,data,error in
            
            guard let strongSelf = self else{
                return
            }
            
            if error != nil{
                strongSelf.searchRecomView.loadingView.stopAnimat()
                strongSelf.showErrorView()
                return
            }
            strongSelf.requestId = .RECOMMEND_SEARCH_REQUEST
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    private func getSearchListData(){
        hiddenErrorView()
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_ACTION)!, parameters: configParams()).response{ [weak self]
            _,_,data,error in
            
            guard let strongSelf = self else{
                return
            }
            
            if error != nil{
                strongSelf.videoListView.loadingView.stopAnimat()
                strongSelf.showErrorView()
                return
            }
            strongSelf.requestId = .SEARCH_VIDEO_REQUEST
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    private func configParams() -> [String:AnyObject]{
        var res:[String:AnyObject] = [String:AnyObject]()
        
        res["searchKey"] = leftContentView.keyLabel.text
        res["pageNo"] = searchPageData.pageNo
        res["pageSize"] = SearchVideoPageData.PAGE_SIZE
        if SearchVideoPageData.V20_SEARCH_TYPE_ALL != searchPageData.type {
            res["type"] = searchPageData.type
        }
        
        return res
    }
    
    func refreshVideoListView(){
        searchPageData =  SearchVideoPageData()
        videoListView.removeViewData()
        videoListView.collectionView.hidden = true
        getSearchListData()
        searchRecomView.hidden = true
        videoListView.hidden = false
        subTitleLbl.hidden = false
        videoListView.loadingView.startAnimat()
    }
    
    func searchByVideoName(){
        searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_VIDEO
        refreshVideoListView()
    }
    
    func searchByActor(){
        searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_ACTOR
        refreshVideoListView()
    }
    
    //推荐列表item点击
    func onSearchRecommendViewItemClick(title: String) {
        keyString = title
        leftContentView.keyLabel.text = title
        refreshVideoListView()
    }
    
    //视频列表item点击
    func onVideoListViewItemClick(videoId: String) {
        let detailViewController = VideoDetailViewController()
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        detailViewController.extras = extras
        self.presentViewController(detailViewController, animated: true, completion: nil)
    }
    
    func onLoadMoreListener() {
        searchPageData.pageNo += 1
        if searchPageData.pageNo > searchPageData.maxPageNum {
            return
        }
        getSearchListData()
        videoListView.loadingView.startAnimat()
    }
    
    //键盘代理
    func onClearBtnClick() {
        titleLbl.text = "热门搜索"
        keyString = ""
        leftContentView.keyLabel.text = keyString
        searchRecomView.hidden = false
        videoListView.hidden = true
        subTitleLbl.hidden = true
    }
    
    func onBackspaceClick() {
        if !keyString.isEmpty{
            keyString.removeAtIndex(keyString.endIndex.predecessor())
            leftContentView.keyLabel.text = keyString
            searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_ALL
            if keyString.isEmpty {
                titleLbl.text = "热门搜索"
                searchRecomView.hidden = false
                getRecommendData()
                videoListView.hidden = true
                subTitleLbl.hidden = true
            }else{
                refreshVideoListView()
            }
        }
    }
    
    func onKeyboardClick(letter: String) {
        titleLbl.text = "搜索结果"
        keyString += letter
        searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_ALL
        leftContentView.keyLabel.text = keyString
        refreshVideoListView()
    }
    
    func onDigitalBtnClick(point: CGRect,data: [String]) {
        let t9Key = T9PopupView(frame: self.view.frame,data: data,centerPoint: point)
        t9Key.clickDelegate = self
        self.view.addSubview(t9Key)
        
    }
    
    func showErrorView(){
        errorView = ErrorView()
        errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
        self.contentView.addSubview(errorView)
        errorView.snp_makeConstraints { (make) in
            make.left.right.equalTo(videoListView)
            make.top.bottom.equalTo(videoListView)
        }
    }
    
    func hiddenErrorView(){
        if errorView != nil {
            errorView.removeFromSuperview()
            errorView = nil
        }
    }
    
    deinit{
        print("search deinit")
    }
    
}

/*
 xml解析
 */
extension SearchViewController: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == .RECOMMEND_SEARCH_REQUEST {
            if currentElement == "keywords"{
                keyWords = [String]()
            }
        }else if requestId == .SEARCH_VIDEO_REQUEST{
            if currentElement == "video_item" {
                videoItem = VideoBriefItem()
            }else if currentElement == "video_list" {
                videoList = Array<VideoBriefItem>()
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if requestId == .RECOMMEND_SEARCH_REQUEST {
            if currentElement == "name"{
                keyWord = content
            }
        }else if requestId == .SEARCH_VIDEO_REQUEST{
            if currentElement == "total" {
                searchPageData.totalSize = Int(content)!
                let pageSize : Float = Float(VodVideoPageData.PAGE_SIZE)
                let totalSize : Float = Float(content)!
                searchPageData.maxPageNum = Int(ceilf(totalSize/pageSize))
            }else if currentElement == "id"{
                videoItem.id = content
            }else if currentElement == "name"{
                videoItem.name = content
            }else if currentElement == "duration"{
                videoItem.duration = content
            }else if currentElement == "smallImg"{
                videoItem.posterImg = content
            }else if currentElement == "most"{
                videoItem.resolutionType = Int(content)
            }else if currentElement == "doubanId"{
                videoItem.doubanId = content
            }else if currentElement == "doubanAverage"{
                videoItem.score = content
            }
            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == .RECOMMEND_SEARCH_REQUEST {
            if elementName == "name"{
                keyWords.append(keyWord)
                keyWord = nil
            }
        }else if requestId == .SEARCH_VIDEO_REQUEST{
            if elementName == "video_item" {
                videoList.append(videoItem)
                videoItem = nil
            }else if elementName == "video_list"{
                searchPageData.videoList.appendContentsOf(videoList)
                videoList = nil
            }
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if requestId == .RECOMMEND_SEARCH_REQUEST {
            let re = GridViewMatrixTransformer().multiPageTransform(keyWords, row: keyWords.count + 1 / 2, col: 2)
            if re != nil{
                searchRecomView.setViewData(re!)
            }
        }else if requestId == .SEARCH_VIDEO_REQUEST{
            subTitleLbl.text = "共\(searchPageData.totalSize)个视频"
            videoListView.collectionView.hidden = false
            videoListView.setViewData(searchPageData.videoList)
        }
    }
    
}



