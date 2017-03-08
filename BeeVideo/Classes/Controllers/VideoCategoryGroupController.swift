//
//  VideoCategoryGroupController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryGroupController:BaseBackViewController {
    
    fileprivate var groupList : Array<CategoryGroupItem>!
    fileprivate var groupView : CategoryGroupView!
    
    //xml解析
    var currentElement = ""
    var cateItem : CategoryGroupItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "影视专题"
        initView()
        getGroupListData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func initView(){
        
        groupView = CategoryGroupView()
        groupView.controller = self
        view.addSubview(groupView)
        groupView.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(backView.snp.bottom).offset(20)
            make.right.equalTo(view)
            make.bottom.equalTo(view).multipliedBy(0.9)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(groupView)
            make.height.width.equalTo(40)
        }
        
    }
    
    
    fileprivate func getGroupListData(){

        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_CATEGORY_GROUP)!).responseData { (response) in
            switch response.result{
            case .failure(let error):
                print(error)
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
extension VideoCategoryGroupController: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "list"{
            groupList = Array<CategoryGroupItem>()
        }else if currentElement == "item"{
            cateItem = CategoryGroupItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            groupList.append(cateItem)
            cateItem = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        loadingView.stopAnimat()
        groupView.setGroupItems(groupList)
    }
    
}

