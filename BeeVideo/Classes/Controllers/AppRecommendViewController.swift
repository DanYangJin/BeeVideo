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

class AppRecommendViewController: BaseBackViewController,XMLParserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    fileprivate var recommendCollectionView:UICollectionView!
    
    fileprivate var recommendAppGather:RecommendAppGather = RecommendAppGather()
    fileprivate var recommendAppInfo:RecommendAppInfo!
    fileprivate var appList:[RecommendAppInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "应用推荐"
        
        let layout = UICollectionViewFlowLayout()
        recommendCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        recommendCollectionView.register(AppRecommendCell.self, forCellWithReuseIdentifier: "recommendCell")
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(recommendCollectionView)
        recommendCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl)
            make.right.equalTo(view.snp.right).multipliedBy(0.9)
            make.top.equalTo(backView.snp.bottom).offset(20)
            make.bottom.equalTo(view)
        }
        
        getRecommendAppData()
    }
    
    //collection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendAppGather.appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AppRecommendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! AppRecommendCell
        cell.titleLabl.text = recommendAppGather.appList[(indexPath as NSIndexPath).row].appName
        cell.appIconImg.sd_setImage(with: URL(string: recommendAppGather.appList[(indexPath as NSIndexPath).row].appIconUrl))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = view.frame.width * 0.9 - 60
        let width = (collectionWidth - 40) / 5
        
        return CGSize(width: width, height: width)
    }
    
    //xml解析
    fileprivate var currentElement = ""
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "appList" {
            appList = [RecommendAppInfo]()
        }else if currentElement == "item"{
            recommendAppInfo = RecommendAppInfo()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            appList.append(recommendAppInfo)
            recommendAppInfo = nil
        }else if elementName == "appList"{
            recommendAppGather.appList = appList
            appList = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
       recommendCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func getRecommendAppData(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_GET_RECOMM_APK_LIST)!).responseData { (response) in
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
