//
//  VideoCategoryListController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryListController: BaseViewController,ZXOptionBarDelegate,ZXOptionBarDataSource {
    
    var position = 0
    var titleName = ""
    
    fileprivate var backImg : UIImageView!
    fileprivate var titleLbl : UILabel!
    fileprivate var countLbl : UILabel!
    fileprivate var mOptionBar : ZXOptionBar!
    fileprivate var itemList : Array<CategoryItem> = Array<CategoryItem>()
    
    let HOT_ITEM_POSITION = 1 // 热门
    let ALL_ITEM_POSITION = 5 // 全部
    
    //xml解析
    fileprivate var currentElement : String!
    fileprivate var categoryItem : CategoryItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getListData()
    }
    
    func initUI(){
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .scaleAspectFill
        view.addSubview(backImg)
        backImg.addOnClickListener(self, action: #selector(self.dismissViewController))
        backImg.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.top.equalTo(30)
            make.height.equalTo(20)
            make.width.equalTo(10)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.textColor = UIColor.white
        titleLbl.text = titleName
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(backImg.snp.right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.font = UIFont.systemFont(ofSize: 12)
        countLbl.textColor = UIColor.white
        view.addSubview(countLbl)
        countLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.right).offset(5)
            make.centerY.equalTo(titleLbl)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRect.zero, barDelegate: self, barDataSource: self)
        mOptionBar.setDividerWidth(dividerWidth: 20)
        mOptionBar.backgroundColor = UIColor.clear
        view.addSubview(mOptionBar)
        mOptionBar.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view).dividedBy(2)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(mOptionBar)
            make.height.width.equalTo(40)
        }
        
        errorView = ErrorView()
        errorView.isHidden = true
        errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
        self.view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(backImg.snp.bottom)
            make.bottom.equalTo(self.view)
        }
        
    }
    
    //横向tableview相关
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(view.frame.height/2 * 0.7)
    }
    
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        return itemList.count
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        
        let cellId = "cateList"
        
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clear
            cell?.averageLbl.isHidden = true
        }
        let item = itemList[index]
        cell?.icon.sd_setImage(with: URL(string: item.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cell?.videoNameLbl.text = item.name
        cell?.durationLbl.text = "点击量\(item.playCount)次"
        
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let id = itemList[index].id
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "", value: id))
        let cateController = VideoCategoryController()
        cateController.extras = extras
        self.present(cateController, animated: true, completion: nil)
    }
    
    //获取数据
    fileprivate func getListData(){
        var url:String = ""
        if position == HOT_ITEM_POSITION {
            url = CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_SPECIAL_RANK)!
        }else if position == ALL_ITEM_POSITION{
            url = CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_SPECIAL_ALL)!
        }
//        Alamofire.request(.GET, url, parameters: ["pageSize" : String(Int32.max),"pageNo":"1"]).response{
//            _,_,data,error in
//            if error != nil{
//                self.loadingView.stopAnimat()
//                self.errorView.isHidden = false
//                return
//            }
//            let parser = XMLParser(data: data!)
//            parser.delegate = self
//            parser.parse()
//        }
        Alamofire.request(url,parameters: ["pageSize": Int32.max,"pageNo":"1"]).responseData { (response) in
            switch response.result {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

/*
 xml解析
 */
extension VideoCategoryListController: XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "subject" {
            categoryItem = CategoryItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if currentElement == "id"{
            categoryItem.id = content
        }else if currentElement == "name"{
            categoryItem.name = content
        }else if currentElement == "playCount"{
            categoryItem.playCount = content
        }else if currentElement == "picCoverUrl"{
            categoryItem.poster = content
        }else if currentElement == "picBackgroundUrl"{
            categoryItem.backgroud = content
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "subject" {
            itemList.append(categoryItem)
            categoryItem = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        countLbl.text = "共\(itemList.count)个专题"
        loadingView.stopAnimat()
        mOptionBar.reloadData()
    }
}

