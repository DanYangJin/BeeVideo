//
//  TestViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/4/21.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class TestViewController: BaseViewController {
    
    var videoDetailView : VideoDetailInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.whiteColor()
        
        videoDetailView = VideoDetailInfoView(frame:CGRectMake(0,0,568,320))
        videoDetailView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(videoDetailView)
        videoDetailView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
