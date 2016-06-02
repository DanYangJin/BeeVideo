//
//  RestVideoViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/31.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Alamofire

class RestVideoViewController: BaseBackViewController,NSXMLParserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private var mCollectionView:UICollectionView!
    private var coll:UICollectionReusableView!
    
    private var restInfoes:Array<RestVideoInfo> = Array<RestVideoInfo>()
    private var restInfo:RestVideoInfo!
    private var intent:RestVideoInfo.IntentInfo!
    private var extras:Array<ExtraData>!
    private var extraData:ExtraData!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "更多"
        
        let layout = UICollectionViewFlowLayout()
        mCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        mCollectionView.registerClass(RestVideoCollectionCell.self, forCellWithReuseIdentifier: "restCellId")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.clearColor()
        view.addSubview(mCollectionView)
        mCollectionView.snp_makeConstraints { (make) in
            make.left.equalTo(backView)
            make.right.equalTo(view)
            make.top.equalTo(backView.snp_bottom).offset(30)
            make.bottom.equalTo(view)
        }
        
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //collectionview
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restInfoes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell:RestVideoCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("restCellId", forIndexPath: indexPath) as! RestVideoCollectionCell
        cell.icon.sd_setImageWithURL(NSURL(string: restInfoes[indexPath.row].iconUrl))
        cell.titleLbl.text = restInfoes[indexPath.row].title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let info = restInfoes[indexPath.row]
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
            self.presentViewController(vodcate, animated: true, completion: nil)
        }
    }
    
    //xml解析
    private var currentElement = ""
    private var parentElement = ""
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
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
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
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
    
    func parserDidEndDocument(parser: NSXMLParser) {
        mCollectionView.reloadData()
    }
    
    
    
    func getData(){
        Alamofire.request(.GET, CommenUtils.fixRequestUrl(HttpContants.HOST, action: HttpContants.URL_REST_VIDEO_ACTION)!, parameters: nil).response{
            _,_,data,error in
            
            if error != nil {
                print(error)
                return
            }
            
            let parse = NSXMLParser(data: data!)
            parse.delegate = self
            parse.parse()
            
        }
    }
    
}
