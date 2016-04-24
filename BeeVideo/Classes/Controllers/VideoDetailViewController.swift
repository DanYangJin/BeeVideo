//
//  VideoDetailViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/11.
//  Copyright © 2016年 skyworth. All rights reserved.
//


import UIKit
import Alamofire

class VideoDetailViewController: BaseViewController,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource, ZXOptionBarDelegate, ZXOptionBarDataSource {
    
    enum NetRequestId{
        case VIDEO_DETAIL_REQUEST_ID
        case RECOMMENDED_REQUEST_ID
        case SEARCH_REQUEST_ID
    }
    
    //上一层页面传递的参数
    var extras:[ExtraData]!
    
    var videoId : String = "2554"
    var from : String = ""
    var height : CGFloat!
    var width : CGFloat!
    
    var currentElement : String! //xml节点名字
    var dramas : [Drama]!
    var drama : Drama!
    var currentDepth : Int = 1 //解析xml文件的节点层数
    var videoDetailInfo : VideoDetailInfo!
    var recommends : [String] = ["相关推荐"]
    var requestId : NetRequestId!
    var videoBriefItems : [VideoBriefItem] = Array()
    var videoBriefItem : VideoBriefItem!
    var params : Dictionary<String,String>!
    
    private var posterImg : UIImageView!
//    private var videoNameLbl : UILabel!
//    private var directorNameLbl : UILabel!
//    private var cateDetailLbl : UILabel!
//    private var publishTimeLbl : UILabel!
//    private var areaDetailLbl : UILabel!
//    private var durationDetailLbl : UILabel!
//    private var actorNameLbl : UILabel!
//    private var descDetailLbl : UILabel!
    private var divider : UIView!
    private var detailView : VideoDetailInfoView!
//
//    private var playButton : ImageButton!
//    private var chooseBtn : ImageButton!
//    private var downloadBtn : ImageButton!
//    private var faviBtn : ImageButton!
//    private var backBtn : UIButton!
    
    private var recommendTab : UITableView!
    private var horizontalTab : ZXOptionBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoId = extras[0].value
        height = self.view.frame.height
        width = self.view.frame.width
        
        posterImg = UIImageView()
        //posterImg.frame = CGRectMake(30, 20, 120, 180)
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        
        detailView = VideoDetailInfoView(frame: CGRectMake(0, 0, width - (height * 2/3 - 30) * 2/3 - 50, height * 2/3 - 30))
        self.view.addSubview(detailView)
        
        divider = UIView()//frame: CGRectMake(30, 205, 518, 1))
        divider.backgroundColor = UIColor.init(patternImage: UIImage(named: "v2_video_detail_divider_bg")!)
        self.view.addSubview(divider)
        
