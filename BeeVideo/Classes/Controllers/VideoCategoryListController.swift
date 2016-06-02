//
//  VideoCategoryListController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryListController: BaseViewController,ZXOptionBarDelegate,ZXOptionBarDataSource,NSXMLParserDelegate {
    
    var position = 0
    var titleName = ""
    
    private var backImg : UIImageView!
    private var titleLbl : UILabel!
    private var countLbl : UILabel!
    private var mOptionBar : ZXOptionBar!
    private var itemList : Array<CategoryItem> = Array<CategoryItem>()
    
    let HOT_ITEM_POSITION = 1 // 热门
    let ALL_ITEM_POSITION = 5 // 全部

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImg = UIImageView()
        backImg.image = UIImage(named: "v2_vod_list_arrow_left")
        backImg.contentMode = .ScaleAspectFill
        view.addSubview(backImg)
        backImg.addOnClickListener(self, action: #selector(self.dismissViewController))
        backImg.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.topMargin.equalTo(30)
            make.height.equalTo(20)
            make.width.equalTo(10)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.text = titleName
        view.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backImg.snp_right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        countLbl = UILabel()
        countLbl.font = UIFont.systemFontOfSize(12)
        countLbl.textColor = UIColor.whiteColor()
        view.addSubview(countLbl)
        countLbl.snp_makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp_right).offset(5)
            make.centerY.equalTo(titleLbl)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRectZero, barDelegate: self, barDataSource: self)
        mOptionBar.setDividerWidth(dividerWidth: 20)
        mOptionBar.backgroundColor = UIColor.clearColor()
        view.addSubview(mOptionBar)
        mOptionBar.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view).dividedBy(2)
        }
        
        getListData()
    }
    
    //xml解析
    private var currentElement : String!
    private var categoryItem : CategoryItem!
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "subject" {
            categoryItem = CategoryItem()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "subject" {
            itemList.append(categoryItem)
            categoryItem = nil
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        countLbl.text = "共\(itemList.count)个专题"
        mOptionBar.reloadData()
    }
    
    //横向tableview相关
    func optionBar(optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(view.frame.height/2 * 0.7)
    }
    
    func numberOfColumnsInOptionBar(optionBar: ZXOptionBar) -> Int {
        return itemList.count
    }
    
    func optionBar(optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        
        let cellId = "cateList"
        
        var cell : BaseTableViewCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell(style: .ZXOptionBarCellStyleDefault, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.averageLbl.hidden = true
        }
        let item = itemList[index]
        cell?.icon.sd_setImageWithURL(NSURL(string: item.poster),placeholderImage: UIImage(named: "v2_image_default_bg.9"))
        cell?.videoNameLbl.text = item.name
        cell?.durationLbl.text = "点击量\(item.playCount)次"
        
        return cell!
    }
    
    func optionBar(optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let id = itemList[index].id
        var extras = [ExtraData]()
        extras.append(ExtraData(name: "", value: id))
        let cateController = VideoCategoryController()
        cateController.extras = extras
        self.presentViewController(cateController, animated: true, completion: nil)
    }
    
    //获取数据
    private func getListData(){
        var url:String = ""
        if position == HOT_ITEM_POSITION {
            url = CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_SPECIAL_RANK)!
        }else if position == ALL_ITEM_POSITION{
            url = CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_SPECIAL_ALL)!
        }
        Alamofire.request(.GET, url, parameters: ["pageSize" : String(Int32.max),"pageNo":"1"]).response{
            _,_,data,error in
            if error != nil{
                print(error)
                return
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
