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
    /**
       拼凑访问的url
     */
    static func fixRequestUrl(_ host: String,action: String) -> String?{
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
    
    static func isStringInvalid(_ str: String) -> Bool {
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    /**
        根据 320*480 进行缩放
     */
    static func calculatScaleSize(_ size: CGFloat) -> CGFloat{
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let scaleHeight = screenHeight > screenWidth ? screenWidth : screenHeight
        
        let ret = size * (scaleHeight / 320)
        
        return ret
    }
    
    static func imagePath(_ imageName: String) -> String{
        
        
        
        return ""
    }
    
    
    
}
