//
//  RestVideoViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/31.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

/**
 点播更多页面
 */

class RestVideoViewController: BaseBackViewController,XMLParserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    fileprivate var mCollectionView:UICollectionView!
    
    fileprivate var restInfoes:Array<RestVideoInfo> = Array<RestVideoInfo>()
    fileprivate var restInfo:RestVideoInfo!
    fileprivate var intent:RestVideoInfo.IntentInfo!
    fileprivate var extras:Array<ExtraData>!
    fileprivate var extraData:ExtraData!
    
    //xml解析
    fileprivate var currentElement = ""
    fileprivate var parentElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "更多"
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        mCollectionView.register(RestVideoCollectionCell.self, forCellWithReuseIdentifier: "restCellId")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.clear
        view.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.right.equalTo(view)
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(view)
        }
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //collectionview
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restInfoes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:RestVideoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "restCellId", for: indexPath) as! RestVideoCollectionCell
        cell.icon.sd_setImage(with: URL(string: restInfoes[(indexPath as NSIndexPath).row].iconUrl))
        cell.titleLbl.text = restInfoes[(indexPath as NSIndexPath).row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collWidth = collectionView.frame.width
        let width = (collWidth - 40) / 4
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = restInfoes[(indexPath as NSIndexPath).row]
        let action = info.intentInfo.action
        if action == "com.mipt.videohj.intent.action.VOD_CompositeStdiuoUI_ACTION" {
            var channelId = ""
            for extra in info.intentInfo.extras {
                if extra.name == "channelId" {
                    channelId = extra.value
                }
            }
            let vodcate = VodVideoController()
            vodcate.channelId = channelId
            self.present(vodcate, animated: true, completion: nil)
        }
    }
    
    func getData(){
        Alamofire.request(CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_REST_VIDEO_ACTION)!).responseData { (response) in
            switch response.result{
            case .failure(let error):
                print(error)
            case .success(let data):
                let parse = XMLParser(data: data)
                parse.delegate = self
                parse.parse()
            }
        }
    }
    
}

/*
 xml解析
 */
extension RestVideoViewController{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "block"{
            restInfo = RestVideoInfo()
            parentElement = "block"
        }else if currentElement == "intent"{
            intent = RestVideoInfo.IntentInfo()
            parentElement = "intent"
        }else if currentElement == "extras"{
            extras = Array<ExtraData>()
        }else if currentElement == "extra"{
            extraData = ExtraData()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if currentElement == "id" {
            restInfo.id = content
        }else if currentElement == "title"{
            restInfo.title = content
        }else if currentElement == "position"{
            restInfo.position = Int(content)!
        }else if currentElement == "img"{
            restInfo.iconUrl = content
        }else if currentElement == "type"{
            if parentElement == "block"{
                restInfo.type = Int(content)!
            }else if parentElement == "intent"{
                intent.type = content
            }
        }else if currentElement == "action"{
            intent.action = content
        }else if currentElement == "category"{
            intent.category = content
        }else if currentElement == "name"{
            extraData.name = content
        }else if currentElement == "value"{
            extraData.value = content
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "extra"{
            extras.append(extraData)
            extraData = nil
        }else if elementName == "extras"{
            intent.extras = extras
            extras = nil
        }else if elementName == "intent"{
            restInfo.intentInfo = intent
            intent = nil
        }else if elementName == "block"{
            restInfoes.append(restInfo)
            restInfo = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        mCollectionView.reloadData()
    }
    
}



