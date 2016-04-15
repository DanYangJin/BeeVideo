//
//  VideoDetailViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/11.
//  Copyright © 2016年 skyworth. All rights reserved.
//


import UIKit
import Alamofire

class VideoDetailViewController: BaseViewController,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var videoId : String = ""
    var from : String = ""
    
    var currentElement : String!
    var dramas : [Drama]!
    var drama : Drama!
    var currentDepth : Int = 1
    var videoDetailInfo : VideoDetailInfo!
    var recommends : [String] = ["相关推荐"]
    
    private var posterImg : UIImageView!
    private var videoNameLbl : UILabel!
    private var directorNameLbl : UILabel!
    private var cateDetailLbl : UILabel!
    private var publishTimeLbl : UILabel!
    private var areaDetailLbl : UILabel!
    private var durationDetailLbl : UILabel!
    private var actorNameLbl : UILabel!
    private var descDetailLbl : UILabel!
    
    private var playButton : ImageButton!
    private var chooseBtn : ImageButton!
    private var downloadBtn : ImageButton!
    private var faviBtn : ImageButton!
    
    private var recommendTab : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImg = UIImageView()
        posterImg.frame = CGRectMake(30, 20, 120, 180)
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        
        videoNameLbl = UILabel(frame: CGRectMake(160, 20, 418, 16))
        videoNameLbl.text = "我们相爱吧第二季"
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
        setButtonAttr(playButton)
        playButton.setImage(UIImage(named: "v2_video_detail_op_play_bg_normal"), forState: .Normal)
        playButton.setTitle("第1集", forState: .Normal)
        self.view.addSubview(playButton)
        
        chooseBtn = ImageButton(frame: CGRectMake(230, 165, 65, 35))
        setButtonAttr(chooseBtn)
        chooseBtn.setImage(UIImage(named: "v2_video_detail_op_choose_drama_bg_normal"), forState: .Normal)
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
        
        let divider = UIView(frame: CGRectMake(30, 205, 518, 1))
        divider.backgroundColor = UIColor.init(patternImage: UIImage(named: "v2_video_detail_divider_bg")!)
        self.view.addSubview(divider)
        
        initTableView()
        
        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/video_detail_info.action?videoId=2554").response{ request, response, data, error in
            if error != nil {
                print(error)
                return
            }
            let parse = NSXMLParser(data: data!)
            parse.delegate = self
            parse.parse()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElement = elementName;
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
    }
    
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if currentElement == nil {
            return
        }
        if content.isEmpty {
            return
        }
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
            for ss in videoDetailInfo.directors {
                print(ss)
            }
        }else if currentElement == "isEpisode"{
            videoDetailInfo.chooseDramaFlag = Int(content)!
        }else if currentElement == "episodeOrder"{
            videoDetailInfo.dramaOrderFlag = Int(content)!
        }else if currentElement == "performer"{
            videoDetailInfo.actorString = content
            videoDetailInfo.actors = removeRepeatActor(content.componentsSeparatedByString(","))
//            for ss in videoDetailInfo.actors{
//                print(ss)
//            }
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
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
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
        
        currentElement = nil
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        print(videoDetailInfo.poster)
        posterImg.sd_setImageWithURL(NSURL(string: videoDetailInfo.poster))
        videoNameLbl.text = videoDetailInfo.name
        directorNameLbl.text = videoDetailInfo.directorString
        cateDetailLbl.text = videoDetailInfo.category
        areaDetailLbl.text = videoDetailInfo.area
        publishTimeLbl.text = videoDetailInfo.publishTime
        durationDetailLbl.text = videoDetailInfo.duration
        actorNameLbl.text = videoDetailInfo.actorString
        descDetailLbl.text = videoDetailInfo.desc
        recommends.appendContentsOf(videoDetailInfo.directors)
        recommends.appendContentsOf(videoDetailInfo.actors)
        recommendTab.reloadData()
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
        cell?.backgroundColor = UIColor.clearColor()
        //cell?.selectionStyle = .None
        cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        
        return  cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("click at \(indexPath.row)")
        
        let nums = recommends.count
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        for num in 0..<nums {
            if num == indexPath.row {
                cell?.textLabel?.layer.borderColor = UIColor.whiteColor().CGColor
                cell?.textLabel?.layer.borderWidth = 1
                cell?.textLabel?.layer.cornerRadius = 5
            }else{
                cell?.textLabel?.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }
    
    
    func judgeStatus(status:String) -> Bool{
        let ret : Int = Int(status)!
        if ret == 1 {
            return true
        }
        return false
    }
    
    func initTableView(){
        recommendTab = UITableView(frame: CGRectMake(10, 210, 90, 110), style: .Plain)
        recommendTab.delegate = self
        recommendTab.dataSource = self
        recommendTab.backgroundColor = UIColor.redColor()
        recommendTab.showsVerticalScrollIndicator = false
       // recommendTab.separatorStyle = .None
        self.view.addSubview(recommendTab)
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
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
    }
    
    
}

