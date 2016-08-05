//
//  AppRecommendViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

/**
   应用推荐页面
 */

class AppRecommendViewController: BaseBackViewController,NSXMLParserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private var recommendCollectionView:UICollectionView!
    
    private var recommendAppGather:RecommendAppGather = RecommendAppGather()
    private var recommendAppInfo:RecommendAppInfo!
    private var appList:[RecommendAppInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "应用推荐"
        
        let layout = UICollectionViewFlowLayout()
        recommendCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        recommendCollectionView.registerClass(AppRecommendCell.self, forCellWithReuseIdentifier: "recommendCell")
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(recommendCollectionView)
        recommendCollectionView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLbl)
            make.right.equalTo(view.snp_right).multipliedBy(0.9)
            make.top.equalTo(backView.snp_bottom).offset(20)
            make.bottom.equalTo(view)
        }
        
        getRecommendAppData()
    }
    
    //collection
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendAppGather.appList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : AppRecommendCell = collectionView.dequeueReusableCellWithReuseIdentifier("recommendCell", forIndexPath: indexPath) as! AppRecommendCell
        cell.titleLabl.text = recommendAppGather.appList[indexPath.row].appName
        cell.appIconImg.sd_setImageWithURL(NSURL(string: recommendAppGather.appList[indexPath.row].appIconUrl))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionWidth = view.frame.width * 0.9 - 60
        let width = (collectionWidth - 40) / 5
        
        return CGSizeMake(width, width)
    }
    
    //xml解析
    private var currentElement = ""
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "appList" {
            appList = [RecommendAppInfo]()
        }else if currentElement == "item"{
            recommendAppInfo = RecommendAppInfo()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if content.isEmpty{
            return
        }
        if currentElement == "total" {
            recommendAppGather.total = content
        }else if currentElement == "appId"{
            recommendAppInfo.appId = content
        }else if currentElement == "packageName"{
            recommendAppInfo.pkname = content
        }else if currentElement == "appName"{
            recommendAppInfo.appName = content
        }else if currentElement == "versionName"{
            recommendAppInfo.versionName = content
        }else if currentElement == "versionCode"{
            recommendAppInfo.versionCode = Int(content)!
        }else if currentElement == "appSize"{
            recommendAppInfo.appSize = Int64(content)!
        }else if currentElement == "appUrl"{
            recommendAppInfo.downloadUrl = content
        }else if currentElement == "picUrl"{
            recommendAppInfo.appIconUrl = content
        }else if currentElement == "md5"{
            recommendAppInfo.md5 = content
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            appList.append(recommendAppInfo)
            recommendAppInfo = nil
        }else if elementName == "appList"{
            recommendAppGather.appList = appList
            appList = nil
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
       recommendCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getRecommendAppData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_RECOMM_APK_LIST)!, parameters: nil).response{
            _,_,data,error in
            
            if error != nil {
                print(error)
                return
            }
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }
    }
    
}
