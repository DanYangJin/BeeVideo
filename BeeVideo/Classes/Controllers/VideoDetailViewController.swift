//
//  VideoDetailViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/11.
//  Copyright © 2016年 skyworth. All rights reserved.
//


import UIKit
import Alamofire

class VideoDetailViewController: BaseViewController,NSXMLParserDelegate {
    
    var videoId : String = ""
    var from : String = ""
    
    var currentElement : String!
    var dramas : [Drama]!
    var drama : Drama!
    var currentDepth : Int = 1
    
    private var posterImg : UIImageView!
    private var videoNameLbl : UILabel!
    var videoDetailInfo : VideoDetailInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImg = UIImageView()
        posterImg.frame = CGRectMake(30, 20, 100, 160)
        posterImg.image = UIImage(named: "dog")
        posterImg.layer.cornerRadius = 10
        posterImg.layer.masksToBounds = true
        self.view.addSubview(posterImg)
        
        videoNameLbl = UILabel(frame: CGRectMake(140, 20, 438, 16))
        videoNameLbl.text = "我们相爱吧第二季"
        videoNameLbl.textColor = UIColor.whiteColor()
        self.view.addSubview(videoNameLbl)
        
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
        }else if currentElement == "isEpisode"{
            videoDetailInfo.chooseDramaFlag = Int(content)!
        }else if currentElement == "episodeOrder"{
            videoDetailInfo.dramaOrderFlag = Int(content)!
        }else if currentElement == "performer"{
            videoDetailInfo.actorString = content
            videoDetailInfo.actors = removeRepeatActor(content.componentsSeparatedByString(","))
            for ss in videoDetailInfo.actors{
                print(ss)
            }
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
    }
    
    
    func judgeStatus(status:String) -> Bool{
        let ret : Int = Int(status)!
        if ret == 1 {
            return true
        }
        return false
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
    
    
    
}

