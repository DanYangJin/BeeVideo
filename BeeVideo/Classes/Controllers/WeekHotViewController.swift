//
//  WeekHotViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/30.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class WeekHotViewController: BaseHorizontalViewController,NSXMLParserDelegate,ZXOptionBarDelegate,ZXOptionBarDataSource,UITableViewDelegate,UITableViewDataSource {
    
    private var mOptionBar : ZXOptionBar!
    private var menuTable : UITableView!
    
    private var channels:Array<WeekChannel> = Array<WeekChannel>()
    private var infoItems:Array<VideoDetailInfo>!
    private var channel:WeekChannel!
    private var videoDetailInfo:VideoDetailInfo!
    
    private let leftMenu = DataFactory.weekHotItems
    private var lastPosition:Int = 0

    override func viewDidLoad() {
        leftWidth = Float(view.frame.width * 0.2)
        super.viewDidLoad()
        
        titleLbl.text = "周热播榜"
        
        mOptionBar = ZXOptionBar(frame: CGRectZero, barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clearColor()
        mOptionBar.setDividerWidth(dividerWidth: 10)
        self.contentView.addSubview(mOptionBar)
        mOptionBar.snp_makeConstraints { (make) in
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(3)
        }
        
        menuTable = UITableView()
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.backgroundColor = UIColor.clearColor()
        menuTable.separatorStyle = .None
        menuTable.scrollEnabled = false
        menuTable.registerClass(LeftViewCell.self, forCellReuseIdentifier: "weekHotCell")
        self.leftView.addSubview(menuTable)
        menuTable.selectRowAtIndexPath(NSIndexPath(forRow: 0,inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        menuTable.snp_makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.equalTo(leftView.snp_bottom).multipliedBy(0.2)
            make.bottom.equalTo(leftView)
        }
        
        loadingView = LoadingView()
        self.contentView.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(mOptionBar)
            make.height.width.equalTo(50)
        }
        loadingView.startAnimat()
        
        getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //xml解析
    private var currentElement = ""
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video_item" {
            videoDetailInfo = VideoDetailInfo()
        }else if currentElement == "video_list"{
            infoItems = Array<VideoDetailInfo>()
        }else if currentElement == "channel"{
            channel = WeekChannel()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if currentElement == "channelName" {
            channel.channelName = content
        }else if currentElement == "id"{
            videoDetailInfo.id = content
        }else if currentElement == "item_name"{
            videoDetailInfo.name = content
        }else if currentElement == "duration"{
            videoDetailInfo.duration = content
        }else if currentElement == "smallImg"{
            videoDetailInfo.poster = content
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "video_item"{
            infoItems.append(videoDetailInfo)
            videoDetailInfo = nil
        }else if elementName == "video_list"{
            channel.videoItem = infoItems
            infoItems = nil
        }else if elementName == "channel"{
            channels.append(channel)
            channel = nil
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        subTitleLbl.text = "\(channels[lastPosition].channelName) 共\(channels[lastPosition].videoItem.count)部"
        mOptionBar.reloadData()
        loadingView.hidden = true
        loadingView.stopAnimat()
    }
    
    //uitable datasource,delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "weekHotCell"
        let cell : LeftViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath:  indexPath) as? LeftViewCell
        
        cell?.setViewData(leftMenu[indexPath.row])
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenu.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if lastPosition == indexPath.row {
            return
        }
        lastPosition = indexPath.row
         mOptionBar.reloadData()
        
        if channels.isEmpty {
            return
        }
        
        subTitleLbl.text = "\(channels[indexPath.row].channelName) 共\(channels[indexPath.row].videoItem.count)部"
        
       
    }
    
    //optionbarDataSource,delegate
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        if channels.isEmpty {
            return 0
        }
        return channels[lastPosition].videoItem.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        var cell:BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier("weekOpt") as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: "weekOpt")
        }
        if channels.count != 0{
            let viewDetail = channels[lastPosition].videoItem[index]
            cell?.averageLbl.hidden = true
            cell?.icon.sd_setImageWithURL(NSURL(string:viewDetail.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
            cell?.videoNameLbl.text = viewDetail.name
            cell?.durationLbl.text = viewDetail.duration
        }
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(self.view.frame.height/3 * 5/7)
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let detailController = VideoDetailViewController()
        let videoId = channels[lastPosition].videoItem[index].id
        var extras = Array<ExtraData>()
        extras.append(ExtraData(name: "", value: videoId))
        detailController.extras = extras
        self.presentViewController(detailController, animated: true, completion: nil)
    }
    
    
    private func getData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_WEEK_HOT)!, parameters: nil).response{
            _,_,data,error in
            if error != nil {
                print(error)
                return
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
}
