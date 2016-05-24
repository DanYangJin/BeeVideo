//
//  VideoCategoryController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryController: BaseViewController,NSXMLParserDelegate,ZXOptionBarDelegate,ZXOptionBarDataSource {
    
    private var backBtn : UIButton!
    private var mOptionBar : ZXOptionBar!
    
    private var mBackgroundUrl : String = ""
    private var mDataList : Array<VideoBriefItem>!
    private var mVideoBriefItem : VideoBriefItem!
    
    private var currentElement : String!
    
    var extras : [ExtraData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryId = extras[0].value
        mDataList = Array<VideoBriefItem>()

        initView()
        
        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/subject_videos.action", parameters: ["subjectId":categoryId]).response{ _,_,data,error in
            if (error != nil) {
                print(error)
                return
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    private func initView(){
        backBtn = UIButton()
        backBtn.setImage(UIImage(named: "play_back_full"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(self.dismissViewController), forControlEvents: .TouchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(30)
            make.height.width.equalTo(30)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 1/3), barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clearColor()
        mOptionBar.setDividerWidth(dividerWidth: 20)
        self.view.addSubview(mOptionBar)
        mOptionBar.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottom).inset(30)
            make.height.equalTo(self.view.frame.height * 1/3)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video" {
            mVideoBriefItem = VideoBriefItem()
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
        if currentElement == "picBackgroundUrl" {
            mBackgroundUrl = content
        }else if currentElement == "id" {
            mVideoBriefItem.id = content
        }else if currentElement == "name"{
            mVideoBriefItem.name = content
        }else if currentElement == "channel"{
            mVideoBriefItem.channelId = content
        }else if currentElement == "channelName"{
            mVideoBriefItem.channel = content
        }else if currentElement == "duration"{
            mVideoBriefItem.duration = content
        }else if currentElement == "picUrl"{
            mVideoBriefItem.posterImg = content
        }else if currentElement == "most"{
            mVideoBriefItem.resolutionType = Int(content)
        }else if currentElement == "doubanId"{
            mVideoBriefItem.doubanId = content
        }else if currentElement == "doubanAverage"{
            mVideoBriefItem.score = content
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "video" {
            mDataList.append(mVideoBriefItem)
            mVideoBriefItem = nil
        }
        currentElement = nil
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        print(mBackgroundUrl)
        self.setBackgroundImg(mBackgroundUrl)
        mOptionBar.reloadData()
    }
    
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return mDataList.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "optionCell"
//        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
//        if cell == nil {
//            cell = BaseTableViewCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
//        }
//        cell?.backgroundColor = UIColor.clearColor()
//        cell?.videoNameLbl.text = mDataList[index].name
//        cell?.icon.sd_setImageWithURL(NSURL(string: mDataList[index].posterImg),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
//        cell?.durationLbl.text = mDataList[index].duration
//        let average = mDataList[index].score
//        if average.isEmpty {
//            cell?.averageLbl.hidden = true
//        }else{
//            cell?.averageLbl.hidden = false
//            cell?.averageLbl.text = average
//        }
        
        var cell : VideoCategoryCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? VideoCategoryCell
        if cell == nil {
            cell = VideoCategoryCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
//        let average = mDataList[index].score
//        if average.isEmpty {
//            cell?.itemView.averageLbl.hidden = true
//        }else{
//            cell?.itemView.averageLbl.hidden = false
//            cell?.itemView.averageLbl.text = mDataList[index].score
//        }
//        let itemData = mDataList[index]
//        cell?.itemView.poster.sd_setImageWithURL(NSURL(string: itemData.posterImg),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
//        cell?.itemView.nameLbl.text = itemData.name
//        cell?.itemView.durationLbl.text = itemData.duration
        
        cell?.itemView.setData(mDataList[index])
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(self.view.frame.height) * 1/3 * 5/7
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let videoId = mDataList[index].id
        //print(videoId)
        var extras = [ExtraData]()
        let data = ExtraData()
        data.value = videoId
        extras.append(data)
        let detailViewController = VideoDetailViewController()
        detailViewController.extras = extras
        self.presentViewController(detailViewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
