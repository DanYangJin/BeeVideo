//
//  VodVideoController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire
import PopupController

class VodVideoController: BaseViewController,VideoListViewDelegate,FiltViewClickDelegate {
    
    private enum NetRequestId{
        case VIDEO_CATEGORY_REQUEST
        case VIDEO_VIDEO_LIST_REQUEST
        case VIDEO_FILT_REQUEST
    }
    
    private var requestId : NetRequestId!
    
    var channelId : String! // 外部传入
    
    //xml解析相关
    //分类
    private var vodCategory : VodCategory!
    private var vodCategoryGather : VodCategoryGather = VodCategoryGather()//左边列表数据源
    private var vodCategoryList : Array<VodCategory>!
    private var currentElement : String = ""
    //列表
    private var videoPageData : VodVideoPageData = VodVideoPageData()
    private var videoList : Array<VideoBriefItem>!
    private var videoItem : VideoBriefItem!
    private var maxPage : Int = 0
    private var leftWidth : Float!
    private var lastPosition = 4
    //筛选
    private var filtCategory:VodFiltrateCategory!
    private var filtCategoryGather = VodFiltrateCategoryGather()
    
    private var contentView : UIScrollView!
    private var leftView : VodLeftView!
    private var strinkView : UIImageView!
    private var backView : UIButton!
    private var titleLbl : UILabel!
    private var countLbl : UILabel!
    private var videoListView : VideoListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftWidth = Float(self.view.frame.width * 0.2)
        
        initUI()
        
