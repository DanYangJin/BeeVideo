//
//  NetworkUtil.swift
//  BeeVideo
//
//  Created by JinZhang on 16/7/5.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SystemConfiguration

class NetworkUtil: NSObject {

    static let CONNECT_TYPE_WLAN = "WLAN"
    static let CONNECT_TYPE_WWAN = "WWAN"
    static let CONNECT_TYPE_NO = "NO"
    
    static func isNetConnected() -> Bool {
        
        let reachability : Reachability
        do{
            try reachability = Reachability.reachabilityForInternetConnection()
        }catch{
            return false
        }
        
        if reachability.isReachable() {
            return true
        }
        
        return false
    }
    
    static func getNetConnectType() -> String{
        let reachability : Reachability
        do{
            try reachability = Reachability.reachabilityForInternetConnection()
        }catch{
            return CONNECT_TYPE_NO
        }
        
        if reachability.isReachableViaWiFi() {
            return CONNECT_TYPE_WLAN
        }else if reachability.isReachableViaWWAN(){
            return CONNECT_TYPE_WWAN
        }else{
            return CONNECT_TYPE_NO
        }
        
    }
    
    static func isWifiConnection() -> Bool{
        
        if !isNetConnected() {
            return false
        }
        
        if getNetConnectType() == CONNECT_TYPE_WLAN {
            return true
        }
        
        return false
    }
    
    
}
