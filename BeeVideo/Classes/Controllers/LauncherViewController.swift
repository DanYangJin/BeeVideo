//
//  LauncherController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/24.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import SnapKit
import Alamofire

class LauncherViewController: BaseViewController,NSXMLParserDelegate{
    //变量
    var homeData:HomeData!
    var currentName:String!
    var blockDatas:Dictionary<String,[HomeSpace]>!
    var homeSpaceList:[HomeSpace]!
    var tableName:String!
    var homeItem:HomeItem!
    var position:Int = 0
    var space:HomeSpace!
    var extras:[ExtraData]!
    var extra:ExtraData!
    var channelInfo:ChannelInfo!
    var favChannels:[ChannelInfo]!
    var channelProgram:ChannelProgram!
    var livePrograms:[ChannelProgram]!
    var dailyPrograms:[ChannelProgram]!
    var formBills:Bool = false
    
    
    override func viewDidLoad() {

        let bagroundImage:UIImageView = UIImageView()
        bagroundImage.image = UIImage(named: "home_start_bg")
        bagroundImage.sd_setImageWithURL(NSURL(string: "http://img.beevideo.tv/filestore/1354/baanvuf78.jpg"), placeholderImage: UIImage(named: "home_start_bg"))
        self.view.addSubview(bagroundImage)
        bagroundImage.snp_makeConstraints{ (make) -> Void in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height)
        }
        
        
        Alamofire.request(.GET, "http://www.beevideo.tv/api/hometv2.0/listBlockByVersion.action?borqsPassport=3p3kgHRqy244-VwtggWOVCAQEkAsn3SyyqGnCWqhScQNC_vyA9wYQ18Vvq7XJl8U&sdkLevel=19&version=2", parameters: nil, encoding: .URL, headers: ["X-Kds-Ver" : "2.10.07"]).response { request, response, data, error in
            if error != nil {
                print(error)
                return
            }
            self.parseXml(data!)
        }
        
    }
    
    
    func parseXml(data:NSData){
        let parse = NSXMLParser(data: data)
        parse.delegate = self
        parse.parse()
    }
    
    //开始解析
    func parserDidStartDocument(parser: NSXMLParser) {
        //print("parserDidStartDocument")
    }
    
    // 监听解析节点的属性
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        self.currentName = elementName
        if currentName == "result" {
            homeData = HomeData()
        } else if currentName == "tabs" {
            blockDatas = Dictionary<String,[HomeSpace]>()
        } else if currentName == "tab" {
            homeSpaceList = Array()
        } else if currentName == "tabname" {
            //
        } else if currentName == "blocks" {
            
        } else if currentName == "block" {
            homeItem  = HomeItem()
        } else if currentName == "title" {
            //
        } else if currentName == "extras" {
            extras = Array()
        } else if currentName == "extra"{
            extra = ExtraData()
        } else if currentName == "channels" {
            favChannels = Array()
        } else if currentName == "channel" {
            channelInfo = ChannelInfo()
        } else if currentName == "schedules" {
            livePrograms = Array()
        } else if currentName == "schedule" {
            channelProgram = ChannelProgram()
        } else if currentName == "bills" {
            dailyPrograms = Array()
            formBills = true
        } else if currentName == "bill" {
            channelProgram = ChannelProgram()
        }
    }
    
    // 监听解析节点的内容
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let content:String = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if currentName == nil{
            return
        }
        if currentName == "tabname" {
            self.tableName = content
        } else if currentName == "title" {
            homeItem.name = content
        } else if currentName == "position" {
            if content.isEmpty {
                return
            }
            let cp:Int = Int.init(content)!
            if cp != position {
                space = HomeSpace()
                homeSpaceList.append(space)
                space.tableName = tableName
                space.position = cp
                position = cp
            }
        } else if currentName == "type"{
            if content.isEmpty {
                return
            }
            homeItem.type = Int.init(content)!
        } else if currentName == "img" {
            homeItem.icon = content
        } else if currentName == "action" {
            homeItem.action = content
        } else if currentName == "channelId" {
            if channelInfo != nil {
                channelInfo.id = content
            } else {
                channelProgram.channelId = content
            }
        } else if currentName == "channeName" {
            if channelInfo != nil {
                channelInfo.name = content
            } else {
                channelProgram.channelName = content
            }
        } else if currentName == "channelPic" {
            if channelInfo != nil {
                channelInfo.channelPic = content
            } else {
                channelProgram.channelPic = content
            }
        } else if currentName == "id" {
            if formBills {
                channelProgram.channelId = content
            }
        } else if currentName == "name" {
            if formBills {
                channelProgram.channelName = content
            } else {
                extra.name = content
            }
        } else if currentName == "value" {
            extra.value = content
        } else if currentName == "timeStart" {
            if !content.isEmpty {
                channelProgram.timeStart = content
            }
        } else if currentName == "timeEnd" {
            if !content.isEmpty {
                channelProgram.timeEnd = content
            }
        } else if currentName == "scheduleName" {
            channelProgram.name = content
        } else if currentName == "schedulePic" {
            channelProgram.iconId = content
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "block" {
            space.items.append(homeItem)
            homeItem = nil
        } else if elementName == "blocks" {
            space = nil
        } else if elementName == "tab" {
            blockDatas[tableName] = homeSpaceList
            homeSpaceList = nil
            tableName = nil
        } else if elementName == "extras"{
            homeItem.extras = extras
            extras = nil
        } else if elementName == "extra"{
            extras.append(extra)
            extra = nil
        } else if elementName == "channel"{
            favChannels.append(channelInfo)
            channelInfo = nil
        } else if elementName == "schedule"{
            livePrograms.append(channelProgram)
            channelProgram = nil
        } else if elementName == "bill"{
            dailyPrograms.append(channelProgram)
            channelProgram = nil
        } else if elementName == "result" {
            homeData.blockDatas = blockDatas
            homeData.favChannels = favChannels
            homeData.livePrograms = livePrograms
            homeData.dailyPrograms = dailyPrograms
        }
        self.currentName = nil
    }
    //解析结束
    func parserDidEndDocument(parser: NSXMLParser) {
        let viewController = ViewController()
        viewController.homeData = self.homeData
        self.presentViewController(viewController,animated: true,completion: {
            
        })
    }

}