        getVideoCategoryData()
        getFiltData()
    }
    
    func initUI(){
        contentView = UIScrollView(frame: self.view.frame)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.delegate = self
        contentView.bounces = false  //关闭弹性
        contentView.tag = 0
        contentView.delaysContentTouches = false
        contentView.contentSize = CGSizeMake(self.view.frame.width * 1.2, self.view.frame.height)
        contentView.contentOffset = CGPoint(x: CGFloat(leftWidth), y: 0)
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
        
        backView = UIButton()
        backView.setImage(UIImage(named: "v2_title_arrow_default"), forState: .Normal)
        backView.setImage(UIImage(named: "v2_title_arrow_selected"), forState: .Highlighted)
        backView.addTarget(self, action: #selector(self.dismissViewController), forControlEvents: .TouchUpInside)
        contentView.addSubview(backView)
        backView.snp_makeConstraints { (make) in
            make.left.equalTo(strinkView.snp_right)
            make.topMargin.equalTo(15)
            make.height.width.equalTo(40)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        contentView.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backView.snp_right)
            make.top.bottom.equalTo(backView)
        }
        
        countLbl = UILabel()
        //countLbl.backgroundColor = UIColor(patternImage: (UIImage(named: "v2_vod_page_size_bg"))!)
        let img = UIImage(named: "v2_vod_page_size_bg")
        countLbl.layer.contents = img?.CGImage
        countLbl.textColor = UIColor.whiteColor()
        countLbl.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(countLbl)
        countLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp_right).offset(5)
        }
        
        videoListView = VideoListView()
        videoListView.delegate = self
        contentView.addSubview(videoListView)
        videoListView.snp_makeConstraints { (make) in
            make.top.equalTo(backView.snp_bottom).offset(15)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(strinkView.snp_right)
            make.width.equalTo(contentView).offset(-20)
        }
        
        errorView = ErrorView()
        errorView.hidden = true
        //errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE
        self.contentView.addSubview(errorView)
        errorView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(videoListView)
            make.left.right.equalTo(videoListView)
        }
    }
    
    
    func onLoadMoreListener() {
        if videoPageData.pageNo < videoPageData.maxPage {
            videoPageData.pageNo += 1
            getVideoListData(configParams(vodCategoryGather, index: lastPosition))
            videoListView.loadingView.startAnimat()
        }
    }
    
    func onVideoListViewItemClick(videoId: String) {
        let detailViewController = VideoDetailViewController()
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        detailViewController.extras = extras
        self.presentViewController(detailViewController, animated: true, completion: nil)
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
        }else if scrollView.tag == 0{
            if strinkView == nil {
                return
            }
            let offsetX = scrollView.contentOffset.x
            let rotation = offsetX / CGFloat(leftWidth)
            strinkView.transform = CGAffineTransformMakeRotation(-rotation * CGFloat(M_PI))
        }
    }
    
    //xml解析
    
    private var fatherElement = ""
    
    private func clearVodeoList(){
        videoPageData.videoList.removeAll()
        videoListView.collectionView.hidden = true
        SDImageCache.sharedImageCache().clearMemory()
        //videoPageData.videoList.removeAll()
        videoPageData.pageNo = 1
        videoListView.removeViewData()
        videoListView.loadingView.startAnimat()
    }
    
    ///获取分类列表
    private func getVideoCategoryData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_CATOGORY_LIST_ACTION)!,parameters: ["channelId":channelId,"version":"1"]).response{
            _,_,data,error in
            self.requestId = NetRequestId.VIDEO_CATEGORY_REQUEST
            if error != nil{
                self.videoListView.loadingView.stopAnimat()
                self.errorView.hidden = false
                return
            }
            
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    ///获取视频列表
    private func getVideoListData(params: [String:AnyObject]){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_VIDEO_LIST_ACTION)!,parameters: params).response{
            request,_,data,error in
            self.requestId = NetRequestId.VIDEO_VIDEO_LIST_REQUEST
            if error != nil {
                self.videoListView.loadingView.stopAnimat()
                self.videoListView.collectionView.hidden = true
                self.errorView.hidden = false
                self.errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
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
        ret[HttpContants.PARAM_PAGE_NO] = videoPageData.pageNo
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
    
    ///获取筛选信息
    private func getFiltData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_FILTRATE_CATEGORY_ACTION)!, parameters: ["channelId" : channelId]).responseData { (response) in
            self.requestId = NetRequestId.VIDEO_FILT_REQUEST
            switch response.result {
            case .Failure(let error):
                print(error)
                break;
            case .Success(let data):
                let parse = NSXMLParser(data: data)
                parse.delegate = self
                parse.parse()
                break;
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    func confirmClickListener(row_0: Int, row_1: Int, row_2: Int, row_3: Int) {
        
        var params = [String:AnyObject]()
        params["channelId"] = channelId
        params["pageSize"] = 96
        params["pageNo"] = videoPageData.pageNo
        if row_0 != 0  {
            params["areaId"] = filtCategoryGather.areaList[row_0].id
        }
        if row_1 != 0 {
            params["cateId"] = filtCategoryGather.categoryList[row_1].id
        }
        if row_2 != 0 {
            params["yearId"] = filtCategoryGather.yearList[row_2].id
        }
        
        params["orderBy"] = filtCategoryGather.orderList[row_3].id
        clearVodeoList()
        getVideoListData(params)
    }
    
}



extension VodVideoController: NSXMLParserDelegate{
    
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
        }else if requestId == NetRequestId.VIDEO_FILT_REQUEST{
            
            if currentElement == "area" {
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.AREA
            }else if currentElement == "cate"{
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.CATEGORY
            }else if currentElement == "year" {
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.YEAR
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
                videoPageData.maxPage = Int(ceilf(totalSize/pageSize))
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
        }else if requestId == NetRequestId.VIDEO_FILT_REQUEST{
            if currentElement == "id" {
                filtCategory.id = Int(content)!
            }else if currentElement == "name" {
                filtCategory.name = content
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
        }else if requestId == NetRequestId.VIDEO_FILT_REQUEST{
            if elementName == "area" {
                //print(filtCategory.type)
                filtCategoryGather.addFiltCategory(filtCategory)
                filtCategory = nil
            }else if elementName == "cate"{
                filtCategoryGather.addFiltCategory(filtCategory)
                filtCategory = nil
            }else if elementName == "year" {
                filtCategoryGather.addFiltCategory(filtCategory)
                filtCategory = nil
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if requestId == NetRequestId.VIDEO_CATEGORY_REQUEST{
            vodCategoryGather.assembleLocalCategory(channelId)
            leftView.tableView.reloadData()
            titleLbl.text = vodCategoryGather.vodCategoryList[4].title
            getVideoListData(configParams(vodCategoryGather, index: 4))
            contentView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        }else if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            videoListView.collectionView.hidden = false
            videoListView.setViewData(videoPageData.videoList)
        }else if requestId == NetRequestId.VIDEO_FILT_REQUEST{
            
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        if requestId == NetRequestId.VIDEO_VIDEO_LIST_REQUEST{
            videoPageData.videoList.removeAll()
            if videoPageData.pageNo < videoPageData.maxPage {
                videoPageData.pageNo += 1
                getVideoListData(configParams(vodCategoryGather, index: lastPosition))
                videoListView.loadingView.startAnimat()
            }
        }
    }

}


/*
 xml解析
 */
extension VodVideoController: UITableViewDelegate,UITableViewDataSource{
    
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
        
        countLbl.text = ""
        
        if lastPosition >= 2 && indexPath.row >= 2 {
            let lastCell:VodVideoTableViewCell? = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastPosition, inSection: 0)) as? VodVideoTableViewCell
            if lastCell != nil {
                lastCell!.titleLbl?.textColor = UIColor.whiteColor()
            }
        }
        if indexPath.row >= 2{
            let currentCell:VodVideoTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! VodVideoTableViewCell
            currentCell.titleLbl?.textColor = UIColor.textBlueColor()
            lastPosition = indexPath.row
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        titleLbl.text = vodCategoryGather.vodCategoryList[indexPath.row].title
        
        if indexPath.row == 1 {
            let searchController = SearchViewController()
            self.presentViewController(searchController, animated: true, completion: nil)
        }else if indexPath.row == 0{
            let popup = PopupController.create(self).customize([.Layout(.Bottom)])
            let controller = VodFiltViewController()
            controller.gather = filtCategoryGather
            controller.delegate = self
            popup.show(controller)
        }else{
            errorView.hidden = true
            clearVodeoList()
            getVideoListData(configParams(vodCategoryGather, index: indexPath.row))
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
}



