//
//  VideoDetailViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/11.
//  Copyright © 2016年 skyworth. All rights reserved.
//


import UIKit
import Alamofire
import DZNEmptyDataSet
import PopupController

class VideoDetailViewController: BaseViewController,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,ZXOptionBarDelegate,ZXOptionBarDataSource,DetailBtnClickDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ChooseDramaDelegate {
    
    private enum NetRequestId{
        case VIDEO_DETAIL_REQUEST_ID
        case RECOMMENDED_REQUEST_ID
        case SEARCH_REQUEST_ID
        case GET_VIDEO_SPURCE_REQUEST_ID
    }
    
    //上一层页面传递的参数
    var extras:[ExtraData]!
    
    var videoId : String = ""
    var from : String = ""
    var screenHeight : CGFloat!
    var width : CGFloat!
    
    var currentElement : String! //xml节点名字
    var dramas : [Drama]!
    var drama : Drama!
    var currentDepth : Int = 1 //解析xml文件的节点层数
    var videoDetailInfo : VideoDetailInfo!
    var recommends : [String] = ["相关推荐"]
    private var requestId : NetRequestId!
    var videoBriefItems : [VideoBriefItem] = Array()
    var videoBriefItem : VideoBriefItem!
    var params : Dictionary<String,String>!
    private var favoriteClickCount:Int = 0
    
    private var sourceList:[VideoSourceInfo] = [VideoSourceInfo]()
    private var videoSource:VideoSourceInfo!
    private var source:Source!
    private var popup:PopupController!
    
    private var backView:UIButton!
    private var posterImg : UIImageView!
    private var divider : UIView!
    private var detailView : VideoDetailInfoView!
    private var recommendLoadingView:LoadingView!
    
    private var recommendTab : UITableView!
    private var horizontalTab : ZXOptionBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView = UIButton()
        backView.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        backView.addOnClickListener(self, action: #selector(self.dismissViewController))
        self.view.addSubview(backView)
        
        videoId = extras[0].value
        screenHeight = self.view.frame.height
        width = self.view.frame.width
        
        posterImg = UIImageView()
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        
        detailView = VideoDetailInfoView(frame: CGRectMake(0, 0, width - (screenHeight * 2/3 - 30) * 2/3 - 50, screenHeight * 2/3 - 30))
        detailView.hidden = true
        detailView.delegate = self
        self.view.addSubview(detailView)
        addClick()
        
        divider = UIView()
        divider.backgroundColor = UIColor.init(patternImage: UIImage(named: "v2_video_detail_divider_bg")!)
        divider.hidden = true
        self.view.addSubview(divider)
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(40)
        }
        
        recommendLoadingView = LoadingView()
        self.view.addSubview(recommendLoadingView)
        
        backView.snp_makeConstraints { (make) in
            make.left.equalTo(detailView).offset(5)
            make.top.equalTo(detailView).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        posterImg.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.bottom.equalTo(divider.snp_top).offset(-10)
            make.top.equalTo(self.view).offset(20)
            make.width.equalTo((screenHeight * 2/3 - 30) * 2/3)
        }
        
