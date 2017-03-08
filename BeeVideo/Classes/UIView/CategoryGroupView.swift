//
//  CategoryGroupView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/25.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

/**
 VideoCategoryGroupController 列表view
 */

 class CategoryGroupView: UIView,CateGroupBlockClick {
    
    var controller : UIViewController!
    fileprivate var groupItems : Array<CategoryGroupItem>!
    
    fileprivate var blockView1:CateGroupBlockView!
    fileprivate var blockView2:CateGroupBlockView!
    fileprivate var blockView3:CateGroupBlockView!
    fileprivate var blockView4:CateGroupBlockView!
    fileprivate var blockView5:CateGroupBlockView!
    fileprivate var blockView6:CateGroupBlockView!
    fileprivate var blockView7:CateGroupBlockView!
    fileprivate var blockView8:CateGroupBlockView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGroupItems(_ items: Array<CategoryGroupItem>){
        self.groupItems = items
        blockView1 = CateGroupBlockView()
        blockView1.setData(groupItems[0])
        blockView1.delegate = self
        self.addSubview(blockView1)
        
        blockView2 = CateGroupBlockView()
        blockView2.setData(groupItems[1])
        blockView2.delegate = self
        self.addSubview(blockView2)
        
        blockView3 = CateGroupBlockView()
        blockView3.setData(groupItems[2])
        blockView3.delegate = self
        self.addSubview(blockView3)
        
        blockView4 = CateGroupBlockView()
        blockView4.setData(groupItems[3])
        blockView4.delegate = self
        self.addSubview(blockView4)
        
        blockView5 = CateGroupBlockView()
        blockView5.setData(groupItems[4])
        blockView5.delegate = self
        self.addSubview(blockView5)
        
        blockView6 = CateGroupBlockView()
        blockView6.setData(groupItems[5])
        blockView6.delegate = self
        self.addSubview(blockView6)
        
        blockView7 = CateGroupBlockView()
        blockView7.setData(groupItems[6])
        blockView7.delegate = self
        self.addSubview(blockView7)
        
        blockView8 = CateGroupBlockView()
        blockView8.setData(groupItems[7])
        blockView8.delegate = self
        self.addSubview(blockView8)
        
        setConstraints()
    }
    
    fileprivate func setConstraints(){
        blockView1.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.48)
            make.width.equalTo(self.snp.height).multipliedBy(0.48)
        }
        
        blockView2.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView1.snp.right).offset(5)
            make.width.equalTo(blockView1).multipliedBy(1.7)
        }
        
        blockView3.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView2.snp.right).offset(5)
            make.width.equalTo(blockView1)
        }
        
        blockView4.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView3.snp.right).offset(5)
            make.width.equalTo(blockView1)
        }
        
        blockView5.snp.makeConstraints { (make) in
            make.height.width.equalTo(blockView1)
            make.left.equalTo(blockView1)
            make.bottom.equalTo(self)
        }
        
        blockView6.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView2)
        }
        
        blockView7.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView3)
        }
        
        blockView8.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView4)
        }
    }
    
    func cateGroupBlockClick(_ categoryGroupItem: CategoryGroupItem) {
        let position = categoryGroupItem.position
        if position % 4 == 1 {
            let cateListController = VideoCategoryListController()
            cateListController.position = position
            cateListController.titleName = categoryGroupItem.name
            controller.present(cateListController, animated: true, completion: nil)
        }else{
            var extras = [ExtraData]()
            extras.append(ExtraData(name: "", value: categoryGroupItem.id))
            let cateController = VideoCategoryController()
            cateController.extras = extras
            controller.present(cateController, animated: true, completion: nil)
        }
    }

}
