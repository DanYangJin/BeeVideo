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
    
    fileprivate enum NetRequestId{
        case video_CATEGORY_REQUEST
        case video_VIDEO_LIST_REQUEST
        case video_FILT_REQUEST
    }
    
    fileprivate var requestId : NetRequestId!
    
    var channelId : String! // 外部传入
    
    //xml解析相关
    //分类
    fileprivate var vodCategory : VodCategory!
    fileprivate var vodCategoryGather : VodCategoryGather = VodCategoryGather()//左边列表数据源
    fileprivate var vodCategoryList : Array<VodCategory>!
    fileprivate var currentElement : String = ""
    //列表
    fileprivate var videoPageData : VodVideoPageData = VodVideoPageData()
    fileprivate var videoList : Array<VideoBriefItem>!
    fileprivate var videoItem : VideoBriefItem!
    fileprivate var maxPage : Int = 0
    fileprivate var leftWidth : Float!
    fileprivate var lastPosition = 4
    //筛选
    fileprivate var filtCategory:VodFiltrateCategory!
    fileprivate var filtCategoryGather = VodFiltrateCategoryGather()
    
    fileprivate var contentView : UIScrollView!
    fileprivate var leftView : VodLeftView!
    fileprivate var strinkView : UIImageView!
    fileprivate var backView : UIButton!
    fileprivate var titleLbl : UILabel!
    fileprivate var countLbl : UILabel!
    fileprivate var videoListView : VideoListView!
    
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
        contentView.contentSize = CGSize(width: self.view.frame.width * 1.2, height: self.view.frame.height)
        contentView.contentOffset = CGPoint(x: CGFloat(leftWidth), y: 0)
        self.view.addSubview(contentView)
        
        leftView = VodLeftView()
        leftView.tableView.dataSource = self
        leftView.tableView.delegate = self
        leftView.tableView.bounces = false
        leftView.tableView.tag = 1
        leftView.topArrow.isHidden = true
        contentView.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(leftWidth)
        }
        
        strinkView = UIImageView()
        strinkView.contentMode = .scaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        contentView.addSubview(strinkView)
        strinkView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
            make.left.equalTo(leftView.snp.right)
            make.width.equalTo(20)
        }
        
        backView = UIButton()
        backView.setImage(UIImage(named: "v2_title_arrow_default"), for: UIControlState())
        backView.setImage(UIImage(named: "v2_title_arrow_selected"), for: .highlighted)
        backView.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(strinkView.snp.right)
            make.top.equalTo(15)
            make.height.width.equalTo(40)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.textColor = UIColor.white
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.right)
            make.top.bottom.equalTo(backView)
        }
        
        countLbl = UILabel()
        //countLbl.backgroundColor = UIColor(patternImage: (UIImage(named: "v2_vod_page_size_bg"))!)
        let img = UIImage(named: "v2_vod_page_size_bg")
        countLbl.layer.contents = img?.cgImage
        countLbl.textColor = UIColor.white
        countLbl.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(countLbl)
        countLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLbl)
            make.left.equalTo(titleLbl.snp.right).offset(5)
        }
        
        videoListView = VideoListView()
        videoListView.delegate = self
        contentView.addSubview(videoListView)
        videoListView.snp.makeConstraints { (make) in
            make.top.equalTo(backView.snp.bottom).offset(15)
            make.bottom.equalTo(self.view).offset(-10)
            make.left.equalTo(strinkView.snp.right)
            make.width.equalTo(contentView).offset(-20)
        }
        
        errorView = ErrorView()
        errorView.isHidden = true
        //errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE
        self.contentView.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
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
    
    func onVideoListViewItemClick(_ videoId: String) {
        let detailViewController = VideoDetailViewController()
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "videoId", value: videoId))
        detailViewController.extras = extras
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    
    //scrollView
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 0 {
            if decelerate {
                //关闭惯性滑动
                DispatchQueue.main.async(execute: {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1{
            let offsetY = scrollView.contentOffset.y
            if offsetY == 0 {
                leftView.topArrow.isHidden = true
            }else{
                leftView.topArrow.isHidden = false
            }
            
            if offsetY + scrollView.frame.height == scrollView.contentSize.height{
                leftView.bottomArrow.isHidden = true
            }else{
                leftView.bottomArrow.isHidden = false
            }
        }else if scrollView.tag == 0{
            if strinkView == nil {
                return
            }
            let offsetX = scrollView.contentOffset.x
            let rotation = offsetX / CGFloat(leftWidth)
            strinkView.transform = CGAffineTransform(rotationAngle: -rotation * CGFloat(M_PI))
        }
    }
    
    //xml解析
    
    fileprivate var fatherElement = ""
    
    fileprivate func clearVodeoList(){
        videoPageData.videoList.removeAll()
        videoListView.collectionView.isHidden = true
        SDImageCache.shared().clearMemory()
        //videoPageData.videoList.removeAll()
        videoPageData.pageNo = 1
        videoListView.removeViewData()
        videoListView.loadingView.startAnimat()
    }
    
    ///获取分类列表
    fileprivate func getVideoCategoryData(){

        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_CATOGORY_LIST_ACTION)!, parameters: ["channelId":channelId,"version":"1"]).responseData { (response) in
            self.requestId = NetRequestId.video_CATEGORY_REQUEST
            switch response.result{
            case .failure(_):
                self.videoListView.loadingView.stopAnimat()
                self.errorView.isHidden = false
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            
        }
    }
    
    ///获取视频列表
    fileprivate func getVideoListData(_ params: [String:Any]){
    
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_VIDEO_VIDEO_LIST_ACTION)!, parameters: params).responseData { (response) in
            self.requestId = NetRequestId.video_VIDEO_LIST_REQUEST
            switch response.result{
            case .failure(_):
                self.videoListView.loadingView.stopAnimat()
                self.videoListView.collectionView.isHidden = true
                self.errorView.isHidden = false
                self.errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        
        }
        
        
    }
    
    fileprivate func configParams(_ gather: VodCategoryGather,index: Int) -> [String:Any]{
        var ret = [String : Any]()
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
        ret[HttpContants.PARAM_STB_CATE_ID] = id as AnyObject?
        return ret
    }
    
    ///获取筛选信息
    fileprivate func getFiltData(){
//        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.V20_VOD_FILTRATE_CATEGORY_ACTION)!, parameters: ["channelId" : channelId]).responseData { (response) in
//            self.requestId = NetRequestId.video_FILT_REQUEST
//            switch response.result {
//            case .failure(let error):
//                print(error)
//                break;
//            case .success(let data):
//                let parse = XMLParser(data: data)
//                parse.delegate = self
//                parse.parse()
//                break;
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearMemory()
    }
    
    func confirmClickListener(_ row_0: Int, row_1: Int, row_2: Int, row_3: Int) {
        
        var params = [String:AnyObject]()
        params["channelId"] = channelId as AnyObject?
        params["pageSize"] = 96 as AnyObject?
        params["pageNo"] = videoPageData.pageNo as AnyObject?
        if row_0 != 0  {
            params["areaId"] = filtCategoryGather.areaList[row_0].id as AnyObject?
        }
        if row_1 != 0 {
            params["cateId"] = filtCategoryGather.categoryList[row_1].id as AnyObject?
        }
        if row_2 != 0 {
            params["yearId"] = filtCategoryGather.yearList[row_2].id as AnyObject?
        }
        
        params["orderBy"] = filtCategoryGather.orderList[row_3].id as AnyObject?
        clearVodeoList()
        getVideoListData(params)
    }
    
}



