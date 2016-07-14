//
//  VideoPlayItem.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/7.
//  Copyright © 2016年 skyworth. All rights reserved.
//



class VideoPlayItem: NSObject {

    class PlayUrl{
        var resolutionType = 0
        var resolutionName = ""
        var originalUrl = ""
        var realUrlList = [String]()
        var currentRealUrlIndex = 0
        
        func isValid() -> Bool{
            if realUrlList.isEmpty {
                return false
            }
            return true
        }
        
        func reachTail() -> Bool{
            if !isValid() {
                return true
            }
            if currentRealUrlIndex == realUrlList.count - 1 {
                return true
            }
            return false
        }
        
    }
    
    class InnerUrlInfo{
        var resolutionType = 0
        var originalUrl = ""
    }
    
    var id = ""
    var name = ""
    var duration = ""
    var uploadDuration = false
    var secondaryRequest = false
    var sourceId = ""
    var requestCount = 0
    var innerUrlList = [InnerUrlInfo]()
    var urlList = [PlayUrl]()
    var playUrlIndex = 0
    
    func isValid() -> Bool{
        if urlList.isEmpty{
            return false
        }
        
        for item in urlList {
            if item.isValid() {
                return true
            }
        }
        return false
    }
    
    func reachTail() -> Bool{
        if !isValid() {
            return true
        }
        if playUrlIndex == urlList.count - 1 {
            return true
        }
        return false
    }
}
 