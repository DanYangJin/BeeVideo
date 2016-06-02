//
//  GuideViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController,UIScrollViewDelegate {
    
    private var guideScrollerView : UIScrollView!
    private let numOfPages = 3
    private var enterBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        guideScrollerView = UIScrollView()
        guideScrollerView.frame = frame
        guideScrollerView.pagingEnabled = true
        guideScrollerView.showsVerticalScrollIndicator = false
        guideScrollerView.showsHorizontalScrollIndicator = false
        guideScrollerView.scrollsToTop = false
        guideScrollerView.bounces = false
        guideScrollerView.delegate = self
        guideScrollerView.contentSize = CGSize(width: frame.size.width * 3, height: frame.size.height)
        
        for i in 0 ..< numOfPages{
            let imageView = UIImageView(image: UIImage(named: "launcher_guide_\(i + 1)"))
            imageView.frame = CGRectMake(frame.size.width * CGFloat(i), 0, frame.size.width, frame.size.height)
            imageView.contentMode = .ScaleToFill
            guideScrollerView.addSubview(imageView)
        }
        
        self.view.addSubview(guideScrollerView)
        
        enterBtn = UIButton()
        enterBtn.enabled = false
        enterBtn.addTarget(self, action: #selector(self.toLauncherController), forControlEvents: .TouchUpInside)
        self.view.addSubview(enterBtn)
        enterBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            //make.bottom.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / self.view.frame.width
        //print(currentPage)
        if currentPage == 2 {
            enterBtn.enabled = true
        }
    }
    
    
    func toLauncherController(){
        let controller = LauncherViewController()
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
