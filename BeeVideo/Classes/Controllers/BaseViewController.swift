//
//  BaseViewController.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/18.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    fileprivate var backgroundImg : UIImageView!
    var loadingView : LoadingView!
    var errorView:ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .scaleToFill
        backgroundImg.image = UIImage(named: "background")
        self.view.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func setBackgroundImg(_ imgURL: String){
        backgroundImg.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "background"))
    }
    
    func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func onClick(){}
}
