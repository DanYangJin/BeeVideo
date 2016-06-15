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
    var loadingView : LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .ScaleToFill
        backgroundImg.image = UIImage(named: "background")
        self.view.addSubview(backgroundImg)
        backgroundImg.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setBackgroundImg(imgURL: String){
        backgroundImg.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: UIImage(named: "background"))
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onClick(){}
}
