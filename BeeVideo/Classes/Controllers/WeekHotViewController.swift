//
//  WeekHotViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/30.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class WeekHotViewController: BaseHorizontalViewController,ZXOptionBarDelegate,ZXOptionBarDataSource,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate var mOptionBar : ZXOptionBar!
    fileprivate var menuTable : UITableView!
    
    fileprivate var channels:Array<WeekChannel> = Array<WeekChannel>()
    fileprivate var infoItems:Array<VideoDetailInfo>!
    fileprivate var channel:WeekChannel!
    fileprivate var videoDetailInfo:VideoDetailInfo!
    
    fileprivate let leftMenu = DataFactory.weekHotItems
    fileprivate var lastPosition:Int = 0
    
    //xml解析
    fileprivate var currentElement = ""
    
    override func viewDidLoad() {
        leftWidth = Float(view.frame.width * 0.2)
        super.viewDidLoad()
        
        initUI()
        
        getData()
        
    }
    
    func initUI(){
        titleLbl.text = "周热播榜"
        
        mOptionBar = ZXOptionBar(frame: CGRect.zero, barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clear
        mOptionBar.setDividerWidth(dividerWidth: 10)
        self.contentView.addSubview(mOptionBar)
        mOptionBar.snp.makeConstraints { (make) in
            make.left.equalTo(strinkView.snp.right)
            make.width.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).dividedBy(3)
        }
        
        menuTable = UITableView()
        menuTable.dataSource = self
        menuTable.delegate = self
        menuTable.backgroundColor = UIColor.clear
        menuTable.separatorStyle = .none
        menuTable.isScrollEnabled = false
        menuTable.register(LeftViewCell.self, forCellReuseIdentifier: "weekHotCell")
        self.leftView.addSubview(menuTable)
        menuTable.selectRow(at: IndexPath(row: 0,section: 0), animated: false, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        menuTable.snp.makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.equalTo(leftView.snp.bottom).multipliedBy(0.2)
            make.bottom.equalTo(leftView)
        }
        
        loadingView = LoadingView()
        self.contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(mOptionBar)
            make.height.width.equalTo(50)
        }
        loadingView.startAnimat()
        
        errorView = ErrorView()
        errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
        errorView.isHidden = true
        self.contentView.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(mOptionBar)
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //uitable datasource,delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "weekHotCell"
        let cell : LeftViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId,for:  indexPath) as? LeftViewCell
        
        cell?.setViewData(leftMenu[(indexPath as NSIndexPath).row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if lastPosition == (indexPath as NSIndexPath).row {
            return
        }
        lastPosition = (indexPath as NSIndexPath).row
        mOptionBar.reloadData()
        
        if channels.isEmpty {
            return
        }
        
        subTitleLbl.text = "\(channels[(indexPath as NSIndexPath).row].channelName) 共\(channels[(indexPath as NSIndexPath).row].videoItem.count)部"
    }
    
    //optionbarDataSource,delegate
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        if channels.isEmpty {
            return 0
        }
        return channels[lastPosition].videoItem.count
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        var cell:BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier("weekOpt") as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: "weekOpt")
        }
        if channels.count != 0{
            let viewDetail = channels[lastPosition].videoItem[index]
            cell?.averageLbl.isHidden = true
            cell?.icon.sd_setImage(with: URL(string:viewDetail.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
            cell?.videoNameLbl.text = viewDetail.name
            cell?.durationLbl.text = viewDetail.duration
        }
        
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(self.view.frame.height/3 * 5/7)
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let detailController = VideoDetailViewController()
        let videoId = channels[lastPosition].videoItem[index].id
        var extras = Array<ExtraData>()
        extras.append(ExtraData(name: "", value: videoId!))
        detailController.extras = extras
        self.present(detailController, animated: true, completion: nil)
    }
    
    
    fileprivate func getData(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_WEEK_HOT)!).responseData { (response) in
            switch response.result{
            case .failure(_):
                self.loadingView.stopAnimat()
                self.errorView.isHidden = false
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }
    }
}



/*
 xml解析
 */
extension WeekHotViewController:XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video_item" {
            videoDetailInfo = VideoDetailInfo()
        }else if currentElement == "video_list"{
            infoItems = Array<VideoDetailInfo>()
        }else if currentElement == "channel"{
            channel = WeekChannel()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
            videoDetailInfo.duration += content
        }else if currentElement == "smallImg"{
            videoDetailInfo.poster = content
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        subTitleLbl.text = "\(channels[lastPosition].channelName) 共\(channels[lastPosition].videoItem.count)部"
        mOptionBar.reloadData()
        loadingView.isHidden = true
        loadingView.stopAnimat()
    }
    
    
}

