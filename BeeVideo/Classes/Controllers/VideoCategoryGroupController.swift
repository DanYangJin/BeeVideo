//
//  VideoCategoryGroupController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryGroupController: BaseViewController,NSXMLParserDelegate {
 
    private var backImg : UIImageView!
    private var titleLbl : UILabel!
    private var groupList : Array<CategoryGroupItem>!
    private var groupView : CategoryGroupView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getGroupListData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView(){
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
        titleLbl.text = "影视专题"
        view.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backImg.snp_right).offset(8)
            make.top.bottom.equalTo(backImg)
        }
        
        groupView = CategoryGroupView()
        groupView.controller = self
        view.addSubview(groupView)
        groupView.snp_makeConstraints { (make) in
            make.left.equalTo(backImg)
            make.top.equalTo(backImg.snp_bottom).offset(30)
            make.right.equalTo(view)
            make.bottom.equalTo(view).multipliedBy(0.9)
        }

    }
    
    //xml解析
    var currentElement = ""
    var cateItem : CategoryGroupItem!
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "list"{
            groupList = Array<CategoryGroupItem>()
        }else if currentElement == "item"{
            cateItem = CategoryGroupItem()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty {
            return
        }
        if currentElement == "title" {
            cateItem.name = content
        }else if currentElement == "position"{
            cateItem.position = Int(content)!
        }else if currentElement == "img"{
            cateItem.poster = content
        }else if currentElement == "subjectId"{
            cateItem.id = content
        }else if currentElement == "subTitle"{
            cateItem.subName = content
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            groupList.append(cateItem)
            cateItem = nil
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        print(groupList.count)
        groupView.setGroupItems(groupList)
    }
    
    private func getGroupListData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_CATEGORY_GROUP)!, parameters: nil).response{
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
    

}
