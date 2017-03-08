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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class VideoDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,ZXOptionBarDelegate,ZXOptionBarDataSource,DetailBtnClickDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ChooseDramaDelegate {
    
    fileprivate enum NetRequestId{
        case video_DETAIL_REQUEST_ID
        case recommended_REQUEST_ID
        case search_REQUEST_ID
        case get_VIDEO_SOURCE_REQUEST_ID
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
    fileprivate var requestId : NetRequestId!
    var videoBriefItems : [VideoBriefItem] = Array()
    var videoBriefItem : VideoBriefItem!
    var params : Dictionary<String,String>!
    fileprivate var favoriteClickCount:Int = 0
    
    fileprivate var sourceList:[VideoSourceInfo] = [VideoSourceInfo]()
    fileprivate var videoSource:VideoSourceInfo!
    fileprivate var source:Source!
    fileprivate var popup:PopupController!
    
    fileprivate var backView:UIButton!
    fileprivate var posterImg : UIImageView!
    fileprivate var divider : UIView!
    fileprivate var detailView : VideoDetailInfoView!
    fileprivate var recommendLoadingView:LoadingView!
    
    fileprivate var recommendTab : UITableView!
    fileprivate var horizontalTab : ZXOptionBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        getVideoDetailRequest()
        
    }
    
    func initUI(){
        backView = UIButton()
        backView.setImage(UIImage(named: "play_back_full"), for: UIControlState())
        backView.addOnClickListener(self, action: #selector(self.dismissViewController))
        self.view.addSubview(backView)
        
        videoId = extras[0].value
        screenHeight = self.view.frame.height
        width = self.view.frame.width
        
        posterImg = UIImageView()
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        
        let somewidth = (screenHeight * 2/3 - 30)
        let detailWidth = width - somewidth * 2/3 - 50
        let detailHeight = screenHeight * 2/3 - 30
        detailView = VideoDetailInfoView(frame: CGRect(x: 0, y: 0, width: detailWidth, height: detailHeight))
        detailView.isHidden = true
        detailView.delegate = self
        self.view.addSubview(detailView)
        addClick()
        
        divider = UIView()
        divider.backgroundColor = UIColor.init(patternImage: UIImage(named: "v2_video_detail_divider_bg")!)
        divider.isHidden = true
        self.view.addSubview(divider)
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(40)
        }
        
        recommendLoadingView = LoadingView()
        self.view.addSubview(recommendLoadingView)
        
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(detailView).offset(5)
            make.top.equalTo(detailView).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        posterImg.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right).offset(-30)
            make.bottom.equalTo(divider.snp.top).offset(-10)
            make.top.equalTo(self.view).offset(20)
            make.width.equalTo((screenHeight * 2/3 - 30) * 2/3)
        }
        
        divider.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(view).offset(screenHeight * 2/3)
            make.height.equalTo(1)
        }
        detailView.snp.makeConstraints { (make) in
            make.left.equalTo(divider)
            make.right.equalTo(posterImg.snp.left).offset(-10)
            make.top.equalTo(posterImg)
            make.bottom.equalTo(posterImg)
        }
        
        recommendTab = UITableView()
        recommendTab.delegate = self
        recommendTab.dataSource = self
        recommendTab.backgroundColor = UIColor.clear
        recommendTab.showsVerticalScrollIndicator = false
        recommendTab.separatorStyle = .none
        recommendTab.isHidden = true
        self.view.addSubview(recommendTab)
        recommendTab.snp.makeConstraints { (make) in
            make.top.equalTo(divider).offset(5)
            make.bottom.equalTo(view).offset(-5)
            make.left.equalTo(self.view).offset(20)
            make.width.equalTo(90)
        }
        
        horizontalTab = ZXOptionBar(frame: CGRect(x: 1,y: 1,width: 1,height: 1), barDelegate: self, barDataSource: self)
        horizontalTab.backgroundColor = UIColor.clear
        horizontalTab.isHidden = true
        self.view.addSubview(horizontalTab)
        horizontalTab.snp.makeConstraints { (make) in
            make.leading.equalTo(recommendTab.snp.trailing)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(recommendTab)
            make.bottom.equalTo(recommendTab)
        }
        
        errorView = ErrorView()
        errorView.isHidden = true
        self.view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(view)
        }
        
        recommendLoadingView.snp.makeConstraints { (make) in
            make.center.equalTo(horizontalTab)
            make.height.width.equalTo(30)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "recommendCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = recommends[(indexPath as NSIndexPath).row]
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.lineBreakMode = .byClipping
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if lastPosition == (indexPath as NSIndexPath).row {
            cell?.textLabel?.textColor = UIColor.textBlueColor()
        }
        
        return  cell!
    }
    
    var lastPosition = 0 //记录上一次所点的位置
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lastPosition == (indexPath as NSIndexPath).row {
            return
        }
        
        let lastCell = tableView.cellForRow(at: IndexPath(row: lastPosition, section: 0))
        lastCell?.textLabel?.textColor = UIColor.white
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.textLabel?.textColor = UIColor.textBlueColor()
        
        lastPosition = (indexPath as NSIndexPath).row
        
        let index = (indexPath as NSIndexPath).row
        refreshReommendList(index)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    /// optionBar
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        return videoBriefItems.count
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "optionCell"
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
        cell?.backgroundColor = UIColor.clear
        cell?.videoNameLbl.text = videoBriefItems[index].name
        cell?.icon.sd_setImage(with: URL(string: videoBriefItems[index].posterImg),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cell?.durationLbl.text = videoBriefItems[index].duration
        let average = videoBriefItems[index].score
        if average.isEmpty {
            cell?.averageLbl.isHidden = true
        }else{
            cell?.averageLbl.isHidden = false
            cell?.averageLbl.text = videoBriefItems[index].score
        }
        
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(optionBar.bounds.height * 3/4)
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let detailController = VideoDetailViewController()
        var extra = [ExtraData]()
        extra.append(ExtraData(name: "", value: videoBriefItems[index].id))
        detailController.extras = extra
        self.present(detailController, animated: true, completion: nil)
    }
    
    func judgeStatus(_ status:String) -> Bool{
        let ret : Int = Int(status)!
        if ret == 1 {
            return true
        }
        return false
    }
    
    //获取视频详情
    func getVideoDetailRequest(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_DETAIL_INFO_V2)!, method: .get, parameters: ["videoId": extras[0].value], encoding: URLEncoding.default, headers: nil).responseData { (response) in
            self.requestId = NetRequestId.video_DETAIL_REQUEST_ID
            self.loadingView.stopAnimat()
            switch response.result{
            case .failure(_):
                self.errorView.isHidden = false
                self.errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    ///获取推荐视频
    func getRecommendRequest(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_VIDEO_RELATED_LIST)!, parameters:["videoId":videoId]).responseData { (response) in
            self.requestId = NetRequestId.recommended_REQUEST_ID
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let parse = XMLParser(data: data)
                parse.delegate = self
                parse.parse()
            }
        }
    }
    
    //获取按演员推荐
    func getRecommendByActorRequest(_ searchKey:String, type:String){
        let params = ["searchKey" : searchKey, "type" : type]
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_SEARCH_VIDEO_ACTION)!, parameters:params).responseData { (response) in
            self.requestId = NetRequestId.search_REQUEST_ID
            self.requestId = NetRequestId.search_REQUEST_ID
            switch response.result {
            case .failure(let error):
                print(error)
                break
            case .success(let data):
                let parse = XMLParser(data: data)
                parse.delegate = self
                parse.parse()
                break
                
            }
        }
    }
    
    //获取源信息
    func getSourceInfo(){
        if videoDetailInfo.currentDrama == nil {
            return
        }
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_LIST_VIDEO_SOURCE_INFO)!, parameters: ["videoMergeInfoId": (videoDetailInfo.currentDrama?.id)!]).responseData { (response) in
            self.requestId = NetRequestId.get_VIDEO_SOURCE_REQUEST_ID
            
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
    
    fileprivate func refreshReommendList(_ index: Int){
        horizontalTab.isHidden = true
        recommendLoadingView.startAnimat()
        if index == 0 {
            getRecommendRequest()
        }else{
            getRecommendByActorRequest(recommends[index], type: "1")
        }
        
    }
    
    
    //操作按钮点击事件
    func detailBtnClick(_ index: Int) {
        
        let position:Int = detailView.btnItems[index].position
        switch position {
        case VideoInfoUtils.OP_POSITION_PLAY:
            //            if !NetworkUtil.isWifiConnection() {
            //                self.view.makeToast("当前处于非wifi环境下，播放时将产生流量费用")
            //                return
            //            }
            toVideoPlayController()
            break
        case VideoInfoUtils.OP_POSITION_CHOOSE:
            popup = PopupController.create(self).customize([.layout(.bottom)])
            let chooseDramaController = PopupChooseDramaController()
            chooseDramaController.videoDetailInfo = videoDetailInfo
            chooseDramaController.delegate = self
            let _ = popup.show(chooseDramaController)
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
    func removeRepeatActor(_ array: [String]) -> [String]{
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
    func setCommenAttr(_ label:UILabel){
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
    //UIButton的共同属性
    func setButtonAttr(_ button:UIButton){
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    func onDramaChooseListener(_ dramaIndex: Int) {
        let lastDramaPosition = videoDetailInfo.lastPlayDramaPosition
        
        if lastDramaPosition != dramaIndex {
            videoDetailInfo.setLastPlayDramaPosition(dramaIndex)
            videoDetailInfo.dramaPlayedDuration = 0
        }
        if popup != nil {
            popup.dismiss()
            popup = nil
        }
        
        toVideoPlayController()
    }
    
    func addClick(){
        detailView.backBtn.addOnClickListener(self, action: (#selector(self.dismissViewController)))
    }
    
    func toVideoPlayController(){
        let controller = PlayerViewController()
        controller.flag = .detail
        controller.videoDetailInfo = videoDetailInfo
        self.present(controller, animated: true, completion: nil)
    }
    
    override func dismissViewController() {
        
        if favoriteClickCount % 2 == 1 {
            VideoDBHelper.shareInstance.updateFavorite(videoDetailInfo)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FavoriteChangedNotify"), object: nil)
        }
        super.dismissViewController()
    }
    
    deinit{
        print("detail deinit")
    }
    
}

/*
 xml解析
 */
extension VideoDetailViewController:XMLParserDelegate{
    
    //开始解析
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElement = elementName;
        if requestId == NetRequestId.video_DETAIL_REQUEST_ID {
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
        }else if requestId == NetRequestId.recommended_REQUEST_ID || requestId == NetRequestId.search_REQUEST_ID{
            if currentElement == "video_list" {
                videoBriefItems.removeAll()
                videoBriefItems = Array()
            }else if currentElement == "video_item"{
                videoBriefItem = VideoBriefItem()
            }
        }else if requestId == NetRequestId.get_VIDEO_SOURCE_REQUEST_ID{
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
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if currentElement == nil {
            return
        }
        if content.isEmpty {
            return
        }
        if requestId == NetRequestId.video_DETAIL_REQUEST_ID {
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
                videoDetailInfo.directors = removeRepeatActor(content.components(separatedBy: ","))
            }else if currentElement == "isEpisode"{
                videoDetailInfo.chooseDramaFlag = Int(content)!
            }else if currentElement == "episodeOrder"{
                videoDetailInfo.dramaOrderFlag = Int(content)!
            }else if currentElement == "performer"{
                videoDetailInfo.actorString = content
                videoDetailInfo.actors = removeRepeatActor(content.components(separatedBy: ","))
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
        }else if requestId == NetRequestId.recommended_REQUEST_ID || requestId == NetRequestId.search_REQUEST_ID{
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
        }else if requestId == NetRequestId.get_VIDEO_SOURCE_REQUEST_ID{
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if requestId == NetRequestId.video_DETAIL_REQUEST_ID {
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
        }else if requestId == NetRequestId.recommended_REQUEST_ID || requestId == NetRequestId.search_REQUEST_ID{
            if elementName == "video_item" {
                videoBriefItems.append(videoBriefItem)
                videoBriefItem = nil
            }
        }else if requestId == NetRequestId.get_VIDEO_SOURCE_REQUEST_ID{
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
    func parserDidEndDocument(_ parser: XMLParser) {
        currentDepth = 0
        if requestId == NetRequestId.video_DETAIL_REQUEST_ID {
            VideoInfoUtils.refreshWatchRecord(videoDetailInfo)
            posterImg.sd_setImage(with: URL(string: videoDetailInfo.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
            detailView.setData(videoDetailInfo)
            detailView.isHidden = false
            backView.isHidden = true
            divider.isHidden = false
            recommendTab.isHidden = false
            addClick()
            if videoDetailInfo.directors != nil{
                recommends.append(contentsOf: videoDetailInfo.directors)
            }
            if videoDetailInfo.actors != nil {
                recommends.append(contentsOf: videoDetailInfo.actors)
            }
            recommendLoadingView.startAnimat()
            recommendTab.reloadData()
            
            getSourceInfo()
            getRecommendRequest()
        }else if requestId == NetRequestId.recommended_REQUEST_ID || requestId == NetRequestId.search_REQUEST_ID{
            horizontalTab.isHidden = false
            recommendLoadingView.stopAnimat()
            horizontalTab.reloadData()
        }else if requestId == NetRequestId.get_VIDEO_SOURCE_REQUEST_ID{
            videoDetailInfo.currentDrama?.sources = sourceList
            if videoDetailInfo.currentDrama!.hasSource() {
                let item:VideoHistoryItem? = VideoDBHelper.shareInstance.getHistoryItem(videoDetailInfo.id)
                if item != nil {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(VideoInfoUtils.getSourcePositionBySourceId(videoDetailInfo, sourceId: item!.sourceId))
                }else {
                    videoDetailInfo.currentDrama?.setCurrentUsedSourcePosition(0)
                }
            }
        }
    }
    
}



