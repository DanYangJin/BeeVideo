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

class AccountViewController: BaseBackViewController,XMLParserDelegate {

    fileprivate var accountView:AccountView!
    fileprivate var recordBtn:KeyBoardViewButton!
    fileprivate var helpBtn:KeyBoardViewButton!
    
    fileprivate var accountInfo:AccountInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "我的帐户"
        
        accountView = AccountView()
        self.view.addSubview(accountView)
        accountView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.4)
            make.width.equalTo(self.view).multipliedBy(0.7)
        }
        
        recordBtn = KeyBoardViewButton()
        recordBtn.buttonMode = .text
        recordBtn.textLbl.text = "积分纪录"
        recordBtn.textLbl.font = UIFont.systemFont(ofSize: 12)
        recordBtn.addTarget(self, action: #selector(self.toPointRecordController), for: .touchUpInside)
        self.view.addSubview(recordBtn)
        recordBtn.snp.makeConstraints { (make) in
            make.top.equalTo(accountView.snp.bottom).offset(30)
            make.right.equalTo(accountView.snp.centerX).offset(-10)
            make.width.equalTo(accountView.snp.height).multipliedBy(0.7)
            make.height.equalTo(accountView.snp.height).dividedBy(5)
        }
        
        helpBtn = KeyBoardViewButton()
        helpBtn.buttonMode = .text
        helpBtn.textLbl.font = UIFont.systemFont(ofSize: 12)
        helpBtn.textLbl.text = "积分帮助"
        self.view.addSubview(helpBtn)
        helpBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(recordBtn)
            make.width.equalTo(recordBtn)
            make.left.equalTo(accountView.snp.centerX).offset(10)
        }
        
        getAccountData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var currentElement = ""
    func parserDidStartDocument(_ parser: XMLParser) {
        accountInfo = AccountInfo()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        accountView.currentPointLbl.text = accountInfo.currentPoint + "分"
        accountView.nameLbl.text = accountInfo.username
        accountView.allPointLbl.text = accountInfo.totalPoint + "分"
        accountView.levelLbl.text = accountInfo.userLevelName
    }
    
    
    func getAccountData(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.ACTION_QUERY_USER_POINT_INFO)!).responseData { (response) in
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
    
    func toPointRecordController(){
        let controller = AccountPoinRecordViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
