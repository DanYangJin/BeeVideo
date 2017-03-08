//
//  GuideViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController,UIScrollViewDelegate {
    
    fileprivate var guideScrollerView : UIScrollView!
    fileprivate let numOfPages = 3
    fileprivate var enterBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        guideScrollerView = UIScrollView()
        guideScrollerView.frame = frame
        guideScrollerView.isPagingEnabled = true
        guideScrollerView.showsVerticalScrollIndicator = false
        guideScrollerView.showsHorizontalScrollIndicator = false
        guideScrollerView.scrollsToTop = false
        guideScrollerView.bounces = false
        guideScrollerView.delegate = self
        guideScrollerView.contentSize = CGSize(width: frame.size.width * 3, height: frame.size.height)
        
        for i in 0 ..< numOfPages{
            let imageView = UIImageView(image: UIImage(named: "launcher_guide_\(i + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height)
            imageView.contentMode = .scaleToFill
            guideScrollerView.addSubview(imageView)
        }
        
        self.view.addSubview(guideScrollerView)
        
        enterBtn = UIButton()
        enterBtn.isEnabled = false
        enterBtn.addTarget(self, action: #selector(self.toLauncherController), for: .touchUpInside)
        self.view.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            //make.bottom.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-30)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / self.view.frame.width
        //print(currentPage)
        if currentPage == 2 {
            enterBtn.isEnabled = true
        }
    }
    
    
    func toLauncherController(){
        let controller = LauncherViewController()
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
