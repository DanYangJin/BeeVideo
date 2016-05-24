//
//  CommonUtils.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import Foundation
class CommenUtils{
    
    
    static let SCHEMA_HTTP : String = "http://"
    
    static func fixRequestUrl(host: String,action: String) -> String?{
        if isStringInvalid(host) && isStringInvalid(action) {
            return nil
        }
        var ret : String = ""
        if !action.hasPrefix("/") {
            ret = "/" + action
        }
        if action.hasPrefix("http") {
            return action
        }
        ret = SCHEMA_HTTP + host + action
        return ret
    }
    
    static func isStringInvalid(str: String) -> Bool {
        return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
    }
}