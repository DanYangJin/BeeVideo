//
//  ViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class TestViewController: BaseViewController{

    var fullView:FullKeyboardView!  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommenUtils.calculatScaleSize(10)
        fullView = FullKeyboardView()
        fullView.backgroundColor = UIColor.redColor()
        self.view.addSubview(fullView)
        fullView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.height.equalTo(100)
            make.width.equalTo(300)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    
}