extension VodVideoController: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if requestId == NetRequestId.video_CATEGORY_REQUEST{
            if currentElement == "area" {
                vodCategory = VodCategory()
            }else if currentElement == "areas"{
                vodCategoryList = Array<VodCategory>()
                fatherElement = currentElement
            }else if currentElement == "default"{
                fatherElement = currentElement
            }
        }else if requestId == NetRequestId.video_VIDEO_LIST_REQUEST{
            if currentElement == "video_item" {
                videoItem = VideoBriefItem()
            }else if currentElement == "video_list" {
                videoList = Array<VideoBriefItem>()
            }
        }else if requestId == NetRequestId.video_FILT_REQUEST{
            
            if currentElement == "area" {
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.area
            }else if currentElement == "cate"{
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.category
            }else if currentElement == "year" {
                filtCategory = VodFiltrateCategory()
                filtCategory.type = FiltType.year
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if requestId == NetRequestId.video_CATEGORY_REQUEST{
            if currentElement == "id" {
                vodCategory.id = content
                vodCategory.channelId = channelId
            }else if currentElement == "name"{
                vodCategory.name = content
                vodCategory.title = content
            }
        }else if requestId == NetRequestId.video_VIDEO_LIST_REQUEST{
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
        }else if requestId == NetRequestId.video_FILT_REQUEST{
            if currentElement == "id" {
                filtCategory.id = Int(content)!
            }else if currentElement == "name" {
                filtCategory.name = content
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if requestId == NetRequestId.video_CATEGORY_REQUEST{
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
        }else if requestId == NetRequestId.video_VIDEO_LIST_REQUEST{
            if elementName == "video_item" {
                videoList.append(videoItem)
                videoItem = nil
            }else if elementName == "video_list"{
                videoPageData.videoList.append(contentsOf: videoList)
                videoList = nil
            }
        }else if requestId == NetRequestId.video_FILT_REQUEST{
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if requestId == NetRequestId.video_CATEGORY_REQUEST{
            vodCategoryGather.assembleLocalCategory(channelId)
            leftView.tableView.reloadData()
            titleLbl.text = vodCategoryGather.vodCategoryList[4].title
            getVideoListData(configParams(vodCategoryGather, index: 4))
            contentView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        }else if requestId == NetRequestId.video_VIDEO_LIST_REQUEST{
            videoListView.collectionView.isHidden = false
            videoListView.setViewData(videoPageData.videoList)
        }else if requestId == NetRequestId.video_FILT_REQUEST{
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        if requestId == NetRequestId.video_VIDEO_LIST_REQUEST{
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vodCategoryGather.vodCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "tableCell"
        let cellId2 = "iconCell"
        if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1 {
            var cell : VodVideoTableIconCell? = tableView.dequeueReusableCell(withIdentifier: cellId2) as? VodVideoTableIconCell
            if cell == nil {
                cell = VodVideoTableIconCell(style: .default, reuseIdentifier: cellId2)
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .gray
            }
            cell?.titleLbl.text = vodCategoryGather.vodCategoryList[(indexPath as NSIndexPath).row].name
            if (indexPath as NSIndexPath).row == 0 {
                cell?.icon.image = UIImage(named: "v2_vod_category_filter_normal")
            }else if (indexPath as NSIndexPath).row == 1{
                cell?.icon.image = UIImage(named: "vod_index_serch")
            }
            return cell!
        }
        var cell : VodVideoTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? VodVideoTableViewCell
        if cell == nil {
            cell = VodVideoTableViewCell(style: .default, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .gray
        }
        
        cell?.titleLbl?.text = vodCategoryGather.vodCategoryList[(indexPath as NSIndexPath).row].name
        cell?.titleLbl?.textColor = UIColor.white
        if lastPosition == (indexPath as NSIndexPath).row {
            cell?.titleLbl?.textColor = UIColor.textBlueColor()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lastPosition == (indexPath as NSIndexPath).row {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        countLbl.text = ""
        
        if lastPosition >= 2 && (indexPath as NSIndexPath).row >= 2 {
            let lastCell:VodVideoTableViewCell? = tableView.cellForRow(at: IndexPath(row: lastPosition, section: 0)) as? VodVideoTableViewCell
            if lastCell != nil {
                lastCell!.titleLbl?.textColor = UIColor.white
            }
        }
        if (indexPath as NSIndexPath).row >= 2{
            let currentCell:VodVideoTableViewCell = tableView.cellForRow(at: indexPath) as! VodVideoTableViewCell
            currentCell.titleLbl?.textColor = UIColor.textBlueColor()
            lastPosition = (indexPath as NSIndexPath).row
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        titleLbl.text = vodCategoryGather.vodCategoryList[(indexPath as NSIndexPath).row].title
        
        if (indexPath as NSIndexPath).row == 1 {
            let searchController = SearchViewController()
            self.present(searchController, animated: true, completion: nil)
        }else if (indexPath as NSIndexPath).row == 0{
            let popup = PopupController.create(self).customize([.layout(.bottom)])
            let controller = VodFiltViewController()
            controller.gather = filtCategoryGather
            controller.delegate = self
            let _ = popup.show(controller)
        }else{
            errorView.isHidden = true
            clearVodeoList()
            getVideoListData(configParams(vodCategoryGather, index: (indexPath as NSIndexPath).row))
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}



