//
//  TestResult.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class TestResult: BaseResult {

    var data:NSData!
    
    override init(callBackDelegate:CallbackDelegate){
        super.init(callBackDelegate: callBackDelegate)
    }
    
    override func parseData(data: NSData?, error: NSError?) {
        if error != nil {
            callBackDelegate.onRequestFail(error)
        }
        self.data = data
        callBackDelegate.onRequestSuccess(self)
    }
}
