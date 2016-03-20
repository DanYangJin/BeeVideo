//
//  RemmondedPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SpriteKit

class RemmondedPageView: BasePageView, UITableViewDataSource, UITableViewDelegate{

    
    private var cycleItems:[CycleItemInfo]!
    
    private var cycleImage:UIImageView!
    private var cycleTableView:UITableView!
    private var blockView:[BlockView]!
    private var blockSmall:[UIImageView]!
    private var blockMiddle:[UIImageView]!
    private var blockLarge:UIImageView!
    
    override func initView(){
        super.initView()
        cycleImage = UIImageView()
        cycleImage.frame = CGRectMake(0, 0, 220, 150)
        cycleImage.image = UIImage(named: "girl")
        addSubview(cycleImage)
        
        cycleTableView = UITableView()
        cycleTableView.frame = CGRect(x: 220, y: 0, width: 100, height: 150)
        cycleTableView.backgroundColor = UIColor.blueColor()
        cycleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cycleTableView.dataSource = self
        cycleTableView.delegate = self
        cycleTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CycleCell")
        addSubview(cycleTableView)
        
        for var index = 0; index < 3; index++ {
            let blockView = BlockView()
            blockView.initView(DataFactory.blockItems[index])
            blockView.frame = CGRect(x: 110*index, y: 160, width: 100, height: 60)
            addSubview(blockView)
        }
        
        for var index = 0; index < 2; index++ {
            let blockSmall = UIImageView()
            blockSmall.image = UIImage(named: "girl")
            blockSmall.frame = CGRect(x: 325, y: 115 * index, width: 110, height: 110)
            addSubview(blockSmall)
        }
        
        for var index = 0; index < 2; index++ {
            let blockMiddle = UIImageView()
            blockMiddle.image = UIImage(named: "girl")
            blockMiddle.frame = CGRect(x: 440, y: 115 * index, width: 150, height: 110)
            addSubview(blockMiddle)
        }
        
        for var index = 0; index < 2; index++ {
            let blockLarge = UIImageView()
            blockLarge.image = UIImage(named: "girl")
            blockLarge.frame = CGRect(x: 595, y: 0, width: 150, height: 340)
            addSubview(blockLarge)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycleItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CycleCell", forIndexPath: indexPath) 
        tableViewCell.backgroundColor = UIColor.clearColor()
        tableViewCell.textLabel?.textColor = UIColor.grayColor()
        tableViewCell.textLabel?.text = cycleItems[indexPath.row].desp
        return tableViewCell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    override func prepareLoadData(){
        self.cycleItems = DataFactory.cycleItems;
    }
    
    override func getViewWidth() -> CGFloat {
        return 800
    }

}
