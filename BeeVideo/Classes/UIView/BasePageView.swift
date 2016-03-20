//
//  BasePageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class BasePageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    //初始化view
    func initView(){
        prepareLoadData()
    }
    // 初始化数据
    func prepareLoadData(){}
    //获取宽度
    func getViewWidth() -> CGFloat {
        return 0
    }

}
