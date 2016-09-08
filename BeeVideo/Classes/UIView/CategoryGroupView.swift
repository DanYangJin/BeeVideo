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
    private var groupItems : Array<CategoryGroupItem>!
    
    private var blockView1:CateGroupBlockView!
    private var blockView2:CateGroupBlockView!
    private var blockView3:CateGroupBlockView!
    private var blockView4:CateGroupBlockView!
    private var blockView5:CateGroupBlockView!
    private var blockView6:CateGroupBlockView!
    private var blockView7:CateGroupBlockView!
    private var blockView8:CateGroupBlockView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGroupItems(items: Array<CategoryGroupItem>){
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
    
    private func setConstraints(){
        blockView1.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.48)
            make.width.equalTo(self.snp_height).multipliedBy(0.48)
        }
        
        blockView2.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView1.snp_right).offset(5)
            make.width.equalTo(blockView1).multipliedBy(1.7)
        }
        
        blockView3.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView2.snp_right).offset(5)
            make.width.equalTo(blockView1)
        }
        
        blockView4.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView1)
            make.left.equalTo(blockView3.snp_right).offset(5)
            make.width.equalTo(blockView1)
        }
        
        blockView5.snp_makeConstraints { (make) in
            make.height.width.equalTo(blockView1)
            make.left.equalTo(blockView1)
            make.bottom.equalTo(self)
        }
        
        blockView6.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView2)
        }
        
        blockView7.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView3)
        }
        
        blockView8.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(blockView5)
            make.left.right.equalTo(blockView4)
        }
    }
    
    func cateGroupBlockClick(categoryGroupItem: CategoryGroupItem) {
        let position = categoryGroupItem.position
        if position % 4 == 1 {
            let cateListController = VideoCategoryListController()
            cateListController.position = position
            cateListController.titleName = categoryGroupItem.name
            controller.presentViewController(cateListController, animated: true, completion: nil)
        }else{
            var extras = [ExtraData]()
            extras.append(ExtraData(name: "", value: categoryGroupItem.id))
            let cateController = VideoCategoryController()
            cateController.extras = extras
            controller.presentViewController(cateController, animated: true, completion: nil)
        }
    }

}
