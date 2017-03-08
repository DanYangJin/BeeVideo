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
    //var backView : BackView!
    var titleLbl : UILabel!
    var subTitleLbl : UILabel!
    var backView : UIButton!
    
    var leftWidth : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        contentView.delaysContentTouches = false
        contentView.tag = 20
        contentView.contentSize = CGSize(width: self.view.frame.width + CGFloat(leftWidth), height: self.view.frame.height)
        self.view.addSubview(contentView)
        
        leftView = UIView()
        contentView.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(leftWidth)
        }
        
        let leftViewBckground = UIImageView()
        leftViewBckground.contentMode = .redraw
        leftViewBckground.image = UIImage(named: "v2_search_keyboard_background")?.resizableImage(withCapInsets: UIEdgeInsets(top: 4,left: 20,bottom: 4,right: 20), resizingMode: .stretch)
        leftView.addSubview(leftViewBckground)
        leftViewBckground.snp.makeConstraints { (make) in
            make.left.right.equalTo(leftView)
            make.top.bottom.equalTo(leftView)
        }
        
        
        strinkView = UIImageView()
        strinkView = UIImageView()
        strinkView.contentMode = .scaleAspectFit
        strinkView.image = UIImage(named: "v2_arrow_shrink_right")
        contentView.addSubview(strinkView)
        strinkView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.height.equalTo(20)
            make.left.equalTo(leftView.snp.right)
            make.width.equalTo(20)
        }
            
        backView = UIButton()
        backView.setImage(UIImage(named: "v2_title_arrow_default"), for: UIControlState())
        backView.setImage(UIImage(named: "v2_title_arrow_selected"), for: .highlighted)
        backView.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(strinkView.snp.right)
            make.top.equalTo(25)
            make.height.width.equalTo(30)
        }
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.textColor = UIColor.white
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.right)
            make.centerY.equalTo(backView)
        }
        
        subTitleLbl = UILabel()
        subTitleLbl.font = UIFont.systemFont(ofSize: 12)
        subTitleLbl.textColor = UIColor.white
        contentView.addSubview(subTitleLbl)
        subTitleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLbl.snp.right).offset(5)
            make.centerY.equalTo(titleLbl)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 20 {
            if decelerate {
                //关闭惯性滑动
                DispatchQueue.main.async(execute: {[weak self] in
                    guard let strongSelf = self else{
                        return
                    }
                    scrollView.setContentOffset(scrollView.contentOffset, animated: false)
                    let xOffset = scrollView.contentOffset.x
                    if xOffset >= CGFloat(strongSelf.leftWidth / 2) {
                        scrollView.setContentOffset(CGPoint(x: CGFloat(strongSelf.leftWidth), y: 0), animated: true)
                    }else{
                        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                })
            }else{
                let xOffset = scrollView.contentOffset.x
                if xOffset >= CGFloat(leftWidth) / 2 {
                    scrollView.setContentOffset(CGPoint(x: CGFloat(leftWidth), y: 0), animated: true)
                }else{
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 20 {
            if strinkView != nil {
                let offsetX = scrollView.contentOffset.x
                let rotation = offsetX / CGFloat(leftWidth)
                strinkView.transform = CGAffineTransform(rotationAngle: -rotation * CGFloat(M_PI))
            }
        }
    }
    
    
}
