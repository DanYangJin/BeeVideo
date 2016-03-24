//
//  RemmondedPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SpriteKit
import SDWebImage

class RemmondedPageView: BasePageView, UITableViewDataSource, UITableViewDelegate{
    
    private var baseViewController:BaseViewController!
    
    private var cycleImage:UIImageView!
    private var cycleTableView:UITableView!
    private var blockView:[BlockView]!
    private var blockSmall:[UIImageView]!
    private var blockMiddle:[UIImageView]!
    private var blockLarge:UIImageView!
    
    //data
    private var cycleItems:HomeSpace!
    
    //
    private var cyclePosition:Int = 0
    private var timer:NSTimer!
    private var isCycling:Bool {
        get{
            return self.isCycling
        }
        set{
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(2,
                    target:self,selector:Selector("tickDown"),
                    userInfo:nil,repeats:true)
            } else {
                if timer != nil {
                    timer.invalidate()
                    timer = nil
                }
            }
        }
    
    }
    
    /**
     *计时器每秒触发事件
     **/
    func tickDown()
    {
        if cyclePosition > cycleItems.items.count - 1 {
            cyclePosition = 0
        }
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[cyclePosition++].icon), placeholderImage: UIImage(named: "girl"))
    }
    
    func setController(baseViewController:BaseViewController){
        self.baseViewController = baseViewController
    }
    
   
    
    override func initView(){
        super.initView()

        cycleImage = UIImageView()
        cycleImage.frame = CGRectMake(0, 0, 220, 150)
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[0].icon), placeholderImage: UIImage(named: "girl"))
        addSubview(cycleImage)
        
        cycleTableView = UITableView()
        cycleTableView.frame = CGRect(x: 220, y: 0, width: 100, height: 150)
        cycleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cycleTableView.backgroundColor = UIColor.clearColor()
        cycleTableView.dataSource = self
        cycleTableView.delegate = self
        cycleTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CycleCell")
        addSubview(cycleTableView)
        
        for var index = 0; index < 3; index++ {
            let blockView = BlockView()
            blockView.initFrame(CGFloat(110 * index), y: 160, width: 100, height: 50)
            blockView.initView(super.homeSpace![index + 1])
            
            blockView.addOnClickListener(self, action: "click")
            
            addSubview(blockView)

        }
        
        
        
        for var index = 0; index < 2; index++ {
            let blockSmall = AnimationBlockView()
            blockSmall.initFrame(325, y: CGFloat(110 * index), width: 110, height: 100)
            blockSmall.initView(super.homeSpace![index + 5])
            addSubview(blockSmall)
        }

        for var index = 0; index < 2; index++ {
            let blockMiddle = AnimationBlockView()
            blockMiddle.initFrame(440, y: CGFloat(110 * index), width: 150, height: 100)
            blockMiddle.initView(super.homeSpace![index + 7])
            addSubview(blockMiddle)
        }


        let blockLarge = AnimationBlockView()
        blockLarge.initFrame(595, y: 0, width: 150, height: 210)
        blockLarge.initView(super.homeSpace![9])
        addSubview(blockLarge)
    
        
        isCycling = true
    }
    
    func click(){
        print("###onClick###")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycleItems.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CycleCell", forIndexPath: indexPath) 
        tableViewCell.backgroundColor = UIColor.clearColor()
        tableViewCell.textLabel?.textColor = UIColor.grayColor()
        tableViewCell.textLabel?.text = cycleItems.items[indexPath.row].name
        return tableViewCell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    override func getViewWidth() -> CGFloat {
        return 900
    }
    
    override func initData(){
        self.cycleItems = super.homeSpace![0]
    }
}
