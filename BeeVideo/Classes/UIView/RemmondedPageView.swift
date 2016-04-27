//
//  RemmondedPageView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import SpriteKit


class RemmondedPageView: BasePageView, UITableViewDataSource, UITableViewDelegate, BlockViewDelegate{
    
    private var cycleImage:CornerImageView!
    private var cycleTableView:UITableView!
    //private var blockView:[BlockView]!
    //private var blockSmall:[CornerImageView]!
    //private var blockMiddle:[CornerImageView]!
    //private var blockLarge:CornerImageView!
    private var myVideoBlock : BlockView!
    
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
                                                               target:self,selector:#selector(RemmondedPageView.tickDown),
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
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[cyclePosition].icon), placeholderImage: UIImage(named: "girl"))
        cyclePosition += 1
    }
    
    
    override func initView(){
        super.initView()
        
        cycleImage = CornerImageView(frame: CGRectMake(0, 0, 220, 150))
        cycleImage.sd_setImageWithURL(NSURL(string: cycleItems.items[0].icon), placeholderImage: UIImage(named: "girl"))
        addSubview(cycleImage)
        
        cycleTableView = UITableView()
        cycleTableView.frame = CGRect(x: 220, y: 0, width: 100, height: 150)
        cycleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cycleTableView.backgroundColor = UIColor.clearColor()
        cycleTableView.dataSource = self
        cycleTableView.delegate = self
        cycleTableView.scrollEnabled = false
        cycleTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CycleCell")
        addSubview(cycleTableView)
        
        
        for index in 0 ..< 3 {
            let blockView = BlockView()
            blockView.initFrame(CGFloat(110 * index), y: 160, width: 100, height: 60)
            blockView.initView(super.homeSpace![index + 1])
            addSubview(blockView)
        }
        
        
        
        for index in 0 ..< 2 {
            let blockSmall = AnimationBlockView()
            blockSmall.initFrame(325, y: CGFloat(115 * index), width: 110, height: 105)
            blockSmall.initView(super.homeSpace![index + 4])
            blockSmall.setDelegate(self)
            addSubview(blockSmall)
        }
        
        for index in 0 ..< 2 {
            let blockMiddle = AnimationBlockView()
            blockMiddle.initFrame(440, y: CGFloat(115 * index), width: 150, height: 105)
            blockMiddle.initView(super.homeSpace![index + 6])
            blockMiddle.setDelegate(self)
            addSubview(blockMiddle)
        }
        
        
        let blockLarge = AnimationBlockView()
        blockLarge.initFrame(595, y: 0, width: 150, height: 220)
        blockLarge.initView(super.homeSpace![8])
        blockLarge.setDelegate(self)
        addSubview(blockLarge)
        //setConstraint()
        
        isCycling = true
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
        tableViewCell.selectionStyle = .None
        tableViewCell.textLabel?.textColor = UIColor.grayColor()
        tableViewCell.textLabel?.lineBreakMode = .ByClipping
        tableViewCell.textLabel?.text = cycleItems.items[indexPath.row].name
        return tableViewCell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        print(cycleItems.items[indexPath.row].action)
        
        let action:String = cycleItems.items[indexPath.row].action
        
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION" {
            let videoDetailViewController = VideoDetailViewController()
            videoDetailViewController.extras = cycleItems.items[indexPath.row].extras;
            self.viewController.presentViewController(videoDetailViewController, animated: true, completion: nil)
        }
    }
    
    private func setConstraint(){
        cycleImage.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(40)
            make.top.equalTo(self)
            make.height.equalTo(self.snp_height).multipliedBy(0.6)
            make.width.equalTo(cycleImage.snp_height).dividedBy(0.6)
        }
        cycleTableView.snp_makeConstraints { (make) in
            make.left.equalTo(cycleImage.snp_right).offset(2)
            make.top.equalTo(cycleImage)
            make.height.equalTo(cycleImage)
            make.width.equalTo(cycleImage.snp_width).dividedBy(2)
        }
    }
    
    
    //    func toDetailController(extras:String){
    //        let videoDetailViewController = VideoDetailViewController()
    //        //videoDetailViewController.extras = extras
    //        self.viewController.presentViewController(videoDetailViewController, animated: true, completion: nil)
    //    }
    
    func clickListener(homeSpace: HomeSpace) {
        
        let action:String = homeSpace.items[0].action
        if action == "com.mipt.videohj.intent.action.VOD_DETAIL_ACTION"{
            let detailViewController = VideoDetailViewController()
            detailViewController.extras = homeSpace.items[0].extras
            self.viewController.presentViewController(detailViewController, animated: true, completion: nil)
        }
        
    }
    
    
    override func getViewWidth() -> CGFloat {
        return 800
    }
    
    override func initData(){
        self.cycleItems = super.homeSpace![0]
    }
    
}
