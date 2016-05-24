//
//  VodVideoController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VodVideoController: BaseViewController,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private enum NetRequestId{
        case VIDEO_CATEGORY_REQUEST
        case VIDEO_VIDEO_LIST_REQUEST
    }
    
    private var requestId : NetRequestId!
    
    var channelId : String! // 外部传入
    
    //xml解析相关
    private var vodCategory : VodCategory!
    private var vodCategoryGather : VodCategoryGather = VodCategoryGather()//左边列表数据源
    private var vodCategoryList : Array<VodCategory>!
    private var currentElement : String = ""
    private var videoPageData : VodVideoPageData = VodVideoPageData()
    private var videoList : Array<VideoBriefItem>!
    private var videoItem : VideoBriefItem!
    private var pageNum : Int = 1
    private var maxPage : Int = 0
    
    private var leftView : UIView!
    private var categoryTable : UITableView!
    private var videoCollection : UICollectionView!
    private var topArrow : UIImageView!
    private var bottomArrow : UIImageView!
    private var strinkView : UIImageView!
    private var backImg : UIImageView!
    private var titleLbl : UILabel!
    private var countLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftView = UIView()
        self.view.addSubview(leftView)
        leftView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.2)
            //make.width.equalTo(0)
        }
        
        let bckImg = UIImageView()
        bckImg.contentMode = .ScaleToFill
        bckImg.image = UIImage(named: "v2_search_keyboard_background.9")
        leftView.addSubview(bckImg)
        bckImg.snp_makeConstraints { (make) in
            make.right.left.equalTo(leftView)
            make.top.bottom.equalTo(leftView)
        }
        
        topArrow = UIImageView()
        topArrow.image = UIImage(named: "v2_vod_list_arrow_top")
        topArrow.contentMode = .ScaleAspectFill
        leftView.addSubview(topArrow)
        topArrow.snp_makeConstraints { (make) in
//            make.left.equalTo(leftView)
//            make.top.equalTo(leftView)
//            make.right.equalTo(leftView)
//            make.height.equalTo(leftView).dividedBy(9)
            make.centerX.equalTo(leftView)
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.topMargin.equalTo(20)
        }
        
        bottomArrow = UIImageView()
        bottomArrow.image = UIImage(named: "v2_vod_list_arrow_bottom")
        bottomArrow.contentMode = .ScaleAspectFill
        leftView.addSubview(bottomArrow)
        bottomArrow.snp_makeConstraints { (make) in
            make.bottom.equalTo(leftView).offset(-20)
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.centerX.equalTo(leftView)
        }
        
        categoryTable = UITableView()
        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.showsVerticalScrollIndicator = false
        categoryTable.backgroundColor = UIColor.clearColor()
        categoryTable.separatorStyle = .None
        self.leftView.addSubview(categoryTable)
        categoryTable.snp_makeConstraints { (make) in
            make.top.equalTo(topArrow.snp_bottom).offset(10)
            make.left.equalTo(leftView)
            make.bottom.equalTo(bottomArrow.snp_top).offset(-10)
            make.width.equalTo(leftView)
        }
        
        strinkView = UIImageView()
        strinkView.contentMode = .ScaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        self.view.addSubview(strinkView)
        strinkView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.height.equalTo(20)
            make.left.equalTo(leftView.snp_right)
            make.width.equalTo(20)
        }
        
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .ScaleAspectFill
        self.view.addSubview(backImg)
        backImg.addOnClickListener(self, action: #selector(self.dismissViewController))
        backImg.snp_makeConstraints { (make) in
            make.left.equalTo(strinkView.snp_right)
            make.topMargin.equalTo(30)
            make.height.equalTo(20)
            make.width.equalTo(10)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLbl)
        //titleLbl.text = "经典武侠"
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backImg.snp_right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.backgroundColor = UIColor(patternImage: UIImage(named: "v2_vod_page_size_bg.9")!)
        countLbl.textColor = UIColor.whiteColor()
        countLbl.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(countLbl)
        countLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp_right).offset(5)
        }
        
        initCollectionView()
        
        getVideoCategoryData()
        
    }
    
    private func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.view.frame.height - 80 - (self.view.frame.width - 80)/6 * 14/5
        videoCollection = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), collectionViewLayout: layout)
        videoCollection.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "collection")
        videoCollection.dataSource = self
        videoCollection.delegate = self
        videoCollection.backgroundColor = UIColor.clearColor()
        self.view.addSubview(videoCollection)
        videoCollection.snp_makeConstraints { (make) in
            make.top.equalTo(backImg.snp_bottom).offset(20)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(self.view).offset(-20)
        }
    }
    
    //tableview相关
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vodCategoryGather.vodCategoryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "tableCell"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
        }
        
        cell?.textLabel?.text = vodCategoryGather.vodCategoryList[indexPath.row].name
        cell?.textLabel?.textColor = UIColor.whiteColor()
        
        return cell!
    }
    
    private var lastPosition = 4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if lastPosition == indexPath.row {
            return
        }
        
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPosition, inSection: 0))
        lastCell?.textLabel?.textColor = UIColor.whiteColor()
        let cuttentCell = tableView.cellForRowAtIndexPath(indexPath)
        cuttentCell?.textLabel?.textColor = UIColor.blueColor()
        lastPosition = indexPath.row
        
        titleLbl.text = vodCategoryGather.vodCategoryList[indexPath.row].title
    
        SDImageCache.sharedImageCache().clearDisk()
        videoCollection.removeFromSuperview()
        videoCollection = nil
        initCollectionView()
        videoPageData.videoList.removeAll()
        getVideoListData(configParams(vodCategoryGather, index: indexPath.row))
        
    }
    
    //collectionview相关
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoPageData.videoList.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : VideoItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("collection", forIndexPath: indexPath) as! VideoItemCell
        cell.itemView.setData(videoPageData.videoList[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let viewWidth = self.view.frame.width
        let width = (viewWidth - 80)/6
        let height = width * 7/5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 10)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == videoPageData.videoList.count - 1{
            if pageNum < maxPage {
                pageNum += 1
                getVideoListData(configParams(vodCategoryGather, index: lastPosition))
            }
        }
    }
   
    //xml解析
    
    private var fatherElement = ""
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == NetRequestId.VIDEO_CATEGORY_REQUEST{
            if currentElement == "area" {
                vodCategory = VodCategory()
            }else if currentElement == "areas"{
                vodCategoryList = Array<VodCategory>()
                fatherElement = currentElement
            }else if currentElement == "default"{
                fatherElement = currentElement
            }
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            if currentElement == "video_item" {
                videoItem = VideoBriefItem()
            }else if currentElement == "video_list" {
                videoList = Array<VideoBriefItem>()
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if requestId == NetRequestId.VIDEO_CATEGORY_REQUEST{
            if currentElement == "id" {
                vodCategory.id = content
                vodCategory.channelId = channelId
            }else if currentElement == "name"{
                vodCategory.name = content
                vodCategory.title = content
            }
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            if currentElement == "total" {
                videoPageData.totalSize = content
                countLbl.text = "共\(content)个视频"
                let pageSize : Float = Float(VodVideoPageData.PAGE_SIZE)
                let totalSize : Float = Float(content)!
                maxPage = Int(ceilf(totalSize/pageSize))
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
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == NetRequestId.VIDEO_CATEGORY_REQUEST{
            if elementName == "area" {
                if fatherElement == "default" {
                    vodCategoryGather.defVodCategory = vodCategory
                }else if fatherElement == "areas"{
                    vodCategoryList.append(vodCategory)
                }
                vodCategory = nil
            }else if elementName == "areas"{
                vodCategoryGather.vodCategoryList = vodCategoryList
                vodCategoryList = nil
            }
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            if elementName == "video_item" {
                videoList.append(videoItem)
                videoItem = nil
            }else if elementName == "video_list"{
                videoPageData.videoList.appendContentsOf(videoList)
                videoList = nil
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if requestId == NetRequestId.VIDEO_CATEGORY_REQUEST{
            vodCategoryGather.assembleLocalCategory(channelId)
            categoryTable.reloadData()
            categoryTable.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))?.textLabel?.textColor = UIColor.blueColor()
            titleLbl.text = vodCategoryGather.vodCategoryList[4].title
            getVideoListData(configParams(vodCategoryGather, index: 4))
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            videoCollection.reloadData()
        }
    }
    
    
    private func getVideoCategoryData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_CATOGORY_LIST_ACTION)!,parameters: ["channelId":channelId,"version":"1"]).response{
            _,_,data,error in
            self.requestId = NetRequestId.VIDEO_CATEGORY_REQUEST
            if error != nil{
                print(error)
            }
            
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    
    private func getVideoListData(params: [String:AnyObject]){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_VIDEO_LIST_ACTION)!,parameters: params).response{
            _,_,data,error in
            self.requestId = NetRequestId.VIDEO_VIDEO_LIST_REQUEST
            if error != nil {
                print(error)
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    private func configParams(gather: VodCategoryGather,index: Int) -> [String:AnyObject]{
        var ret = [String : AnyObject]()
        ret[HttpContants.PARAM_CHANNEL_ID] = channelId
        ret[HttpContants.PARAM_PAGE_SIZE] = VodVideoPageData.PAGE_SIZE
        ret[HttpContants.PARAM_PAGE_NO] = pageNum
        if index > gather.vodCategoryList.count - 1{
            return ret
        }
        var id = gather.vodCategoryList[index].id
        if id.isEmpty {
            id = gather.defVodCategory.id
        }
        ret[HttpContants.PARAM_STB_CATE_ID] = id
        return ret
    }
    
    override func dismissViewController() {
        SDImageCache.sharedImageCache().clearMemory()
        videoCollection.delegate = nil
        videoCollection.dataSource = nil
        categoryTable.delegate = nil
        categoryTable.dataSource = nil
        videoCollection = nil
        categoryTable = nil
        super.dismissViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
