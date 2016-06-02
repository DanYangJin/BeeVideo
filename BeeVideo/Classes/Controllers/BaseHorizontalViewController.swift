//
//  BaseHorizontalViewController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/27.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class BaseHorizontalViewController: BaseViewController,UIScrollViewDelegate {
    
    var contentView : UIScrollView!
    var leftView : UIView!
    var strinkView : UIImageView!
    var backView : BackView!
    var titleLbl : UILabel!
    var subTitleLbl : UILabel!
    
    var leftWidth : Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        leftWidth = Float(view.frame.width * 0.2)
        initBaseView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initBaseView(){
        contentView = UIScrollView(frame: self.view.frame)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.bounces = false
        contentView.delegate = self
        contentView.tag = 0
        contentView.contentSize = CGSizeMake(self.view.frame.width * 1.2, self.view.frame.height)
        self.view.addSubview(contentView)

        
        leftView = UIView()
        contentView.addSubview(leftView)
        leftView.snp_makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(leftWidth)
        }
        
        strinkView = UIImageView()
        strinkView = UIImageView()
        strinkView.contentMode = .ScaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        contentView.addSubview(strinkView)
        strinkView.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
            make.left.equalTo(leftView.snp_right)
            make.width.equalTo(20)
        }
        
        backView = BackView()
        backView.addOnClickListener(self, action: #selector(self.dismissViewController))
        contentView.addSubview(backView)
        backView.snp_makeConstraints { (make) in
            make.left.equalTo(strinkView.snp_right)
            make.topMargin.equalTo(25)
            make.height.width.equalTo(30)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        contentView.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(backView.snp_right)
            make.centerY.equalTo(backView)
        }
        
        subTitleLbl = UILabel()
        subTitleLbl.font = UIFont.systemFontOfSize(12)
        subTitleLbl.textColor = UIColor.whiteColor()
        contentView.addSubview(subTitleLbl)
        subTitleLbl.snp_makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp_right).offset(5)
            make.centerY.equalTo(titleLbl)
        }
        
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 0 {
            if decelerate {
                //关闭惯性滑动
                dispatch_async(dispatch_get_main_queue(), {
                    scrollView.setContentOffset(scrollView.contentOffset, animated: false)
                    let xOffset = scrollView.contentOffset.x
                    if xOffset >= self.view.frame.width * 0.1 {
                        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.2, y: 0), animated: true)
                        self.strinkView.image = UIImage(named: "v2_arrow_shrink_left")
                    }else{
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        self.strinkView.image = UIImage(named: "v2_arrow_shrink_right")
                    }
                })
            }else{
                let xOffset = scrollView.contentOffset.x
                if xOffset >= self.view.frame.width * 0.1 {
                    scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.2, y: 0), animated: true)
                    self.strinkView.image = UIImage(named: "v2_arrow_shrink_left")
                }else{
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.strinkView.image = UIImage(named: "v2_arrow_shrink_right")
                }
            }
        }
    }
    

    
}
