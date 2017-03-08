//
//  SearchViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class SearchViewController: BaseHorizontalViewController,IKeyboardDelegate,SearchRecommendViewItemClickDelegate,VideoListViewDelegate{
    
    fileprivate enum NetRequestId{
        case recommend_SEARCH_REQUEST
        case search_VIDEO_REQUEST
    }
    fileprivate var requestId:NetRequestId!
    
    fileprivate var leftContentView:SearchLeftView!
    fileprivate var searchRecomView:SearchRecommendView!
    fileprivate var videoListView:VideoListView!
    fileprivate var byVideoNameBtn:KeyBoardViewButton!
    fileprivate var byActorBtn:KeyBoardViewButton!
    
    fileprivate var searchPageData:SearchVideoPageData = SearchVideoPageData()
    fileprivate var videoItem:VideoBriefItem!
    fileprivate var videoList:[VideoBriefItem]!
    
    //XML解析
    fileprivate var currentElement:String!
    
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
        strinkView.isHidden = true
        titleLbl.text = "热门搜索"
        
        byVideoNameBtn = KeyBoardViewButton()
        byVideoNameBtn.buttonMode = .text
        byVideoNameBtn.textLbl.text = "搜片名"
        byVideoNameBtn.textLbl.font = UIFont.systemFont(ofSize: 13)
        byVideoNameBtn.addTarget(self, action: #selector(self.searchByVideoName), for: .touchUpInside)
        leftView.addSubview(byVideoNameBtn)
        byVideoNameBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(leftView).offset(-10)
            make.left.equalTo(leftView.snp.right).multipliedBy(0.1)
            make.height.equalTo(leftView).multipliedBy(0.08)
            make.width.equalTo(leftView).multipliedBy(0.8 * 0.48)
        }
        
        byActorBtn = KeyBoardViewButton()
        byActorBtn.buttonMode = .text
        byActorBtn.textLbl.text = "搜演员"
        byActorBtn.textLbl.font = UIFont.systemFont(ofSize: 13)
        byActorBtn.addTarget(self, action: #selector(self.searchByActor), for: .touchUpInside)
        leftView.addSubview(byActorBtn)
        byActorBtn.snp.makeConstraints { (make) in
            make.right.equalTo(leftView.snp.right).multipliedBy(0.9)
            make.top.bottom.equalTo(byVideoNameBtn)
            make.width.equalTo(byVideoNameBtn)
        }
        
        leftContentView = SearchLeftView()
        leftContentView.fullKeyboard.keyboardDelegate = self
        leftContentView.t9Keyboard.keyboardDelegate = self
        leftView.addSubview(leftContentView)
        leftContentView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp.right).multipliedBy(0.1)
            make.right.equalTo(leftView).multipliedBy(0.9)
            make.top.equalTo(leftView).offset(20)
            make.bottom.equalTo(byVideoNameBtn.snp.top)
        }
        
        searchRecomView = SearchRecommendView()
        searchRecomView.itemClickDelegate = self
        self.contentView.addSubview(searchRecomView)
        searchRecomView.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp.bottom)
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.bottom.equalTo(view)
        }
        
        videoListView = VideoListView()
        videoListView.isHidden = true
        videoListView.delegate = self
        videoListView.collectionView.tag = 4
        self.contentView.addSubview(videoListView)
        videoListView.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(view)
            make.width.equalTo(contentView).offset(-20)
        }
    }
    
    
    
    fileprivate func getRecommendData(){
        hiddenErrorView()
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_RECOMMAND_KEY_ACTION)!, parameters: nil).responseData{ [weak self]
            response in
            
            guard self != nil else{
                return
            }
            
            
            switch response.result{
            case .failure(let error):
                print(error)
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }        }
    }
    
    fileprivate func getSearchListData(){
        hiddenErrorView()
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_ACTION)!, parameters: configParams()).responseData{ [weak self]
            response in
            
            guard self != nil else{
                return
            }
            
            switch response.result{
            case .failure(let error):
                print(error)
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    fileprivate func configParams() -> [String:AnyObject]{
        var res:[String:AnyObject] = [String:AnyObject]()
        
        res["searchKey"] = leftContentView.keyLabel.text as AnyObject?
        res["pageNo"] = searchPageData.pageNo as AnyObject?
        res["pageSize"] = SearchVideoPageData.PAGE_SIZE as AnyObject?
        if SearchVideoPageData.V20_SEARCH_TYPE_ALL != searchPageData.type {
            res["type"] = searchPageData.type as AnyObject?
        }
        
        return res
    }
    
    func refreshVideoListView(){
        searchPageData =  SearchVideoPageData()
        videoListView.removeViewData()
        videoListView.collectionView.isHidden = true
        getSearchListData()
        searchRecomView.isHidden = true
        videoListView.isHidden = false
        subTitleLbl.isHidden = false
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
    func onSearchRecommendViewItemClick(_ title: String) {
        keyString = title
        leftContentView.keyLabel.text = title
        refreshVideoListView()
    }
    
    //视频列表item点击
    func onVideoListViewItemClick(_ videoId: String) {
        let detailViewController = VideoDetailViewController()
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        detailViewController.extras = extras
        self.present(detailViewController, animated: true, completion: nil)
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
        searchRecomView.isHidden = false
        videoListView.isHidden = true
        subTitleLbl.isHidden = true
    }
    
    func onBackspaceClick() {
        if !keyString.isEmpty{
            keyString.remove(at: keyString.characters.index(before: keyString.endIndex))
            leftContentView.keyLabel.text = keyString
            searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_ALL
            if keyString.isEmpty {
                titleLbl.text = "热门搜索"
                searchRecomView.isHidden = false
                getRecommendData()
                videoListView.isHidden = true
                subTitleLbl.isHidden = true
            }else{
                refreshVideoListView()
            }
        }
    }
    
    func onKeyboardClick(_ letter: String) {
        titleLbl.text = "搜索结果"
        keyString += letter
        searchPageData.type = SearchVideoPageData.V20_SEARCH_TYPE_ALL
        leftContentView.keyLabel.text = keyString
        refreshVideoListView()
    }
    
    func onDigitalBtnClick(_ point: CGRect,data: [String]) {
        let t9Key = T9PopupView(frame: self.view.frame,data: data,centerPoint: point)
        t9Key.clickDelegate = self
        self.view.addSubview(t9Key)
        
    }
    
    func showErrorView(){
        errorView = ErrorView()
        errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
        self.contentView.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
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
extension SearchViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == .recommend_SEARCH_REQUEST {
            if currentElement == "keywords"{
                keyWords = [String]()
            }
        }else if requestId == .search_VIDEO_REQUEST{
            if currentElement == "video_item" {
                videoItem = VideoBriefItem()
            }else if currentElement == "video_list" {
                videoList = Array<VideoBriefItem>()
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if requestId == .recommend_SEARCH_REQUEST {
            if currentElement == "name"{
                keyWord = content
            }
        }else if requestId == .search_VIDEO_REQUEST{
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == .recommend_SEARCH_REQUEST {
            if elementName == "name"{
                keyWords.append(keyWord)
                keyWord = nil
            }
        }else if requestId == .search_VIDEO_REQUEST{
            if elementName == "video_item" {
                videoList.append(videoItem)
                videoItem = nil
            }else if elementName == "video_list"{
                searchPageData.videoList.append(contentsOf: videoList)
                videoList = nil
            }
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if requestId == .recommend_SEARCH_REQUEST {
            let re = GridViewMatrixTransformer().multiPageTransform(keyWords, row: keyWords.count + 1 / 2, col: 2)
            if re != nil{
                searchRecomView.setViewData(re!)
            }
        }else if requestId == .search_VIDEO_REQUEST{
            subTitleLbl.text = "共\(searchPageData.totalSize)个视频"
            videoListView.collectionView.isHidden = false
            videoListView.setViewData(searchPageData.videoList)
        }
    }
    
}



