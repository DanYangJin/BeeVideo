//
//  VideoHDCategoryController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 高清专区
 
 */

import Alamofire

class VideoHDCategoryController: BaseViewController,NSXMLParserDelegate,ZXOptionBarDelegate,ZXOptionBarDataSource {
    
    private var backBtn : UIButton!
    private var mOptionBar : ZXOptionBar!
    
    private var mBackgroundUrl : String = ""
    private var mDataList : [VideoBriefItem] = [VideoBriefItem]()
    private var mVideoBriefItem : VideoBriefItem!
    
    private var currentElement = ""
    
    var extras : [ExtraData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_HD_VIDEO)!).response{ request,_,data,error in
            if (error != nil) {
                print(error)
                return
            }
            print(request?.URLString)
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
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(30)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video_item" {
            mVideoBriefItem = VideoBriefItem()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if currentElement == "picBackgroundUrl" {
            mBackgroundUrl = content
        }else if currentElement == "id" {
            mVideoBriefItem.id = content
        }else if currentElement == "name"{
            mVideoBriefItem.name = content
        }else if currentElement == "channelId"{
            mVideoBriefItem.channelId = content
        }else if currentElement == "channel"{
            mVideoBriefItem.channel = content
        }else if currentElement == "duration"{
            mVideoBriefItem.duration = content
        }else if currentElement == "smallImg"{
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
        if elementName == "video_item" {
            mDataList.append(mVideoBriefItem)
            mVideoBriefItem = nil
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.setBackgroundImg(mBackgroundUrl)
        mOptionBar.reloadData()
        loadingView.stopAnimat()
    }
    
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return mDataList.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "optionCell"
        
        var cell : VideoCategoryCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? VideoCategoryCell
        if cell == nil {
            cell = VideoCategoryCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
            cell?.itemView.setFlagHidden(false)
        }
        
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
