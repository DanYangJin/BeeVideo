//
//  UrlCfgUtils.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//
import Foundation

class UrlCfgUtils {
    
    static let QUESTION_MARK:Character = "?"
    static let AND_MARK:Character = "&"
    static let EQUAL_MARK:Character = "="
    
    static func configNormalSegments(url:String, segments:Dictionary<String, String>) -> String{
        return reconfigUrl(url, segments: segments)
    }
    
    
    static func reconfigUrl(var url:String, segments:Dictionary<String, String>?) -> String{
        if segments == nil || segments!.isEmpty {
            return url
        }
        for (key, value) in segments! {
            url.append(AND_MARK)
            url.appendContentsOf(key)
            url.append(EQUAL_MARK)
            url.appendContentsOf(value)
        }
        return url;
    }
    
    static func urlContainQuestionMark(url:String) -> Bool{
        return url.containsString(String.init(QUESTION_MARK))
    }

}
