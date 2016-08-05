//
//  VideoCategoryGroupController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryGroupController:BaseBackViewController ,NSXMLParserDelegate {
    
    private var groupList : Array<CategoryGroupItem>!
    private var groupView : CategoryGroupView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "影视专题"
        initView()
        getGroupListData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView(){
        
        groupView = CategoryGroupView()
        groupView.controller = self
        view.addSubview(groupView)
        groupView.snp_makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp_bottom).offset(20)
            make.right.equalTo(view)
            make.bottom.equalTo(view).multipliedBy(0.9)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(groupView)
            make.height.width.equalTo(40)
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
        loadingView.stopAnimat()
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
