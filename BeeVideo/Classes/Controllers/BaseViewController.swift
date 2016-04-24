//
//  BaseViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var backgroundImg : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .ScaleToFill
        self.view.addSubview(backgroundImg)
        backgroundImg.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        setBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setBackground(){
        backgroundImg.image = UIImage(named: "background")
        //self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background")!)
    
    }
    
    
    func onClick(){}
}