        divider.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(view).offset(screenHeight * 2/3)
            make.height.equalTo(1)
        }
        detailView.snp_makeConstraints { (make) in
            make.left.equalTo(divider)
            make.right.equalTo(posterImg.snp_left).offset(-10)
            make.top.equalTo(posterImg)
            make.bottom.equalTo(posterImg)
        }
        
        recommendTab = UITableView()
        recommendTab.delegate = self
        recommendTab.dataSource = self
        recommendTab.backgroundColor = UIColor.clearColor()
        recommendTab.showsVerticalScrollIndicator = false
        recommendTab.separatorStyle = .None
        recommendTab.hidden = true
        self.view.addSubview(recommendTab)
        recommendTab.snp_makeConstraints { (make) in
            make.top.equalTo(divider).offset(5)
            make.bottom.equalTo(view).offset(-5)
            make.left.equalTo(self.view).offset(20)
            make.width.equalTo(90)
        }
        
        horizontalTab = ZXOptionBar(frame: CGRect(x: 1,y: 1,width: 1,height: 1), barDelegate: self, barDataSource: self)
        horizontalTab.backgroundColor = UIColor.clearColor()
        horizontalTab.hidden = true
        self.view.addSubview(horizontalTab)
        horizontalTab.snp_makeConstraints { (make) in
            make.leading.equalTo(recommendTab.snp_trailing)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(recommendTab)
            make.bottom.equalTo(recommendTab)
        }
        
        recommendLoadingView.snp_makeConstraints { (make) in
            make.center.equalTo(horizontalTab)
            make.height.width.equalTo(30)
        }
        
        getVideoDetailRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //开始解析
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElement = elementName;
        if requestId == NetRequestId.VIDEO_DETAIL_REQUEST_ID {
            if currentElement == "video" {
                videoDetailInfo = VideoDetailInfo()
                currentDepth += 1
            }else if currentElement == "videoMergeInfoList"{
                dramas = Array()
                currentDepth += 1
            }else if currentElement == "videoMergeInfo"{
                drama = Drama()
                currentDepth += 1
            }else if currentElement == "response"{
                currentDepth += 1
            }
        }else if requestId == NetRequestId.RECOMMENDED_REQUEST_ID || requestId == NetRequestId.SEARCH_REQUEST_ID{
            if currentElement == "video_list" {
                videoBriefItems.removeAll()
                videoBriefItems = Array()
            }else if currentElement == "video_item"{
                videoBriefItem = VideoBriefItem()
            }
        }else if requestId == NetRequestId.GET_VIDEO_SPURCE_REQUEST_ID{
            if currentElement == "video_source_info" {
                videoSource = VideoSourceInfo()
                currentDepth += 1
            }else if currentElement == "source" {
                source = Source()
                currentDepth += 1
            }
        }
        
    }
    
    //解析节点内容
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if currentElement == nil {
            return
        }
        if content.isEmpty {
            return
        }
        if requestId == NetRequestId.VIDEO_DETAIL_REQUEST_ID {
            if currentElement == "id" {
                if currentDepth == 3 {
                    videoDetailInfo.id = content
                }else if currentDepth == 5{
                    drama.id = content
                }
            }else if currentElement == "doubanId"{
                videoDetailInfo.doubanId = content
            }else if currentElement == "doubanAverage"{
                videoDetailInfo.doubanAverage = content
            }else if currentElement == "apikey"{
                videoDetailInfo.doubanKey = content
            }else if currentElement == "name"{
                if currentDepth == 3 {
                    videoDetailInfo.name = content
                }else if currentDepth == 5{
                    drama.title = content
                }
            }else if currentElement == "channel"{
                videoDetailInfo.channel = content
            }else if currentElement == "channelId"{
                videoDetailInfo.channelId = content
            }else if currentElement == "area"{
                videoDetailInfo.area = content
            }else if currentElement == "duration"{
                videoDetailInfo.duration = content
            }else if currentElement == "cate"{
                videoDetailInfo.category = content
            }else if currentElement == "screenTime"{
                videoDetailInfo.publishTime = content
            }else if currentElement == "director"{
                videoDetailInfo.directorString = content
                videoDetailInfo.directors = removeRepeatActor(content.componentsSeparatedByString(","))
            }else if currentElement == "isEpisode"{
                videoDetailInfo.chooseDramaFlag = Int(content)!
            }else if currentElement == "episodeOrder"{
                videoDetailInfo.dramaOrderFlag = Int(content)!
            }else if currentElement == "performer"{
                videoDetailInfo.actorString = content
                videoDetailInfo.actors = removeRepeatActor(content.componentsSeparatedByString(","))
            }else if currentElement == "isFav"{
                videoDetailInfo.isFavorite = judgeStatus(content)
            }else if currentElement == "annotation"{
                videoDetailInfo.desc = content
            }else if currentElement == "smallImg"{
                videoDetailInfo.poster = content
            }else if currentElement == "most"{
                if currentDepth == 3 {
                    videoDetailInfo.resolutionType = Int(content)
                }
            }else if currentElement == "totalInfo"{
                videoDetailInfo.count = Int(content)
            }
        }else if requestId == NetRequestId.RECOMMENDED_REQUEST_ID || requestId == NetRequestId.SEARCH_REQUEST_ID{
            if currentElement == "video_item" {
                videoBriefItem = VideoBriefItem()
            }else if currentElement == "id"{
                videoBriefItem.id = content
            }else if currentElement == "name"{
                videoBriefItem.name = content
            }else if currentElement == "duration"{
                videoBriefItem.duration = content
            }else if currentElement == "smallImg"{
                videoBriefItem.posterImg = content
            }else if currentElement == "most"{
                videoBriefItem.resolutionType = Int(content)
            }else if currentElement == "doubanAverage"{
                videoBriefItem.score = content
            }else if currentElement == "channel"{
                videoBriefItem.channel = content
            }else if currentElement == "channelId"{
                videoBriefItem.channelId = content
            }
        }else if requestId == NetRequestId.GET_VIDEO_SPURCE_REQUEST_ID{
            if currentElement == "id" {
                if currentDepth == 1 {
                    videoSource.id = content
                }else if currentDepth == 2 {
                    source.id = content
                }
            }else if currentElement == "name"{
                if currentDepth == 1 {
                    videoSource.name = content
                }else if currentDepth == 2 {
                    source.name = content
                }
            }else if currentElement == "duration" {
                //videoSource.
            }else if currentElement == "videoMetaId"{
                videoSource.metaId = content
            }else if currentElement == "playpoint"{
                videoSource.playPointAmount = Int(content)!
            }else if currentElement == "downloadpoint"{
                videoSource.downloadPointAmount = Int(content)!
            }else if currentElement == "otherSource"{
                source.otherSource = content
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if requestId == NetRequestId.VIDEO_DETAIL_REQUEST_ID {
            if elementName == "video" {
                currentDepth -= 1
            }else if elementName == "response"{
                currentDepth -= 1
            }else if elementName == "videoMergeInfo"{
                currentDepth -= 1
                dramas.append(drama)
                drama = nil
            }else if elementName == "videoMergeInfoList"{
                currentDepth -= 1
                videoDetailInfo.dramas = dramas
            }
        }else if requestId == NetRequestId.RECOMMENDED_REQUEST_ID || requestId == NetRequestId.SEARCH_REQUEST_ID{
            if elementName == "video_item" {
                videoBriefItems.append(videoBriefItem)
                videoBriefItem = nil
            }
        }else if requestId == NetRequestId.GET_VIDEO_SPURCE_REQUEST_ID{
            if elementName == "video_source_info" {
                currentDepth -= 1
                sourceList.append(videoSource)
                videoSource = nil
            }else if elementName == "source" {
                currentDepth -= 1
                videoSource.source = source
                source = nil
            }
        }
        
        currentElement = nil
    }
    
    //结束解析
    func parserDidEndDocument(parser: NSXMLParser) {
        currentDepth = 0
        if requestId == NetRequestId.VIDEO_DETAIL_REQUEST_ID {
            VideoInfoUtils.refreshWatchRecord(videoDetailInfo)
            posterImg.sd_setImageWithURL(NSURL(string: videoDetailInfo.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
            detailView.setData(videoDetailInfo)
            detailView.hidden = false
            backView.hidden = true
            divider.hidden = false
            recommendTab.hidden = false
            addClick()
            if videoDetailInfo.directors != nil{
                recommends.appendContentsOf(videoDetailInfo.directors)
            }
            if videoDetailInfo.actors != nil {
                recommends.appendContentsOf(videoDetailInfo.actors)
            }
            recommendLoadingView.startAnimat()
            recommendTab.reloadData()
            loadingView.stopAnimat()
            getSourceInfo()
            getRecommendRequest()
        }else if requestId == NetRequestId.RECOMMENDED_REQUEST_ID || requestId == NetRequestId.SEARCH_REQUEST_ID{
            horizontalTab.hidden = false
            recommendLoadingView.stopAnimat()
            horizontalTab.reloadData()
        }else if requestId == NetRequestId.GET_VIDEO_SPURCE_REQUEST_ID{
            videoDetailInfo.currentDrama?.sources = sourceList
            if videoDetailInfo.currentDrama!.hasSource() {
                let item:VideoHistoryItem? = VideoDBHelper.shareInstance().getHistoryItem(videoDetailInfo.id)
                if item != nil {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(VideoInfoUtils.getSourcePositionBySourceId(videoDetailInfo, sourceId: item!.sourceId))
                }else {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(0)
                }
            }
        }
    }
    
    /// tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "recommendCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = recommends[indexPath.row]
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.textAlignment = .Center
        cell?.textLabel?.lineBreakMode = .ByClipping
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = .None
        cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        
        if lastPosition == indexPath.row {
            cell?.textLabel?.textColor = UIColor.textBlueColor()
        }
        
        return  cell!
    }
    
    var lastPosition = 0 //记录上一次所点的位置
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPosition, inSection: 0))
        lastCell?.textLabel?.textColor = UIColor.whiteColor()
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        currentCell?.textLabel?.textColor = UIColor.textBlueColor()
        
        lastPosition = indexPath.row
        
        let index = indexPath.row
        refreshReommendList(index)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
    /// optionBar
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return videoBriefItems.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "optionCell"
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
        cell?.backgroundColor = UIColor.clearColor()
        cell?.videoNameLbl.text = videoBriefItems[index].name
        cell?.icon.sd_setImageWithURL(NSURL(string: videoBriefItems[index].posterImg),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cell?.durationLbl.text = videoBriefItems[index].duration
        let average = videoBriefItems[index].score
        if average.isEmpty {
            cell?.averageLbl.hidden = true
        }else{
            cell?.averageLbl.hidden = false
            cell?.averageLbl.text = videoBriefItems[index].score
        }
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(optionBar.bounds.height * 3/4)
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let detailController = VideoDetailViewController()
        var extra = [ExtraData]()
        extra.append(ExtraData(name: "", value: videoBriefItems[index].id))
        detailController.extras = extra
        self.presentViewController(detailController, animated: true, completion: nil)
    }
    
    func judgeStatus(status:String) -> Bool{
        let ret : Int = Int(status)!
        if ret == 1 {
            return true
        }
        return false
    }
    
    //获取视频详情
    func getVideoDetailRequest(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_DETAIL_INFO_V2)!, parameters: ["videoId": extras[0].value]).response{ request, response, data, error in
            self.requestId = NetRequestId.VIDEO_DETAIL_REQUEST_ID
            if error != nil {
                print(error)
                return
            }
            let parse = NSXMLParser(data: data!)
            parse.delegate = self
            parse.parse()
        }
    }
    
    ///获取推荐视频
    func getRecommendRequest(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_RELATED_LIST)!,parameters: ["videoId":videoId]).response{ request, response, data, error in
            self.requestId = NetRequestId.RECOMMENDED_REQUEST_ID
            if error != nil{
                print(error)
                return
            }
            let parse = NSXMLParser(data: data!)
            parse.delegate = self
            parse.parse()
        }
    }
    
    //获取按演员推荐
    func getRecommendByActorRequest(searchKey:String, type:String){
        let params = ["searchKey" : searchKey, "type" : type]
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_ACTION)!, parameters: params).response{ request, response, data, error in
            self.requestId = NetRequestId.SEARCH_REQUEST_ID
            if error != nil{
                print(error)
                return
            }
            let parse = NSXMLParser(data: data!)
            parse.delegate = self
            parse.parse()
        }
    }
    
    //获取源信息
    func getSourceInfo(){
        if videoDetailInfo.currentDrama == nil {
            return
        }
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_LIST_VIDEO_SOURCE_INFO)!, parameters: ["videoMergeInfoId" : (videoDetailInfo.currentDrama?.id)!]).responseData{
            response in
            self.requestId = NetRequestId.GET_VIDEO_SPURCE_REQUEST_ID
            
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
    
    private func refreshReommendList(index: Int){
        horizontalTab.hidden = true
        recommendLoadingView.startAnimat()
        if index == 0 {
            getRecommendRequest()
        }else{
            getRecommendByActorRequest(recommends[index], type: "1")
        }
        
    }
    
    
    //操作按钮点击事件
    func detailBtnClick(index: Int) {
        
        let position = detailView.btnItems[index].position
        switch position {
        case VideoInfoUtils.OP_POSITION_PLAY:
            let viewController:PlayerViewController = PlayerViewController()
            self.presentViewController(viewController, animated: true, completion: nil)
            break
        case VideoInfoUtils.OP_POSITION_CHOOSE:
            popup = PopupController.create(self).customize([.Layout(.Bottom)])
            let chooseDramaController = PopupChooseDramaController()
            chooseDramaController.videoDetailInfo = videoDetailInfo
            chooseDramaController.delegate = self
            popup.show(chooseDramaController)
            break
        case VideoInfoUtils.OP_POSITION_DOWNLOAD:
            
            break
        case VideoInfoUtils.OP_POSITION_FAV:
            if (videoDetailInfo.currentDrama?.sources != nil && videoDetailInfo.currentDrama?.sources.count > 0){
                favoriteClickCount += 1
                let cell = detailView.mOptionBar.cellForColumnAtIndex(index) as? VideoDetailBtnCell
                if cell != nil {
                    videoDetailInfo.isFavorite = !videoDetailInfo.isFavorite
                    cell?.imgBtn.setImage(VideoInfoUtils.chooseImageWithFavorite(videoDetailInfo.isFavorite))
                }
            }
            break
        default:
            break
        }
        
    }
    
    
    /**
     去除数组中相同的元素
     */
    func removeRepeatActor(array: [String]) -> [String]{
        var trim = Set<String>()
        for  l in array {
            trim.insert(l)
        }
        var ret = [String]()
        for l in trim{
            ret.append(l)
        }
        return ret
    }
    
    //UILabel的共同属性
    func setCommenAttr(label:UILabel){
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(12)
    }
    
    //UIButton的共同属性
    func setButtonAttr(button:UIButton){
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
    }
    
    func onDramaChooseListener(dramaIndex: Int) {
        let lastDramaPosition = videoDetailInfo.lastPlayDramaPosition
        
        if lastDramaPosition != dramaIndex {
            videoDetailInfo.setLastPlayDramaPosition(dramaIndex)
            videoDetailInfo.dramaPlayedDuration = 0
        }
        
        if popup != nil {
            popup.dismiss()
            popup = nil
        }
    }
    
    func addClick(){
        detailView.backBtn.addOnClickListener(self, action: (#selector(self.dismissViewController)))
    }
    
    override func dismissViewController() {
        
        if favoriteClickCount % 2 == 1 {
            VideoDBHelper.shareInstance().updateFavorite(videoDetailInfo)
            NSNotificationCenter.defaultCenter().postNotificationName("FavoriteChangedNotify", object: nil)
        }
        super.dismissViewController()
    }
    
}

