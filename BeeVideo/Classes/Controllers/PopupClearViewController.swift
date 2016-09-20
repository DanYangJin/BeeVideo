//
//  PopupClearViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/9/9.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import PopupController

protocol ClearDelegate:class {
    func clearAll()
    func clearSelect()
}


class PopupClearViewController: UIViewController,PopupContentViewController {
    
    weak var delegate:ClearDelegate!
    var clearAllBtn:UIButton!
    var clearSelectBtn:UIButton!
    private var bgView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView = UIImageView(frame: self.view.frame)
        bgView.image = UIImage(named: "v2_choose_drama_dlg_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top:100, left: 5,bottom:100,right: 100), resizingMode: .Stretch)
        self.view.addSubview(bgView)
        
        clearSelectBtn = UIButton()
        clearSelectBtn.setTitle("清除选定", forState: .Normal)
        clearSelectBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        clearSelectBtn.setBackgroundImage(UIImage(named: "normal_bg"), forState: .Normal)
        clearSelectBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        clearSelectBtn.addTarget(self, action: #selector(self.clearSelect), forControlEvents: .TouchUpInside)
        self.view.addSubview(clearSelectBtn)
        
        clearAllBtn = UIButton()
        clearAllBtn.setTitle("清除所有", forState: .Normal)
        clearAllBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        clearAllBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        clearAllBtn.addTarget(self, action: #selector(self.clearAll), forControlEvents: .TouchUpInside)
        clearAllBtn.setBackgroundImage(UIImage(named: "normal_bg"), forState: .Normal)
        self.view.addSubview(clearAllBtn)
        
        clearSelectBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_centerX).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerY.equalTo(self.view)
        }
        
        clearAllBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_centerX).offset(10)
            make.top.bottom.equalTo(clearSelectBtn)
            make.width.equalTo(clearSelectBtn)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearAll(){
        guard delegate != nil else{
            return
        }
        delegate.clearAll()
    }
    
    func clearSelect(){
        guard delegate != nil else{
            return
        }
        delegate.clearSelect()
    }

    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 100)
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