        posterImg.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.bottom.equalTo(divider.snp_top).offset(-10)
            make.top.equalTo(self.view).offset(20)
            make.width.equalTo((height * 2/3 - 30) * 2/3)
            print(posterImg.frame.height)
        }
        
        divider.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(view).offset(height * 2/3)
            make.height.equalTo(1)
        }
        
        detailView.snp_makeConstraints { (make) in
            make.left.equalTo(divider)
            make.right.equalTo(posterImg.snp_left).offset(-10)
            make.top.equalTo(posterImg)
            make.bottom.equalTo(posterImg)
        }
       // initBaseView()
        initTableView()
        initOptionBar()

        getVideoDetailRequest()
        //getRecommendRequest()
        
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
        }
        
        currentElement = nil
    }
    
    //结束解析
    func parserDidEndDocument(parser: NSXMLParser) {
        if requestId == NetRequestId.VIDEO_DETAIL_REQUEST_ID {
            posterImg.sd_setImageWithURL(NSURL(string: videoDetailInfo.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
//            videoNameLbl.text = videoDetailInfo.name
//            directorNameLbl.text = videoDetailInfo.directorString
//            cateDetailLbl.text = videoDetailInfo.category
//            areaDetailLbl.text = videoDetailInfo.area
//            publishTimeLbl.text = videoDetailInfo.publishTime
//            durationDetailLbl.text = videoDetailInfo.duration
//            actorNameLbl.text = videoDetailInfo.actorString
//            descDetailLbl.text = videoDetailInfo.desc
            detailView.setData(videoDetailInfo)
            addClick()
            if videoDetailInfo.directors != nil{
                recommends.appendContentsOf(videoDetailInfo.directors)
            }
            if videoDetailInfo.actors != nil {
                recommends.appendContentsOf(videoDetailInfo.actors)
            }
            recommendTab.reloadData()
            getRecommendRequest()
        }else if requestId == NetRequestId.RECOMMENDED_REQUEST_ID || requestId == NetRequestId.SEARCH_REQUEST_ID{
            
            if horizontalTab != nil {
                horizontalTab.removeFromSuperview()
            }
            initOptionBar()
            //horizontalTab.contentOffset = CGPoint(x: 0, y: 0)
            horizontalTab.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
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
            cell?.textLabel?.textColor = UIColor.blueColor()
        }
        
        return  cell!
    }
    
    var lastPosition = 0 //记录上一次所点的位置
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPosition, inSection: 0))
        lastCell?.textLabel?.textColor = UIColor.whiteColor()
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        currentCell?.textLabel?.textColor = UIColor.blueColor()
        
        lastPosition = indexPath.row
        
        let index = indexPath.row
        
        if index == 0 {
            getRecommendRequest()
        }else{
            getRecommendByActorRequest(recommends[index], type: "1")
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
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
            cell?.averageLbl.text = videoBriefItems[index].score
        }
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(recommendTab.frame.height * 3/4)
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
    
    /*
    func initBaseView(){
        
        posterImg = UIImageView()
        //posterImg.frame = CGRectMake(30, 20, 120, 180)
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        posterImg.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(120)
            make.top.equalTo(self.view).offset(20)
            make.height.equalTo(180)
        }
        
        backBtn = UIButton(frame: CGRectMake(5, 5, 20, 20))
        backBtn.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        backBtn.addTarget(self, action: (#selector(VideoDetailViewController.dissMissController)), forControlEvents: .TouchUpInside)
        self.view.addSubview(backBtn)
        
        videoNameLbl = UILabel(frame: CGRectMake(160, 20, 418, 16))
        //videoNameLbl.text = "我们相爱吧第二季"
        videoNameLbl.textColor = UIColor.whiteColor()
        self.view.addSubview(videoNameLbl)
        
        let directorLbl = UILabel(frame: CGRectMake(160, 46, 30, 12))
        setCommenAttr(directorLbl)
        directorLbl.text = "导演:"
        self.view.addSubview(directorLbl)
        
        directorNameLbl = UILabel(frame: CGRectMake(191, 46, 105, 12))
        setCommenAttr(directorNameLbl)
        self.view.addSubview(directorNameLbl)
        
        let cateLbl = UILabel(frame: CGRectMake(297, 46, 30, 12))
        setCommenAttr(cateLbl)
        cateLbl.text = "类型:"
        self.view.addSubview(cateLbl)
        
        cateDetailLbl = UILabel(frame: CGRectMake(328, 46, 105, 12))
        setCommenAttr(cateDetailLbl)
        self.view.addSubview(cateDetailLbl)
        
        let areaLbl = UILabel(frame: CGRectMake(434, 46, 30, 12))
        setCommenAttr(areaLbl)
        areaLbl.text = "地区:"
        self.view.addSubview(areaLbl)
        
        areaDetailLbl = UILabel(frame: CGRectMake(465, 46, 105, 12))
        setCommenAttr(areaDetailLbl)
        self.view.addSubview(areaDetailLbl)
        
        let timeLbl = UILabel(frame: CGRectMake(160, 64, 30, 12))
        setCommenAttr(timeLbl)
        timeLbl.text = "年代:"
        self.view.addSubview(timeLbl)
        
        publishTimeLbl = UILabel(frame: CGRectMake(191, 64, 105, 12))
        setCommenAttr(publishTimeLbl)
        self.view.addSubview(publishTimeLbl)
        
        let durationLbl = UILabel(frame: CGRectMake(297, 64, 30, 12))
        setCommenAttr(durationLbl)
        durationLbl.text = "时长:"
        self.view.addSubview(durationLbl)
        
        durationDetailLbl = UILabel(frame: CGRectMake(328, 64, 105, 12))
        setCommenAttr(durationDetailLbl)
        durationDetailLbl.textColor = UIColor.orangeColor()
        self.view.addSubview(durationDetailLbl)
        
        let actorLbl = UILabel(frame: CGRectMake(160, 84, 30, 12))
        setCommenAttr(actorLbl)
        actorLbl.text = "演员:"
        self.view.addSubview(actorLbl)
        
        actorNameLbl = UILabel(frame: CGRectMake(191, 84, 357, 12))
        setCommenAttr(actorNameLbl)
        actorNameLbl.lineBreakMode = .ByTruncatingTail
        self.view.addSubview(actorNameLbl)
        
        let descLbl = UILabel(frame: CGRectMake(160, 104, 55, 12))
        setCommenAttr(descLbl)
        descLbl.text = "剧情介绍:"
        self.view.addSubview(descLbl)
        
        descDetailLbl = UILabel(frame: CGRectMake(160, 116, 388, 44))
        descDetailLbl.numberOfLines = 3
        descDetailLbl.lineBreakMode = .ByTruncatingTail
        setCommenAttr(descDetailLbl)
        self.view.addSubview(descDetailLbl)
        
        playButton = ImageButton(frame: CGRectMake(160, 165, 65, 35))
        //setButtonAttr(playButton)
//        playButton.layer.cornerRadius = 8
//        playButton.layer.borderWidth = 0.5
//        playButton.layer.borderColor = UIColor.whiteColor().CGColor
      //  playButton.backgroundColor = UIColor(patternImage: UIImage(named: "v2_block_home_cycle_show_bg")!)
        playButton.setImage("v2_video_detail_op_play_bg_normal")
        playButton.setTitle("第1集")
        playButton.addOnClickListener(self, action: (#selector(VideoDetailViewController.toPlayController)))
//        playButton.addTarget(self, action: (#selector(VideoDetailViewController.toPlayController)), forControlEvents: .TouchUpInside)
        self.view.addSubview(playButton)
        
//        chooseBtn = ImageButton(frame: CGRectMake(230, 165, 65, 35))
//        setButtonAttr(chooseBtn)
//        chooseBtn.setImage(UIImage(named: "v2_video_detail_op_choose_drama_bg_normal"), forState: .Normal)
        chooseBtn.setTitle("选集", forState: .Normal)
        self.view.addSubview(chooseBtn)
        
        downloadBtn = ImageButton(frame: CGRectMake(300, 165, 65, 35))
        setButtonAttr(downloadBtn)
        downloadBtn.setImage(UIImage(named: "v2_my_video_download_bg_normal"), forState: .Normal)
        downloadBtn.setTitle("下载", forState: .Normal)
        self.view.addSubview(downloadBtn)
        
        faviBtn = ImageButton(frame: CGRectMake(370, 165, 65, 35))
        setButtonAttr(faviBtn)
        faviBtn.setImage(UIImage(named: "vod_menu_fav"), forState: .Normal)
        faviBtn.setTitle("收藏", forState: .Normal)
        self.view.addSubview(faviBtn)
     
     
     divider = UIView()//frame: CGRectMake(30, 205, 518, 1))
     divider.backgroundColor = UIColor.init(patternImage: UIImage(named: "v2_video_detail_divider_bg")!)
     self.view.addSubview(divider)
     
     
        divider.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(view).offset(view.frame.height * 2/3)
            make.height.equalTo(1)
        }
        
    }
 */
    
    func getVideoDetailRequest(){
        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/video_detail_info.action", parameters: ["videoId": extras[0].value]).response{ request, response, data, error in
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
    
    func getRecommendRequest(){
        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/video_relate.action?videoId=\(videoId)").response{ request, response, data, error in
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
    
    func getRecommendByActorRequest(searchKey:String, type:String){
        let params = ["searchKey" : searchKey, "type" : type]
        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/video_search.action", parameters: params).response{ request, response, data, error in
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
    
    
    //初始化推荐名字列表
    func initTableView(){
        recommendTab = UITableView()//frame: CGRectMake(10, 210, 90, 110), style: .Plain)
        recommendTab.delegate = self
        recommendTab.dataSource = self
        recommendTab.backgroundColor = UIColor.clearColor()
        recommendTab.showsVerticalScrollIndicator = false
        recommendTab.separatorStyle = .None
        self.view.addSubview(recommendTab)
        
        recommendTab.snp_makeConstraints { (make) in
            make.top.equalTo(divider).offset(5)
            make.bottom.equalTo(view).offset(-5)
            make.left.equalTo(self.view).offset(20)
            make.width.equalTo(90)
        }
    }
    
    // 初始化横向TableView
    func initOptionBar(){
        let height = recommendTab.frame.height
        horizontalTab = ZXOptionBar(frame: CGRectMake(0, 0, recommendTab.frame.height * 3/4, height), barDelegate: self, barDataSource: self)
        horizontalTab.backgroundColor = UIColor.clearColor()
        self.view.addSubview(horizontalTab)
        
        horizontalTab.snp_makeConstraints { (make) in
//            make.left.equalTo(recommendTab).offset(recommendTab.frame.width + 10)
            make.leading.equalTo(recommendTab.snp_trailing)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(recommendTab)
            make.bottom.equalTo(recommendTab)
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
    
    func addClick(){
        detailView.playBtn.addOnClickListener(self, action: (#selector(self.toPlayController)))
        detailView.backBtn.addOnClickListener(self, action: (#selector(self.dissMissController)))
    }
    
    //播放按钮点击事件
    func  toPlayController(){
        let viewController:PlayerViewController = PlayerViewController()
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func dissMissController(){
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    
}

