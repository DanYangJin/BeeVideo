//
//  VodVideoController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VodVideoController: BaseViewController,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
    private var leftWidth : Float!
    private var lastPosition = 4
    
    private var contentView : UIScrollView!
    private var leftView : VodLeftView!
    private var videoCollection : UICollectionView!
    private var strinkView : UIImageView!
    private var backImg : UIImageView!
    private var titleLbl : UILabel!
    private var countLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftWidth = Float(self.view.frame.width * 0.2)
        
        contentView = UIScrollView(frame: self.view.frame)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.delegate = self
        contentView.bounces = false  //关闭弹性
        contentView.tag = 0
        contentView.contentSize = CGSizeMake(self.view.frame.width * 1.2, self.view.frame.height)
        self.view.addSubview(contentView)
        
        leftView = VodLeftView()
        leftView.tableView.dataSource = self
        leftView.tableView.delegate = self
        leftView.tableView.bounces = false
        leftView.tableView.tag = 1
        leftView.topArrow.hidden = true
        contentView.addSubview(leftView)
        leftView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(leftWidth)
        }
        
        strinkView = UIImageView()
        strinkView.contentMode = .ScaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        contentView.addSubview(strinkView)
        strinkView.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
            make.left.equalTo(leftView.snp_right)
            make.width.equalTo(20)
        }
        
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .ScaleAspectFill
        contentView.addSubview(backImg)
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
        contentView.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backImg.snp_right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.backgroundColor = UIColor(patternImage: (UIImage(named: "v2_vod_page_size_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)))!)
        countLbl.textColor = UIColor.whiteColor()
        countLbl.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(countLbl)
        countLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp_right).offset(5)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.view.frame.height - 80 - (self.view.frame.width - 80)/6 * 14/5
        videoCollection = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        videoCollection.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "collection")
        videoCollection.dataSource = self
        videoCollection.delegate = self
        videoCollection.tag = 2
        videoCollection.backgroundColor = UIColor.clearColor()
        contentView.addSubview(videoCollection)
        videoCollection.snp_makeConstraints { (make) in
            make.top.equalTo(backImg.snp_bottom).offset(20)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(contentView).offset(-20)
        }

        loadingView = LoadingView()
        self.contentView.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(videoCollection)
            make.height.width.equalTo(50)
        }
        loadingView.startAnimat()
        
        getVideoCategoryData()
        
    }
    
    private func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.view.frame.height - 80 - (self.view.frame.width - 80)/6 * 14/5
        videoCollection = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        videoCollection.registerClass(VideoItemCell.self, forCellWithReuseIdentifier: "collection")
        videoCollection.dataSource = self
        videoCollection.delegate = self
        videoCollection.tag = 2
        videoCollection.backgroundColor = UIColor.clearColor()
        contentView.addSubview(videoCollection)
        videoCollection.snp_makeConstraints { (make) in
            make.top.equalTo(backImg.snp_bottom).offset(20)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(contentView).offset(-20)
        }
    }
    
    //tableview相关
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vodCategoryGather.vodCategoryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "tableCell"
        let cellId2 = "iconCell"
        if indexPath.row == 0 || indexPath.row == 1 {
            var cell : VodVideoTableIconCell? = tableView.dequeueReusableCellWithIdentifier(cellId2) as? VodVideoTableIconCell
            if cell == nil {
                cell = VodVideoTableIconCell(style: .Default, reuseIdentifier: cellId2)
                cell?.backgroundColor = UIColor.clearColor()
                cell?.selectionStyle = .Gray
            }
            cell?.titleLbl.text = vodCategoryGather.vodCategoryList[indexPath.row].name
            if indexPath.row == 0 {
                cell?.icon.image = UIImage(named: "v2_vod_category_filter_normal")
            }else if indexPath.row == 1{
                cell?.icon.image = UIImage(named: "vod_index_serch")
            }
            return cell!
        }
        var cell : VodVideoTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? VodVideoTableViewCell
        if cell == nil {
            cell = VodVideoTableViewCell(style: .Default, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .Gray
        }
        
        cell?.titleLbl?.text = vodCategoryGather.vodCategoryList[indexPath.row].name
        cell?.titleLbl?.textColor = UIColor.whiteColor()
        if lastPosition == indexPath.row {
            cell?.titleLbl?.textColor = UIColor.textBlueColor()
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if lastPosition == indexPath.row {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        if lastPosition >= 2 && indexPath.row >= 2 {
            let lastCell:VodVideoTableViewCell? = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPosition, inSection: 0)) as? VodVideoTableViewCell
            if lastCell != nil {
                lastCell!.titleLbl?.textColor = UIColor.whiteColor()
            }
            loadingView.startAnimat()
        }
        if indexPath.row >= 2{
            let currentCell:VodVideoTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! VodVideoTableViewCell
            currentCell.titleLbl?.textColor = UIColor.textBlueColor()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row >= 2 {
            lastPosition = indexPath.row
        }
        
        titleLbl.text = vodCategoryGather.vodCategoryList[indexPath.row].title
        
       
        if indexPath.row == 1 {
            let searchController = SearchViewController()
            self.presentViewController(searchController, animated: true, completion: nil)
            loadingView.stopAnimat()
        }else{
            SDImageCache.sharedImageCache().clearMemory()
            videoPageData.videoList.removeAll()
            getVideoListData(configParams(vodCategoryGather, index: indexPath.row))
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    
    //collectionview相关
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let videoId = videoPageData.videoList[indexPath.row].id
        var extras:[ExtraData] = [ExtraData]()
        extras.append(ExtraData(name: "",value:videoId))
        
        let controller = VideoDetailViewController()
        controller.extras = extras
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //scrollView
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 0 {
            if decelerate {
                //关闭惯性滑动
                dispatch_async(dispatch_get_main_queue(), {
                    scrollView.setContentOffset(scrollView.contentOffset, animated: false)
                    let xOffset = scrollView.contentOffset.x
                    if xOffset >= self.view.frame.width * 0.1 {
                        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.2, y: 0), animated: true)
                    }else{
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                })
            }else{
                let xOffset = scrollView.contentOffset.x
                if xOffset >= self.view.frame.width * 0.1 {
                    scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.2, y: 0), animated: true)
                }else{
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 1{
            let offsetY = scrollView.contentOffset.y
            if offsetY == 0 {
                leftView.topArrow.hidden = true
            }else{
                leftView.topArrow.hidden = false
            }
            
            if offsetY + scrollView.frame.height == scrollView.contentSize.height{
                leftView.bottomArrow.hidden = true
            }else{
                leftView.bottomArrow.hidden = false
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
            leftView.tableView.reloadData()
            titleLbl.text = vodCategoryGather.vodCategoryList[4].title
            getVideoListData(configParams(vodCategoryGather, index: 4))
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            videoCollection.reloadData()
            videoCollection.contentOffset = CGPoint(x: 0, y: 0)
            loadingView.stopAnimat()
        }
    }
    
    //获取分类列表
    private func getVideoCategoryData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_CATOGORY_LIST_ACTION)!,parameters: ["channelId":channelId,"version":"1"]).response{
            _,_,data,error in
            self.requestId = NetRequestId.VIDEO_CATEGORY_REQUEST
            if error != nil{
                print(error)
                return
            }
            
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    //获取视频列表
    private func getVideoListData(params: [String:AnyObject]){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_VIDEO_LIST_ACTION)!,parameters: params).response{
            _,_,data,error in
            self.requestId = NetRequestId.VIDEO_VIDEO_LIST_REQUEST
            if error != nil {
                print(error)
                return
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
        videoCollection = nil
        leftView = nil
        super.dismissViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
