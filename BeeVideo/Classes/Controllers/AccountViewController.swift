//
//  AccountViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

/**
    我的帐户页面
 */

class AccountViewController: BaseBackViewController,NSXMLParserDelegate {

    private var accountView:AccountView!
    private var recordBtn:KeyBoardViewButton!
    private var helpBtn:KeyBoardViewButton!
    
    private var accountInfo:AccountInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "我的帐户"
        
        accountView = AccountView()
        self.view.addSubview(accountView)
        accountView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.4)
            make.width.equalTo(self.view).multipliedBy(0.7)
        }
        
        recordBtn = KeyBoardViewButton()
        recordBtn.buttonMode = .Text
        recordBtn.textLbl.text = "积分纪录"
        recordBtn.textLbl.font = UIFont.systemFontOfSize(12)
        recordBtn.addTarget(self, action: #selector(self.toPointRecordController), forControlEvents: .TouchUpInside)
        self.view.addSubview(recordBtn)
        recordBtn.snp_makeConstraints { (make) in
            make.top.equalTo(accountView.snp_bottom).offset(30)
            make.right.equalTo(accountView.snp_centerX).offset(-10)
            make.width.equalTo(accountView.snp_height).multipliedBy(0.7)
            make.height.equalTo(accountView.snp_height).dividedBy(5)
        }
        
        helpBtn = KeyBoardViewButton()
        helpBtn.buttonMode = .Text
        helpBtn.textLbl.font = UIFont.systemFontOfSize(12)
        helpBtn.textLbl.text = "积分帮助"
        self.view.addSubview(helpBtn)
        helpBtn.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(recordBtn)
            make.width.equalTo(recordBtn)
            make.left.equalTo(accountView.snp_centerX).offset(10)
        }
        
        getAccountData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var currentElement = ""
    func parserDidStartDocument(parser: NSXMLParser) {
        accountInfo = AccountInfo()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if currentElement == "totalPoint" {
            accountInfo.totalPoint = content
        }else if currentElement == "currentPoint"{
            accountInfo.currentPoint = content
        }else if currentElement == "username"{
            accountInfo.username = content
        }else if currentElement == "userLevelName"{
            accountInfo.userLevelName = content
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        accountView.currentPointLbl.text = accountInfo.currentPoint + "分"
        accountView.nameLbl.text = accountInfo.username
        accountView.allPointLbl.text = accountInfo.totalPoint + "分"
        accountView.levelLbl.text = accountInfo.userLevelName
    }
    
    
    func getAccountData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.ACTION_QUERY_USER_POINT_INFO)!, parameters: nil).response{
            request,_,data,error in
            if error != nil{
                return
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
            
        }
    }
    
    func toPointRecordController(){
        let controller = AccountPoinRecordViewController()
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
}
