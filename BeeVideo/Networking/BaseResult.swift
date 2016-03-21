//
//  BaseResult.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

protocol CallbackDelegate {
    func onRequestSuccess(baseResult:BaseResult)
    func onRequestFail(error:NSError?)
}

class BaseResult{
    
    var callBackDelegate:CallbackDelegate
    
    init(callBackDelegate:CallbackDelegate){
        self.callBackDelegate = callBackDelegate
    }
    
    func parseData(data:NSData?, error:NSError?){
        //
    }

}
